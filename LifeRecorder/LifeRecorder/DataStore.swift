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
    let moodStateEntityDescription: NSEntityDescription!;
    let drugStateEntityDescription: NSEntityDescription!;

    // Local Storage
    var moodArray = [NSManagedObject]();
    var drugArray = [NSManagedObject]();

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

        drugStateEntityDescription = NSEntityDescription.entityForName("DrugState", inManagedObjectContext: managedObjectContext)
        moodStateEntityDescription = NSEntityDescription.entityForName("MoodState", inManagedObjectContext: managedObjectContext)

        let drugStateFetchRequest = NSFetchRequest(entityName: "DrugState");

        drugArray = fetchEntities(named: "DrugState");
        sortObjectArray(&drugArray, byDateProperty: "startDate");
        moodArray = fetchEntities(named: "MoodState");
        sortObjectArray(&moodArray, byDateProperty: "startDate");
    }

    // MARK: Drug Accessors
    func recordDrug(drug: Drug!, atDate date: NSDate) {
        let nowDate = NSDate();

        let newDrugState = self.newDrugState();
        newDrugState["drug"] = drug.rawValue;
        newDrugState["startDate"] = date;
        newDrugState["endDate"] = date;

        drugArray.insertAtFront(newDrugState);
        sortObjectArray(&drugArray, byDateProperty: "startDate");

        self.saveData();
    }

    // MARK: Mood Accessors
    func recordMood(mood: Mood!, energyLevel: EnergyLevel!) {
        let nowDate = NSDate();
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

    func getStatesFrom(startDate: NSDate!, to endDate: NSDate!) -> [StateEvent]! {
        var returnArray = [StateEvent]();
        for moodStateObject in moodArray {
            let thisStartDate = moodStateObject["startDate"] as! NSDate;
            let thisEndDate = moodStateObject["endDate"] as! NSDate;
            if (thisStartDate.isBetween(startDate, and: endDate) ||
                thisEndDate.isBetween(startDate, and: endDate)) {
                    returnArray.insertAtEnd(MoodState(managedObject: moodStateObject)!);
            }
        }
        for drugStateObject in drugArray {
            let thisStartDate = drugStateObject["startDate"] as! NSDate;
            let thisEndDate = drugStateObject["endDate"] as! NSDate;
            if (thisStartDate.isBetween(startDate, and: endDate) ||
                thisEndDate.isBetween(startDate, and: endDate)) {
                    returnArray.insertAtEnd(DrugState(managedObject: drugStateObject)!);
            }
        }
        returnArray.sort { (event1: StateEvent, event2: StateEvent) -> Bool in
            return event1.startDate.isAfter(event2.startDate);
        }

        return returnArray;
    }

    func getMostRecentMood() -> MoodState? {
        return MoodState(managedObject: moodArray.first);
    }

    // MARK: NSManagedObject factory methods
    func newMoodState() -> NSManagedObject! {
        return NSManagedObject(entity: moodStateEntityDescription, insertIntoManagedObjectContext: managedObjectContext);
    }

    func newDrugState() -> NSManagedObject! {
        return NSManagedObject(entity: drugStateEntityDescription, insertIntoManagedObjectContext: managedObjectContext);
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
