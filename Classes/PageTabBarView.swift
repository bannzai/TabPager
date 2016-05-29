//
//  PageTabBarView.swift
//  PageView
//
//  Created by kingkong999yhirose on 2016/05/29.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

final class PageTabBarView: UIView {
    @IBOutlet private weak var underLine: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    @IBOutlet private weak var underLineLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var underLineWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var underLineHeightConstraint: NSLayoutConstraint!
    
    private var style: BarStyle?
    private var itemStylies: [TabStyle] = []
    
    final var selectedIndex: Int {
        return itemStylies.enumerate().filter({ $1.selected }).first?.index ?? 0
    }
    private var selectedIndexPath: NSIndexPath {
        return NSIndexPath(forItem: selectedIndex, inSection: 0)
    }
    private var selectedCell: TabItemCollectionViewCell? {
        return cell(selectedIndexPath)
    }
    private func cell(indexPath: NSIndexPath) -> TabItemCollectionViewCell? {
        return collectionView.cellForItemAtIndexPath(indexPath) as? TabItemCollectionViewCell
    }
    private var selectedTabStyle: TabStyle {
        return itemStylies[selectedIndex]
    }
    private var cellSize: CGSize = CGSizeZero
    final var didSelectItem:((previousIndex: Int, nextIndex: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.scrollsToTop = false
        collectionView.registerNib(TabItemCollectionViewCell.nib(), forCellWithReuseIdentifier: TabItemCollectionViewCell.className)
    }
    
    final func setupWith(barStyle: BarStyle, itemStylies: [TabStyle]) {
        if itemStylies.count == 0 {
            return
        }
        
        style = barStyle
        self.itemStylies = itemStylies
        
        frame.size = CGSizeMake(frame.size.width, barStyle.height)
        backgroundColor = barStyle.backgroundColor
        
        setupUnderLine(itemStylies.first!)
        collectionView.reloadData()
        
        frame = CGRectMake(0, 0, style!.width, style!.height)
    }
    
    private func setupUnderLine(itemStyle: TabStyle) {
        configureUnderLineStyle(itemStyle)
    }
    
    private func animateUnderLine(toIndex index: Int) {
        animateUnderLine(itemStylies[index])
    }
    
    final func scrollUnderLine(distance: CGFloat) {
        underLineLeftConstraint.constant = distance + CGFloat(selectedIndex) * cellSize.width
    }
    
    final func pageViewScrollViewDidScroll(scrollView: UIScrollView) {
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
    
    final func calcRateForPageScrollView(scrollView: UIScrollView) -> CGFloat {
        return cellSize.width / scrollView.frame.width
    }
    
    private func animateUnderLine(itemStyle: TabStyle) {
        configureUnderLineStyle(itemStyle)
        UIView.animateWithDuration(
            0.2,
            delay: 0,
            options: .CurveEaseInOut,
            animations: layoutIfNeeded,
            completion: nil
        )
    }
    
    private func configureUnderLineStyle(itemStyle: TabStyle) {
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
    
    private func updateSelectedCell(toIndex index: Int) {
        itemStylies.forEach { $0.selected = false }
        let selectedStyle = itemStylies[index]
        selectedStyle.selected = true
    }
    deinit {
        print(#file + #function + "deinit")
    }
}

extension PageTabBarView: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemStylies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TabItemCollectionViewCell.className, forIndexPath: indexPath) as! TabItemCollectionViewCell
        cell.setupWith(style!, itemStyle: itemStylies[indexPath.item])
        return cell
    }
}

extension PageTabBarView: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let style = style else {
            return CGSizeZero
        }
        if cellSize == CGSizeZero {
            cellSize = CGSizeMake(floor(style.width / CGFloat(itemStylies.count)), style.height - style.lineHeight)
        }
        return cellSize
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let previousIndex = selectedIndex
        updateSelectedCellAndAnimateLine(toIndex: indexPath.item)
        didSelectItem?(previousIndex: previousIndex, nextIndex: selectedIndex)
    }
}