//
//  TabItemCollectionViewCell.swift
//  PageView
//
//  Created by kingkong999yhirose on 2016/05/29.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

final class TabItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    
    fileprivate var style: TabStyle?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = ""
    }
    
    final func setupWith(
        _ barStyle: BarStyle,
        itemStyle: TabStyle
        ) {
        
        style = itemStyle
        configureStyle(itemStyle)
    }
    
    final func changeSelected(_ selected: Bool) {
        guard let style = style else {
            return
        }
        if style.selected == selected {
            return
        }
        
        style.selected = selected
        configureStyle(style)
    }
    
    fileprivate func configureStyle(_ itemStyle: TabStyle) {
        configureTitleStyle(itemStyle)
    }
    
    fileprivate func configureTitleStyle(_ itemStyle: TabStyle) {
        titleLabel?.text = itemStyle.title
        titleLabel?.textColor = itemStyle.titleColor
        titleLabel?.font = itemStyle.font
    }
    
    deinit {
        print(#file + #function + "deinit")
    }
    
}
