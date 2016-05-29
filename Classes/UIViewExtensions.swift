//
//  UIViewExtensions.swift
//  PageView
//
//  Created by kingkong999yhirose on 2016/05/29.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit


extension UIView {
    class var className: String {
        let className = NSStringFromClass(self)
        let range = className.rangeOfString(".")
        return className.substringFromIndex(range!.endIndex)
    }
    
    class func nib() -> UINib {
        let bundle = NSBundle(forClass: self)
        return UINib(nibName: className, bundle: bundle)
    }
    
    class func viewFromNib() -> UIView {
        return nib().instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
}