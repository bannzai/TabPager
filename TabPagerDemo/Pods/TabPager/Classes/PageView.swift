//
//  PageView.swift
//  PageView
//
//  Created by kingkong999yhirose on 2016/03/27.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

public class PageViewController: UIViewController {
    
    private var defaultViewController: UIViewController?
    private var viewControllers = [UIViewController]()
    private var selectionBarStyle: BarStyle = BarStyle()
    private var tabItemCollectionViewCellStylies = [TabStyle]()
    private var pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    private var pageTabBar: PageTabBarView?
    private var isMoving: Bool = false
    private var currentIndex: Int {
        return pageTabBar?.selectedIndex ?? 0
    }
    private lazy var scrollView: UIScrollView! = {
        return self.pageViewController.view.subviews.flatMap { $0 as? UIScrollView}.first
    }()
    
    public final var changedViewController: ((previousViewController: UIViewController, nextViewController: UIViewController) -> Void)?
    public final var changedIndex: ((previousIndex: Int, nextIndex: Int) -> Void)?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutPageTabBarView()
    }
    
    private func setupScrollView() {
        scrollView.scrollsToTop = false
        scrollView.delegate = self
    }
    
    public func setupWith(
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
            defaultIndex = viewControllers.indexOf(defaultViewController) {
            tabItemCollectionViewCellStylies[defaultIndex].selected = true
        } else {
            tabItemCollectionViewCellStylies.first?.selected = true
        }
        
        pageViewController.view.removeFromSuperview()
        pageViewController.removeFromParentViewController()
        
        view.addSubview(pageViewController.view)
        addChildViewController(pageViewController)
        
        setupPageTabBarView()
        setupViewControllers()
    }
    
    public func setupWith(
        pageElements elements: [(viewController: UIViewController, tabStyle: TabStyle)],
                     bar: BarStyle = BarStyle(),
                     defaultViewController: UIViewController? = nil
        ) {
        if elements.isEmpty {
            fatalError()
        }
        
        setupWith(viewControllers: elements.flatMap { $0.0 }, tabStylies: elements.flatMap{ $0.1 }, bar: bar, defaultViewController: defaultViewController)
    }
    
    private func setupPageTabBarView() {
        pageTabBar?.removeFromSuperview()
        pageTabBar = nil
        
        pageTabBar = PageTabBarView.viewFromNib() as? PageTabBarView
        pageTabBar?.didSelectItem = { [weak self] previousIndex, nextIndex in
            guard let viewControllers = self?.viewControllers else {
                return
            }
            self?.moveToViewController(previousIndex, nextIndex)
            if previousIndex != nextIndex {
                self?.changedViewController?(previousViewController: viewControllers[previousIndex], nextViewController: viewControllers[nextIndex])
                self?.changedIndex?(previousIndex: previousIndex, nextIndex: nextIndex)
            }
        }
        view.addSubview(pageTabBar!)
     }
    
    private func layoutPageTabBarView() {
        pageTabBar?.setupWith(selectionBarStyle, itemStylies: tabItemCollectionViewCellStylies)
    }
    
    private func moveToViewController(previousIndex: Int, _ nextIndex: Int) {
        isMoving = true
        let direction: UIPageViewControllerNavigationDirection
        if previousIndex < nextIndex {
            direction = .Forward
        } else if previousIndex > nextIndex {
            direction = .Reverse
        } else {
            return
        }
        
        pageViewController.setViewControllers([viewControllers[nextIndex]],
                                                   direction: direction,
                                                   animated: true,
                                                   completion: nil)
    }
    
    private func setupViewControllers() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
       
        pageViewController.setViewControllers([defaultViewController ?? viewControllers[0]],
                                                   direction: .Forward,
                                                   animated: false,
                                                   completion: nil)
        
        pageViewController.didMoveToParentViewController(self)
        pageViewController.view.frame = CGRectMake(
            view.frame.origin.x,
            pageTabBar?.frame.size.height ?? view.frame.origin.y,
            CGRectGetWidth(view.frame),
            CGRectGetHeight(view.frame) - (pageTabBar?.frame.size.height ?? 0)
        )
    }
    deinit {
        print(#file + #function + "deinit")
    }
}

extension PageViewController: UIScrollViewDelegate {
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        isMoving = false
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
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
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard
            let page = viewControllers.indexOf(viewController)
            where page > 0
            else {
            return nil
        }
        
        return viewControllers[page.predecessor()]
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard
            let page = viewControllers.indexOf(viewController)
            where page < viewControllers.endIndex - 1
            else {
            return nil
         }
        
        return viewControllers[page.successor()]
    }
    
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            let previousViewController = previousViewControllers.first,
                nextViewController = pageViewController.viewControllers?.first,
                previousIndex = viewControllers.indexOf(previousViewController),
                nextIndex = viewControllers.indexOf(nextViewController)
            where
                previousIndex != nextIndex
            else {
                return
        }
        isMoving = false
        changedViewController?(previousViewController: previousViewController, nextViewController: nextViewController)
        changedIndex?(previousIndex: previousIndex, nextIndex: nextIndex)
    }
}
