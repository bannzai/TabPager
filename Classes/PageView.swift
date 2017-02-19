//
//  PageView.swift
//  PageView
//
//  Created by kingkong999yhirose on 2016/03/27.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

open class PageViewController: UIViewController {
    
    fileprivate var defaultViewController: UIViewController?
    fileprivate var viewControllers = [UIViewController]()
    fileprivate var selectionBarStyle: BarStyle = BarStyle()
    fileprivate var tabItemCollectionViewCellStylies = [TabStyle]()
    fileprivate var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    fileprivate var pageTabBar: PageTabBarView? {
        didSet {
            print("hoge")
        }
    }
    fileprivate var isMoving: Bool = false
    fileprivate var currentIndex: Int {
        return pageTabBar?.selectedIndex ?? 0
    }
    fileprivate lazy var scrollView: UIScrollView! = {
        return self.pageViewController.view.subviews.flatMap { $0 as? UIScrollView}.first
    }()
    
    public final var changedViewController: ((_ previousViewController: UIViewController, _ nextViewController: UIViewController) -> Void)?
    public final var changedIndex: ((_ previousIndex: Int, _ nextIndex: Int) -> Void)?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutPageTabBarView()
    }
    
    fileprivate func setupScrollView() {
        scrollView.scrollsToTop = false
        scrollView.delegate = self
    }
    
    open func setupWith(
        viewControllers pages: [UIViewController],
                        tabStylies: [TabStyle] = [],
                        bar: BarStyle = BarStyle(),
                        defaultViewController: UIViewController? = nil
        ) {
        selectionBarStyle = bar
        
        if tabStylies.isEmpty {
            tabItemCollectionViewCellStylies = pages.flatMap {
                TabStyle(title: $0.title)
            }
        } else {
            tabItemCollectionViewCellStylies = tabStylies
        }
        
        viewControllers = pages
        self.defaultViewController = defaultViewController
        
        if let defaultViewController = defaultViewController,
            let defaultIndex = viewControllers.index(of: defaultViewController) {
            tabItemCollectionViewCellStylies[defaultIndex].selected = true
        } else {
            tabItemCollectionViewCellStylies.first?.selected = true
        }
        
        pageViewController.view.removeFromSuperview()
        pageViewController.removeFromParentViewController()
        
        view.addSubview(pageViewController.view)
        addChildViewController(pageViewController)
        
        setupPageTabBarView()
        layoutPageTabBarView()
        setupViewControllers()
    }
    
    open func setupWith(
        pageElements elements: [(viewController: UIViewController, tabStyle: TabStyle)],
                     bar: BarStyle = BarStyle(),
                     defaultViewController: UIViewController? = nil
        ) {
        if elements.isEmpty {
            fatalError()
        }
        
        setupWith(viewControllers: elements.flatMap { $0.0 }, tabStylies: elements.flatMap{ $0.1 }, bar: bar, defaultViewController: defaultViewController)
    }
    
    fileprivate func setupPageTabBarView() {
        pageTabBar?.removeFromSuperview()
        pageTabBar = nil
        
        pageTabBar = PageTabBarView.viewFromNib() as? PageTabBarView
        pageTabBar?.didSelectItem = { [weak self] previousIndex, nextIndex in
            guard let viewControllers = self?.viewControllers else {
                return
            }
            self?.moveToViewController(previousIndex, nextIndex)
            if previousIndex != nextIndex {
                self?.changedViewController?(viewControllers[previousIndex], viewControllers[nextIndex])
                self?.changedIndex?(previousIndex, nextIndex)
            }
        }
        view.addSubview(pageTabBar!)
     }
    
    fileprivate func layoutPageTabBarView() {
        pageTabBar?.setupWith(selectionBarStyle, itemStylies: tabItemCollectionViewCellStylies)
    }
    
    fileprivate func moveToViewController(_ previousIndex: Int, _ nextIndex: Int) {
        isMoving = true
        let direction: UIPageViewControllerNavigationDirection
        if previousIndex < nextIndex {
            direction = .forward
        } else if previousIndex > nextIndex {
            direction = .reverse
        } else {
            return
        }
        
        pageViewController.setViewControllers([viewControllers[nextIndex]],
                                                   direction: direction,
                                                   animated: true,
                                                   completion: nil)
    }
    
    fileprivate func setupViewControllers() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
       
        pageViewController.setViewControllers([defaultViewController ?? viewControllers[0]],
                                                   direction: .forward,
                                                   animated: false,
                                                   completion: nil)
        
        pageViewController.didMove(toParentViewController: self)
        pageViewController.view.frame = CGRect(
            x: view.frame.origin.x,
            y: pageTabBar?.frame.size.height ?? view.frame.origin.y,
            width: view.frame.width,
            height: view.frame.height - (pageTabBar?.frame.size.height ?? 0)
        )
    }
    deinit {
        print(#file + #function + "deinit")
    }
}

extension PageViewController: UIScrollViewDelegate {
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isMoving = false
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isMoving {
            return
        }
        if scrollView.contentOffset.x == scrollView.frame.width {
            pageTabBar?.scrollUnderLine(0)
            return
        }
        if scrollView.contentOffset.x >= scrollView.frame.width * 2 {
            isMoving = true
            pageTabBar?.updateSelectedCellAndAnimateLine(toIndex: currentIndex + 1)
            pageTabBar?.scrollUnderLine(0)
            return
        }
        if scrollView.contentOffset.x <= 0 {
            isMoving = true
            pageTabBar?.updateSelectedCellAndAnimateLine(toIndex: currentIndex - 1)
            pageTabBar?.scrollUnderLine(0)
            return
        }
        
        let rate = pageTabBar?.calcRateForPageScrollView(scrollView) ?? 0
        let offsetX = -(scrollView.frame.width - scrollView.contentOffset.x) * rate
        pageTabBar?.scrollUnderLine(offsetX)
    }
}

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    // MARK: - UIPageViewController DataSource
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let page = viewControllers.index(of: viewController), page > 0
            else {
            return nil
        }
        
        return viewControllers[(page - 1)]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let page = viewControllers.index(of: viewController), page < viewControllers.endIndex - 1
            else {
            return nil
         }
        
        return viewControllers[(page + 1)]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            let previousViewController = previousViewControllers.first,
                let nextViewController = pageViewController.viewControllers?.first,
                let previousIndex = viewControllers.index(of: previousViewController),
                let nextIndex = viewControllers.index(of: nextViewController),
                previousIndex != nextIndex
            else {
                return
        }
        isMoving = false
        changedViewController?(previousViewController, nextViewController)
        changedIndex?(previousIndex, nextIndex)
    }
}
