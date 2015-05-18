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
    let managedObjectContext: NSManagedObjectContext!;
    let activityStateEntityDescription: NSEntityDescription!;
    let moodStateEntityDescription: NSEntityDescription!;
    let drugStateEntityDescription: NSEntityDescription!;
    let sleepStateEntityDescription: NSEntityDescription!;

    // Local Storage
    var activityArray = [NSManagedObject]();
    var moodArray = [NSManagedObject]();
    var drugArray = [NSManagedObject]();
    var sleepArray = [NSManagedObject]();

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

        managedObjectContext = appDelegate.managedObjectContext;

        activityStateEntityDescription = NSEntityDescription.entityForName("ActivityState", inManagedObjectContext: managedObjectContext)
        drugStateEntityDescription = NSEntityDescription.entityForName("DrugState", inManagedObjectContext: managedObjectContext)
        moodStateEntityDescription = NSEntityDescription.entityForName("MoodState", inManagedObjectContext: managedObjectContext)
        sleepStateEntityDescription = NSEntityDescription.entityForName("SleepState", inManagedObjectContext: managedObjectContext)


        let drugStateFetchRequest = NSFetchRequest(entityName: "DrugState");

        activityArray = fetchEntities(named: "ActivityState");
        sortObjectArray(&activityArray, byDateProperty: "eventDate");
        drugArray = fetchEntities(named: "DrugState");
        sortObjectArray(&drugArray, byDateProperty: "eventDate");
        moodArray = fetchEntities(named: "MoodState");
        sortObjectArray(&moodArray, byDateProperty: "eventDate");
        sleepArray = fetchEntities(named: "SleepState");
        sortObjectArray(&sleepArray, byDateProperty: "eventDate");
    }

    // MARK: Activity Accessors
    func recordActivity(activity: Activity!, atDate date: NSDate) {
        let newActivityState = self.newActivityState();
        newActivityState["activity"] = activity.rawValue;
        newActivityState["eventDate"] = date;
        activityArray.insertAtFront(newActivityState);
        sortObjectArray(&activityArray, byDateProperty: "eventDate");

        self.saveData();
    }

    // MARK: Drug Accessors
    func recordDrug(drug: Drug!, atDate date: NSDate) {
        let nowDate = NSDate();

        let newDrugState = self.newDrugState();
        newDrugState["drug"] = drug.rawValue;
        newDrugState["eventDate"] = date;

        drugArray.insertAtFront(newDrugState);
        sortObjectArray(&drugArray, byDateProperty: "eventDate");

        self.saveData();
    }

    // MARK: Mood Accessors
    func recordMood(mood: Mood!, energyLevel: EnergyLevel!, atDate date: NSDate) {
        var newMoodState = self.newMoodState();
        newMoodState["energyLevel"] = energyLevel.rawValue;
        newMoodState["mood"] = mood.rawValue;
        newMoodState["eventDate"] = date;

        moodArray.insertAtFront(newMoodState);
        sortObjectArray(&moodArray, byDateProperty: "eventDate");
        self.saveData();
    }

    func getMostRecentMood() -> MoodState? {
        return MoodState(managedObject: moodArray.first);
    }

    // MARK: Sleep Accessors
    func recordSleep(starting fallAsleepTime: NSDate!, ending wakeUpTime: NSDate!) {
        var newFallAsleepEvent = self.newSleepState();
        var newWakeUpEvent = self.newSleepState();
        newFallAsleepEvent["eventDate"] = fallAsleepTime;
        newFallAsleepEvent["isWakeUp"] = false;
        newWakeUpEvent["eventDate"] = wakeUpTime;
        newWakeUpEvent["isWakeUp"] = true;
        sleepArray.insertAtFront(newFallAsleepEvent);
        sleepArray.insertAtFront(newWakeUpEvent);
        sortObjectArray(&sleepArray, byDateProperty: "eventDate");
        self.saveData();
    }

    // MARK: General State Accessors
    func getStatesFrom(startDate: NSDate!, to endDate: NSDate!) -> [StateEvent]! {
        var returnArray = [StateEvent]();
        for activityStateObject in activityArray {
            let thisEventDate = activityStateObject["eventDate"] as! NSDate;
            if (thisEventDate.isBetween(startDate, and: endDate)) {
                returnArray.insertAtEnd(ActivityState(managedObject: activityStateObject)!);
            }
        }

        for moodStateObject in moodArray {
            let thisEventDate = moodStateObject["eventDate"] as! NSDate;
            if (thisEventDate.isBetween(startDate, and: endDate)) {
                    returnArray.insertAtEnd(MoodState(managedObject: moodStateObject)!);
            }
        }
        for drugStateObject in drugArray {
            let thisEventDate = drugStateObject["eventDate"] as! NSDate;
            if (thisEventDate.isBetween(startDate, and: endDate)) {
                    returnArray.insertAtEnd(DrugState(managedObject: drugStateObject)!);
            }
        }

        for sleepStateObject in sleepArray {
            let thisEventDate = sleepStateObject["eventDate"] as! NSDate;
            if (thisEventDate.isBetween(startDate, and: endDate)) {
                returnArray.insertAtEnd(SleepState(managedObject: sleepStateObject)!);
            }
        }
        returnArray.sort { (event1: StateEvent, event2: StateEvent) -> Bool in
            return event1.eventDate.isAfter(event2.eventDate);
        }

        return returnArray;
    }

    // MARK: NSManagedObject factory methods
    func newActivityState() -> NSManagedObject! {
        return NSManagedObject(entity: activityStateEntityDescription, insertIntoManagedObjectContext: managedObjectContext);
    }

    func newMoodState() -> NSManagedObject! {
        return NSManagedObject(entity: moodStateEntityDescription, insertIntoManagedObjectContext: managedObjectContext);
    }

    func newDrugState() -> NSManagedObject! {
        return NSManagedObject(entity: drugStateEntityDescription, insertIntoManagedObjectContext: managedObjectContext);
    }

    func newSleepState() -> NSManagedObject! {
        return NSManagedObject(entity: sleepStateEntityDescription, insertIntoManagedObjectContext: managedObjectContext);
    }

    // MARK: Helpers
    func saveData() {
        var error: NSError?
        if !managedObjectContext.save(&error) {
            assertionFailure("Could not save \(error), \(error?.userInfo)")
        }
    }

    func fetchEntities(named entityName: String) -> [NSManagedObject]! {
        var fetchError: NSError?;
        let fetchRequest = NSFetchRequest(entityName: entityName);
        let fetchedArray = managedObjectContext.executeFetchRequest(fetchRequest, error: &fetchError);
        assert(fetchedArray != nil && fetchError == nil, "Failed to request \(entityName) objects from Core Data");
        var returnArray = [NSManagedObject]();
        for object in fetchedArray! {
            returnArray.insertAtFront(object as! NSManagedObject);
        }
        return returnArray;
    }

    func sortObjectArray(inout array:[NSManagedObject], byDateProperty propertyName: String!) {
        array.sort { (state1: NSManagedObject, state2: NSManagedObject) -> Bool in
            let property1 = state1[propertyName] as! NSDate;
            let property2 = state2[propertyName] as! NSDate;
            return property1.isAfter(property2);
        }
    }

}
