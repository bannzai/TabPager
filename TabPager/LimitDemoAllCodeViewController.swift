//
//  LimitDemoAllCodeViewController.swift
//  PageView
//
//  Created by kingkong999yhirose on 2016/05/30.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

class LimitDemoAllCodeViewController: UIViewController {

    private var pageViewController = PageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageViewController()
    }
    
    private func setupPageViewController() {
        pageViewController.setupWith(
            pageElements: [
                (viewController: TableViewController.viewController(),
                    tabStyle: TabStyle() {
                        $0.title = "First"
                    }
                ),
                (viewController: CollectionViewController.viewController(),
                    tabStyle: TabStyle() {
                        $0.title = "Second"
                    }
                ),
                (viewController: CollectionViewController.viewController(),
                    tabStyle: TabStyle() {
                        $0.title = "Third"
                    }
                )
            ],
            bar: BarStyle() {
                $0.backgroundColor = UIColor.lightGrayColor()
            }
        )
        pageViewController.changedViewController = { previousViewController, nextViewController in
            print("previousViewController: \(previousViewController)")
            print("nextViewController: \(nextViewController)")
        }
        pageViewController.changedIndex = { previousIndex, nextIndex in
            print("previousIndex: \(previousIndex)")
            print("nextIndex: \(nextIndex)")
        }
        
        view.addSubview(pageViewController.view)
        pageViewController.view.frame = view.frame
        let topBarHeight = (navigationController?.navigationBar.frame.height ?? 0) + (UIApplication.sharedApplication().statusBarFrame.height ?? 0)
        pageViewController.view.frame.origin.y = topBarHeight
        pageViewController.view.frame.size.height -= topBarHeight
    }
    
    deinit {
        print(#file + #function + "deinit")
    }
}