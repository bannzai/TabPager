//
//  TabItemCollectionViewCell.swift
//  PageView
//
//  Created by kingkong999yhirose on 2016/05/29.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

final class TabItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var style: TabStyle?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = ""
    }
    
    final func setupWith(
        barStyle: BarStyle,
        itemStyle: TabStyle
        ) {
        
        style = itemStyle
        configureStyle(itemStyle)
    }
    
    final func changeSelected(selected: Bool) {
        guard let style = style else {
            return
        }
        if style.selected == selected {
            return
        }
        
        style.selected = selected
        configureStyle(style)
    }
    
    private func configureStyle(itemStyle: TabStyle) {
        configureTitleStyle(itemStyle)
    }
    
    private func configureTitleStyle(itemStyle: TabStyle) {
        titleLabel?.text = itemStyle.title
        titleLabel?.textColor = itemStyle.titleColor
        titleLabel?.font = itemStyle.font
    }
    
    deinit {
        print(#file + #function + "deinit")
    }
    
}
