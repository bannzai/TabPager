
//
//  Style.swift
//  PageView
//
//  Created by kingkong999yhirose on 2016/05/29.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

public class TabStyle {
    public var title: String? = nil
    public var selected: Bool = false
    public var selectedColor: UIColor = UIColor.blackColor()
    public var notSelectedColor: UIColor = UIColor.grayColor()
    public var font: UIFont = UIFont.systemFontOfSize(14)
    
    public init() { }
    
    public init(@noescape _ initializer: TabStyle -> Void) {
        initializer(self)
    }
    
    public init(title: String?) {
        self.title = title
    }
    
    public var titleColor: UIColor {
        return selected ? selectedColor : notSelectedColor
    }
}

public class BarStyle {
    public var height: CGFloat = 44
    public var width: CGFloat = CGRectGetWidth(UIScreen.mainScreen().bounds)
    public var backgroundColor = UIColor.whiteColor()
    public var lineHeight: CGFloat = 1
    
    public init () { }
    public init(@noescape _ initializer: BarStyle -> Void) {
        initializer(self)
    }
    
}