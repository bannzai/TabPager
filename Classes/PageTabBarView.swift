//
//  PageTabBarView.swift
//  PageView
//
//  Created by kingkong999yhirose on 2016/05/29.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

final class PageTabBarView: UIView {
    @IBOutlet fileprivate weak var underLine: UIView!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    @IBOutlet fileprivate weak var underLineLeftConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var underLineWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var underLineHeightConstraint: NSLayoutConstraint!
    
    fileprivate var style: BarStyle?
    fileprivate var itemStylies: [TabStyle] = []
    
    final var selectedIndex: Int {
        return itemStylies.enumerated().filter({ $1.selected }).first?.offset ?? 0
    }
    fileprivate var selectedIndexPath: IndexPath {
        return IndexPath(item: selectedIndex, section: 0)
    }
    fileprivate var selectedCell: TabItemCollectionViewCell? {
        return cell(for: selectedIndexPath)
    }
    fileprivate func cell(for indexPath: IndexPath) -> TabItemCollectionViewCell? {
        return collectionView.cellForItem(at: indexPath) as? TabItemCollectionViewCell
    }
    fileprivate var selectedTabStyle: TabStyle {
        return itemStylies[selectedIndex]
    }
    fileprivate var cellSize: CGSize = CGSize.zero
    final var didSelectItem:((_ previousIndex: Int, _ nextIndex: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.scrollsToTop = false
        collectionView.register(TabItemCollectionViewCell.nib(), forCellWithReuseIdentifier: TabItemCollectionViewCell.className)
    }
    
    final func setupWith(_ barStyle: BarStyle, itemStylies: [TabStyle]) {
        if itemStylies.count == 0 {
            return
        }
        
        style = barStyle
        self.itemStylies = itemStylies
        
        frame.size = CGSize(width: frame.size.width, height: barStyle.height)
        backgroundColor = barStyle.backgroundColor
        
        setupUnderLine(with: itemStylies.first!)
        collectionView.reloadData()
        
        frame = CGRect(x: 0, y: 0, width: style!.width, height: style!.height)
    }
    
    fileprivate func setupUnderLine(with itemStyle: TabStyle) {
        configureUnderLineStyle(with: itemStyle)
    }
    
    fileprivate func animateUnderLine(toIndex index: Int) {
        animateUnderLine(for: itemStylies[index])
    }
    
    final func scrollUnderLine(_ distance: CGFloat) {
        underLineLeftConstraint.constant = distance + CGFloat(selectedIndex) * cellSize.width
    }
    
    final func pageViewScrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == scrollView.frame.width {
            scrollUnderLine(0)
            return
        }
        if scrollView.contentOffset.x >= scrollView.frame.width * 2 {
            updateSelectedCellAndAnimateLine(toIndex: selectedIndex + 1)
            scrollUnderLine(0)
            return
        }
        if scrollView.contentOffset.x <= 0 {
            updateSelectedCellAndAnimateLine(toIndex: selectedIndex - 1)
            scrollUnderLine(0)
            return
        }
        
        let rate = cellSize.width / scrollView.frame.width
        let offsetX = -(scrollView.frame.width - scrollView.contentOffset.x) * rate
        scrollUnderLine(offsetX)
    }
    
    final func calcRateForPageScrollView(_ scrollView: UIScrollView) -> CGFloat {
        return cellSize.width / scrollView.frame.width
    }
    
    fileprivate func animateUnderLine(for itemStyle: TabStyle) {
        configureUnderLineStyle(with:itemStyle)
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseInOut,
            animations: layoutIfNeeded,
            completion: nil
        )
    }
    
    fileprivate func configureUnderLineStyle(with itemStyle: TabStyle) {
        guard let style = style else {
            fatalError()
        }
        underLine.backgroundColor = itemStyle.selectedColor
        underLineWidthConstraint.constant = style.width / CGFloat(itemStylies.count)
        underLineLeftConstraint.constant = selectedCell?.frame.origin.x ?? 0
        underLineHeightConstraint.constant = style.lineHeight
    }
    
    final func updateSelectedCellAndAnimateLine(toIndex index: Int) {
        let toIndex: Int
        if index < 0 {
           toIndex = 0
        } else if index > itemStylies.count - 1 {
            toIndex = itemStylies.count - 1
        } else {
            toIndex = index
        }
        updateSelectedCell(toIndex: toIndex)
        animateUnderLine(toIndex: toIndex)
        collectionView.reloadData()
    }
    
    fileprivate func updateSelectedCell(toIndex index: Int) {
        itemStylies.forEach { $0.selected = false }
        let selectedStyle = itemStylies[index]
        selectedStyle.selected = true
    }
    deinit {
        print(#file + #function + "deinit")
    }
}

extension PageTabBarView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemStylies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabItemCollectionViewCell.className, for: indexPath) as! TabItemCollectionViewCell
        cell.setupWith(style!, itemStyle: itemStylies[indexPath.item])
        return cell
    }
}

extension PageTabBarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let style = style else {
            return CGSize.zero
        }
        if cellSize == CGSize.zero {
            cellSize = CGSize(width: floor(style.width / CGFloat(itemStylies.count)), height: style.height - style.lineHeight)
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndex = selectedIndex
        updateSelectedCellAndAnimateLine(toIndex: indexPath.item)
        didSelectItem?(previousIndex, selectedIndex)
    }
}
