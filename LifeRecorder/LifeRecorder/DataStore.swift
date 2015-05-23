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
    var stateArray = [NSManagedObject]();

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

        var activityArray: [NSManagedObject] = fetchEntities(named: "ActivityState");
        sortObjectArray(&activityArray, byDateProperty: "eventDate");
        var drugArray: [NSManagedObject] = fetchEntities(named: "DrugState");
        sortObjectArray(&drugArray, byDateProperty: "eventDate");
        var moodArray: [NSManagedObject] = fetchEntities(named: "MoodState");
        sortObjectArray(&moodArray, byDateProperty: "eventDate");
        var sleepArray: [NSManagedObject] = fetchEntities(named: "SleepState");
        sortObjectArray(&sleepArray, byDateProperty: "eventDate");

        stateArray = activityArray + drugArray + moodArray + sleepArray;
        sortObjectArray(&stateArray, byDateProperty: "eventDate");
    }

    // MARK: Activity Accessors
    func recordActivity(activity: Activity!, atDate date: NSDate) {
        let newActivityState = self.newActivityState();
        newActivityState["activity"] = activity.rawValue;
        newActivityState["eventDate"] = date;
        stateArray.insertAtFront(newActivityState);
        sortObjectArray(&stateArray, byDateProperty: "eventDate");

        self.saveData();
    }

    // MARK: Drug Accessors
    func recordDrug(drug: Drug!, atDate date: NSDate) {
        let nowDate = NSDate();

        let newDrugState = self.newDrugState();
        newDrugState["drug"] = drug.rawValue;
        newDrugState["eventDate"] = date;

        stateArray.insertAtFront(newDrugState);
        sortObjectArray(&stateArray, byDateProperty: "eventDate");

        self.saveData();
    }

    // MARK: Mood Accessors
    func recordMood(mood: Mood!, energyLevel: EnergyLevel!, atDate date: NSDate) {
        var newMoodState = self.newMoodState();
        newMoodState["energyLevel"] = energyLevel.rawValue;
        newMoodState["mood"] = mood.rawValue;
        newMoodState["eventDate"] = date;

        stateArray.insertAtFront(newMoodState);
        sortObjectArray(&stateArray, byDateProperty: "eventDate");
        self.saveData();
    }

    func getMostRecentMood() -> MoodState? {
        for state: NSManagedObject in stateArray {
            if (state.entity.description == "MoodState") {
                return MoodState(managedObject: state);
            }
        }
        return nil;
    }

    // MARK: Sleep Accessors
    func recordSleep(starting fallAsleepTime: NSDate!, ending wakeUpTime: NSDate!) {
        var newFallAsleepEvent = self.newSleepState();
        var newWakeUpEvent = self.newSleepState();
        newFallAsleepEvent["eventDate"] = fallAsleepTime;
        newFallAsleepEvent["isWakeUp"] = false;
        newWakeUpEvent["eventDate"] = wakeUpTime;
        newWakeUpEvent["isWakeUp"] = true;
        stateArray.insertAtFront(newFallAsleepEvent);
        stateArray.insertAtFront(newWakeUpEvent);
        sortObjectArray(&stateArray, byDateProperty: "eventDate");
        self.saveData();
    }

    // MARK: General State Accessors
    func getStatesFrom(startDate: NSDate!, to endDate: NSDate!) -> [StateEvent]! {
        var returnArray = [StateEvent]();
        for stateObject in stateArray {
            let thisEventDate = stateObject["eventDate"] as! NSDate;
            if (thisEventDate.isBetween(startDate, and: endDate)) {
                switch (stateObject.entity.name!) {
                    case "MoodState":
                        returnArray.insertAtEnd(MoodState(managedObject: stateObject)!);
                    case "ActivityState":
                        returnArray.insertAtEnd(ActivityState(managedObject: stateObject)!);
                    case "DrugState":
                        returnArray.insertAtEnd(DrugState(managedObject: stateObject)!);
                    case "SleepState":
                        returnArray.insertAtEnd(SleepState(managedObject: stateObject)!);
                    default:
                        let message = "Unexpected State Endity Description: \(stateObject.entity.name)";
                        assertionFailure(message);
                }
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
