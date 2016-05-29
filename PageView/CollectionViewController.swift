//
//  CollectionViewController.swift
//  PageView
//
//  Created by kingkong999yhirose on 2016/03/28.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.reloadData()
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 60
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
//        cell.contentView.subviews.flatMap { $0 as? UILabel }.first!.text = "\(indexPath.item)"
        cell.label.text = "\(indexPath.item)"
        return cell
    }
    deinit {
        print(#file + #function + "deinit")
    }
}

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
}

