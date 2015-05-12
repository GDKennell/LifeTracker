//
//  DrugInputViewController.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 5/11/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation
import UIKit

class DrugCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!;
    @IBOutlet var label: UILabel!;
}

class DrugInputViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK: Properties
    let drugArray: [Drug] = AllDrugs;

    override func viewDidLoad() {

    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drugArray.count;
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("DrugCollectionViewCell",
                                                                           forIndexPath: indexPath) as? DrugCollectionViewCell;
        assert(cell != nil, "Failed to create DrugCollectionViewCell");

        let drug = drugArray[indexPath.row];
        cell!.imageView.image = UIImage(named: drug.iconFileName);
        cell!.label.text = drug.drugName;

        return cell!;
    }
}
