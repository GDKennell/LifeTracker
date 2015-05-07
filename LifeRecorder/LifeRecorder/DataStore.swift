//
//  DataStore.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 5/6/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

// All states are stored locally in an array sorted by time
// index 0 is the most recent
//

import Foundation
import UIKit
import CoreData

class DataStore {
    // MARK: Properties

    // Singleton
    static let sharedDataStore: DataStore = DataStore();
    static var dataStoreCreated = false;
    static var dispatchOnceToken: dispatch_once_t = 0;

    // Core Data
    let managedContext: NSManagedObjectContext!;
    let moodStateEntityDescription: NSEntityDescription!;

    // Local Storage
    var moodArray = [NSManagedObject]();


    // MARK: Initialization
    init!() {
        if (DataStore.dataStoreCreated) {
            assertionFailure("DataStore must be accessed through singleton type property, sharedDataStore. It may not be initialized directly")
        }
        dispatch_once(&DataStore.dispatchOnceToken) {
            DataStore.dataStoreCreated = true;
        }
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate

        managedContext = appDelegate.managedObjectContext;
        moodStateEntityDescription = NSEntityDescription.entityForName("MoodState", inManagedObjectContext: managedContext)

    }

    // MARK: Mood Accessors
    func recordMood(mood: Mood!, energyLevel: EnergyLevel!) {
        let nowDate = NSDate(timeIntervalSinceNow: 0.0);
        var mostRecentMoodState = moodArray.first;
        if mostRecentMoodState != nil {
            var recentMoodStartDate = mostRecentMoodState!["startDate"] as! NSDate;
            if (recentMoodStartDate.isAfter(nowDate)) {
                mostRecentMoodState!["startDate"] = nowDate;
            }
        }

        var newMoodState = self.newMoodState();
        newMoodState["energyLevel"] = energyLevel.rawValue;
        newMoodState["mood"] = mood.rawValue;
        newMoodState["startDate"] = nowDate;
        newMoodState["endDate"] = nowDate + MoodState.expirationTime;

        moodArray.insertAtFront(newMoodState);

        self.saveData();
    }

    func getMoodStatesFrom(startDate: NSDate!, to endDate: NSDate!) -> [MoodState]! {
        var returnArray = [MoodState]();
        for moodStateObject in moodArray {
            let thisStartDate = moodStateObject["startDate"] as! NSDate;
            let thisEndDate = moodStateObject["endDate"] as! NSDate;
            if ((thisStartDate < endDate && thisStartDate > startDate) ||
                (thisEndDate > startDate && thisEndDate < endDate)) {
                    let mood = Mood(rawValue: moodStateObject["mood"] as! Int);
                    let energyLevel = EnergyLevel(rawValue: moodStateObject["energyLevel"] as! Int);
                    let moodStateStruct = MoodState(mood: mood!, energyLevel: energyLevel!, startDate: thisStartDate, endDate: thisEndDate);
                    returnArray.insertAtEnd(moodStateStruct);
            }
        }
        return returnArray;
    }

    // MARK: NSManagedObject factory methods
    func newMoodState() -> NSManagedObject! {
        return NSManagedObject(entity: moodStateEntityDescription, insertIntoManagedObjectContext: managedContext);
    }

    // MARK: Helpers
    func saveData() {
        var error: NSError?
        if !managedContext.save(&error) {
            assertionFailure("Could not save \(error), \(error?.userInfo)")
        }
    }
}
