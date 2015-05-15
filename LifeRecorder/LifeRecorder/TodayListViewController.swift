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
    @IBOutlet var moodLabel: UILabel!;
    @IBOutlet var energyLabel: UILabel!;
    @IBOutlet var timestampLabel: UILabel!;
}

class TodayListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Properties
    @IBOutlet var tableView: UITableView!;
    var stateArray: [StateEvent]?;

    // MARK: Lifetime

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        tabBarItem.title = "Today";
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateData();
    }

    override func viewWillAppear(animated: Bool) {
        self.updateData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

    // MARK: UITableViewDataSource

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var newCell = tableView.dequeueReusableCellWithIdentifier("TodayListViewTableViewCell") as? TodayListViewTableViewCell;
        if (newCell == nil) {
            assertionFailure("Failed to create TodayListViewTableViewCell from reuse identifier");
        }
        assert(self.stateArray != nil && self.stateArray!.count >= indexPath.row + 1, "")

        let state = stateArray![indexPath.row];
        newCell!.timestampLabel.text = state.startDate.timeString();

        if let moodState = state as? MoodState {
            let moodIconFilename = "mood_icon_" + String(moodState.mood.rawValue);
            newCell!.iconImageView.image = UIImage(named: moodIconFilename);
            newCell!.moodLabel.text = "Mood: " + MoodStrings[moodState.mood.rawValue];
            newCell!.energyLabel.text = "Energy: " + EnergyLevelStrings[moodState.energyLevel.rawValue];
        }
        else if let drugState = state as? DrugState {
            newCell!.iconImageView.image = UIImage(named: DrugIconFilenames[drugState.drug.rawValue]);
            newCell!.moodLabel.text = DrugStrings[drugState.drug.rawValue];
            newCell!.energyLabel.text = "";
        }
        else {
            assertionFailure("Found unexpected subclass of StateEvent!");
        }

        return newCell!;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.stateArray != nil) ? self.stateArray!.count : 0;
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    // MARK: Helpers

    func updateData() {
        stateArray = DataStore.sharedDataStore.getStatesFrom(NSDate.startOfDay(), to: NSDate.now());
        tableView.reloadData();
    }
}

