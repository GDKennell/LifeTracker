//
//  NewDrugViewController.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 6/7/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation
import UIKit

class NewDrugCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!;
}

class NewDrugViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    //MARK: Properties
    @IBOutlet var drugNameTextField: UITextField!;
    @IBOutlet var addButton: UIButton!;

    var selectedDrugIndex: Int?;
    var selectedCell: UICollectionViewCell?;

    //MARK: View Life Cycle
    override func viewDidLoad() {
        drugNameTextField.addTarget(self, action: Selector("updateAddButton"), forControlEvents: .EditingChanged)
    }

    override func viewWillAppear(animated: Bool) {
        drugNameTextField.text = "";
        selectedCell?.backgroundColor = UIColor.clearColor();
        selectedCell = nil;
        selectedDrugIndex = nil;
        updateAddButton();
    }

    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedCell?.backgroundColor = UIColor.clearColor();
        selectedDrugIndex = indexPath.row;
        selectedCell = collectionView.cellForItemAtIndexPath(indexPath);
        selectedCell!.backgroundColor = UIColor.selectedColor();

        updateAddButton();
    }

    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AllDrugIconFilenames.count;
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewDrugCollectionViewCell",
            forIndexPath: indexPath) as? NewDrugCollectionViewCell;
        assert(cell != nil, "Failed to create NewDrugCollectionViewCell");

        let drugIconFilename = AllDrugIconFilenames[indexPath.row];
        cell!.imageView.image = UIImage(named: drugIconFilename);

        return cell!;
    }

    //MARK: IBActions

    @IBAction func addButtonPressed() {
        AllDrugs.insertAtEnd(Drug(name: drugNameTextField.text,
                          iconFilename: AllDrugIconFilenames[selectedDrugIndex!]));
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    @IBAction func cancelButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    //MARK: Helpers
    func updateAddButton() {
        addButton.enabled = (selectedCell != nil && !drugNameTextField.text.isEmpty);
    }
}
