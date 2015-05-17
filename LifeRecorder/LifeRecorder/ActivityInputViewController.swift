//
//  ActivityInputViewController.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 5/16/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation

import UIKit

class ActivityCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!;
    @IBOutlet var label: UILabel!;
}

class ActivityInputViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK: Properties
    var selectedActivityIndex: Int?;
    var selectedCell: UICollectionViewCell?;

    @IBOutlet var recordButton: UIButton!;
    @IBOutlet var timePicker: UIDatePicker!;

    //MARK: View Life Cycle
    override func viewDidLoad() {

    }

    override func viewWillAppear(animated: Bool) {
        if (selectedCell == nil) {
            recordButton.enabled = false;
        }
    }

    //MARK: IBActions
    @IBAction func recordButtonPressed() {
        assert(selectedActivityIndex != nil, "whoops");
        DataStore.sharedDataStore.recordActivity(Activity(rawValue: selectedActivityIndex!), atDate: timePicker.date);
        recordButton.enabled = false;
        selectedCell!.backgroundColor = UIColor.clearColor();
        selectedCell = nil;
        selectedActivityIndex = nil;
    }

    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        recordButton.enabled = true;

        selectedCell?.backgroundColor = UIColor.clearColor();
        selectedCell = collectionView.cellForItemAtIndexPath(indexPath);
        selectedCell!.backgroundColor = UIColor.selectedColor();
        selectedActivityIndex = indexPath.row;
    }

    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Activity.count;
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActivityCollectionViewCell",
            forIndexPath: indexPath) as? ActivityCollectionViewCell;
        assert(cell != nil, "Failed to create ActivityCollectionViewCell");

        let activity = Activity(rawValue: indexPath.row);
        cell!.imageView.image = UIImage(named: ActivityIconFilenames[activity!.rawValue]);
        cell!.label.text = ActivityStrings[activity!.rawValue];

        return cell!;
    }
}
