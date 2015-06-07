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
    var selectedDrugIndex: Int?;
    var selectedCell: UICollectionViewCell?;
    var allDrugs: [Drug] = [];

    @IBOutlet var collectionView: UICollectionView!;
    @IBOutlet var recordButton: UIButton!;
    @IBOutlet var timePicker: UIDatePicker!;

    //MARK: View Life Cycle
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonPressed")
    }

    override func viewWillAppear(animated: Bool) {
        if (selectedCell == nil) {
            recordButton.enabled = false;
        }
        self.collectionView.reloadData();
        allDrugs = DataStore.sharedDataStore.getAllDrugs();
    }

    //MARK: IBActions
    @IBAction func recordButtonPressed() {
        assert(selectedDrugIndex != nil, "whoops");
        DataStore.sharedDataStore.recordDrug(allDrugs[selectedDrugIndex!], atDate: timePicker.date);
        recordButton.enabled = false;
        selectedCell!.backgroundColor = UIColor.clearColor();
        selectedCell = nil;
        selectedDrugIndex = nil;
    }

    func addButtonPressed() {
        self.performSegueWithIdentifier("NewDrugSegue", sender: self);
    }

    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        recordButton.enabled = true;

        selectedCell?.backgroundColor = UIColor.clearColor();
        selectedCell = collectionView.cellForItemAtIndexPath(indexPath);
        selectedCell!.backgroundColor = UIColor.selectedColor();
        selectedDrugIndex = indexPath.row;
    }

    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allDrugs.count;
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("DrugCollectionViewCell",
                                                                           forIndexPath: indexPath) as? DrugCollectionViewCell;
        assert(cell != nil, "Failed to create DrugCollectionViewCell");

        let drug = allDrugs[indexPath.row];
        cell!.imageView.image = UIImage(named: drug.iconFilename);
        cell!.label.text = drug.name;
        return cell!;
    }
}
