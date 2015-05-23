//
//  SecondViewController.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 4/28/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import UIKit

class TodayListViewTableViewCell: UITableViewCell {
    @IBOutlet var iconImageView: UIImageView!;
    @IBOutlet var topLabel: UILabel!;
    @IBOutlet var bottomLabel: UILabel!;
    @IBOutlet var timestampLabel: UILabel!;
}

class TodayListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Properties
    @IBOutlet var tableView: UITableView!;
    var stateArray: [StateEvent]?;

    // MARK: Lifetime

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateData();
    }

    override func viewWillAppear(animated: Bool) {
        self.updateData();
        self.navigationItem.title = "Today";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
    }

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete;
    }

    // MARK: UITableViewDataSource

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var newCell = tableView.dequeueReusableCellWithIdentifier("TodayListViewTableViewCell") as? TodayListViewTableViewCell;
        if (newCell == nil) {
            assertionFailure("Failed to create TodayListViewTableViewCell from reuse identifier");
        }
        assert(self.stateArray != nil && self.stateArray!.count >= indexPath.row + 1, "")

        let state = stateArray![indexPath.row];
        newCell!.timestampLabel.text = state.eventDate.timeString();

        newCell!.iconImageView.image = state.iconImage;
        newCell!.topLabel.text = state.mainDisplayText;
        newCell!.bottomLabel.text = state.secondaryDisplayText;

        return newCell!;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.stateArray != nil) ? self.stateArray!.count : 0;
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    // Editing

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }

    // MARK: Helpers

    func updateData() {
        stateArray = DataStore.sharedDataStore.getStatesFrom(min(NSDate.startOfDay(), NSDate.now() - kTimeInterval12hours),
                                                         to: NSDate.endOfDay());
        tableView.reloadData();
    }
}

