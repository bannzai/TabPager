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
        return String(describing: classForCoder()).components(separatedBy: ".").last!
    }
    
    static func viewController() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: self.className)
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
                        $0.selectedColor = UIColor.red
                        $0.notSelectedColor = UIColor.orange
                    }
                ),
                (viewController: CollectionViewController.viewController(),
                    tabStyle: TabStyle() {
                        $0.title = "Second"
                        $0.selectedColor = UIColor.blue
                        $0.notSelectedColor = UIColor.yellow
                    }
                ),
                (viewController: defaultViewController,
                    tabStyle: TabStyle() {
                        $0.title = "Third"
                        $0.selectedColor = UIColor.black
                        $0.notSelectedColor = UIColor.brown
                    }
                )
            ],
            bar: BarStyle() {
                $0.backgroundColor = UIColor.cyan
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Embed" {
            pageViewController = segue.destination as! PageViewController
        }
    }
    
    deinit {
        print(#file + #function + "deinit")
    }
}

