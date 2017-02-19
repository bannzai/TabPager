
//
//  Style.swift
//  PageView
//
//  Created by kingkong999yhirose on 2016/05/29.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

open class TabStyle {
    open var title: String? = nil
    open var selected: Bool = false
    open var selectedColor: UIColor = UIColor.black
    open var notSelectedColor: UIColor = UIColor.gray
    open var font: UIFont = UIFont.systemFont(ofSize: 14)
    
    public init() { }
    
    public init(_ initializer: (TabStyle) -> Void) {
        initializer(self)
    }
    
    public init(title: String?) {
        self.title = title
    }
    
    open var titleColor: UIColor {
        return selected ? selectedColor : notSelectedColor
    }
}

open class BarStyle {
    open var height: CGFloat = 44
    open var width: CGFloat = UIScreen.main.bounds.width
    open var backgroundColor = UIColor.white
    open var lineHeight: CGFloat = 1
    
    public init () { }
    public init(_ initializer: (BarStyle) -> Void) {
        initializer(self)
    }
    
}
