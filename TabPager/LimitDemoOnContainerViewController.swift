//
//  ViewController.swift
//  PageView
//
//  Created by kingkong999yhirose on 2016/03/27.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

extension UIViewController {
    class var className: String {
        let className = NSStringFromClass(self)
        let range = className.rangeOfString(".")
        return className.substringFromIndex(range!.endIndex)
    }
    
    static func viewController() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(self.className)
    }
}

class LimitDemoOnContainerViewController: UIViewController {
    
    private var pageViewController: PageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageViewController()
    }
    
    private func setupPageViewController() {
        let defaultViewController = CollectionViewController.viewController()
        pageViewController.setupWith(
            pageElements: [
                (viewController: TableViewController.viewController(),
                    tabStyle: TabStyle() {
                        $0.title = "First"
                        $0.selectedColor = UIColor.redColor()
                        $0.notSelectedColor = UIColor.orangeColor()
                    }
                ),
                (viewController: CollectionViewController.viewController(),
                    tabStyle: TabStyle() {
                        $0.title = "Second"
                        $0.selectedColor = UIColor.blueColor()
                        $0.notSelectedColor = UIColor.yellowColor()
                    }
                ),
                (viewController: defaultViewController,
                    tabStyle: TabStyle() {
                        $0.title = "Third"
                        $0.selectedColor = UIColor.blackColor()
                        $0.notSelectedColor = UIColor.brownColor()
                    }
                )
            ],
            bar: BarStyle() {
                $0.backgroundColor = UIColor.cyanColor()
                $0.lineHeight = 10
            },
            defaultViewController: defaultViewController
        )
        pageViewController.changedViewController = { previousViewController, nextViewController in
            print("previousViewController: \(previousViewController)")
            print("nextViewController: \(nextViewController)")
        }
        pageViewController.changedIndex = { previousIndex, nextIndex in
            print("previousIndex: \(previousIndex)")
            print("nextIndex: \(nextIndex)")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Embed" {
            pageViewController = segue.destinationViewController as! PageViewController
        }
    }
    
    deinit {
        print(#file + #function + "deinit")
    }
}

