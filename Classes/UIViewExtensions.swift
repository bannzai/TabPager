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
        let range = className.range(of: ".")
        return className.substring(from: range!.upperBound)
    }
    
    class func nib() -> UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: className, bundle: bundle)
    }
    
    class func viewFromNib() -> UIView {
        return nib().instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
