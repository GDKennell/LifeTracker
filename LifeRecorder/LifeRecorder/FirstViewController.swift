//
//  FirstViewController.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 4/28/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import UIKit

let MoodRowIndex = 0;
let SleepRowIndex = 1;
let ActivitiesRowIndex = 2;
let DrugsRowIndex = 3;

class FirstViewControllerTableViewCell : UITableViewCell {
    @IBOutlet var bigTextLabel: UILabel?;
}

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Properties
    var moodInputViewController: MoodInputViewController?;

    let sectionTitles = ["Mood", "Sleep", "Activities", "Drugs"];

    @IBOutlet var tableView: UITableView?;

    // MARK: Lifetime

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        tabBarItem.title = "Input";
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case MoodRowIndex:
            self.performSegueWithIdentifier("MoodIdentifierSegue", sender: self);
        case SleepRowIndex:
            self.performSegueWithIdentifier("SleepSegue", sender: self);
        default:
            UIAlertView(title: "Oops!", message: "I havnen't built that yet", delegate: nil, cancelButtonTitle: "Ok").show();
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
    }

    // MARK: UITableViewDataSource

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var newCell = tableView.dequeueReusableCellWithIdentifier("FirstViewTableViewCell") as? FirstViewControllerTableViewCell;
        if (newCell == nil) {
            assertionFailure("Failed to create FirstViewTableViewCell from reuse identifier");
        }
        newCell!.bigTextLabel!.text = sectionTitles[indexPath.row];
        return newCell!;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionTitles.count;
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return floor(tableView.frameHeight / CGFloat(sectionTitles.count));
    }

}
















































