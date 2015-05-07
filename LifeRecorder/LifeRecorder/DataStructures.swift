//
//  DataStructures.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 5/7/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation
import CoreData

let secondsPerHour = 60.0 * 60.0;

struct MoodState {
    static let expirationTime: NSTimeInterval! = 3.0 * secondsPerHour;
    
    var mood: Mood!;
    var energyLevel: EnergyLevel!;
    var startDate: NSDate!;
    var endDate: NSDate!;

    init?(managedObject: NSManagedObject?) {
        if (managedObject == nil) {
            return nil;
        }
        mood = Mood(rawValue: managedObject!["mood"] as! Int);
        energyLevel = EnergyLevel(rawValue: managedObject!["energyLevel"] as! Int);
        startDate = managedObject!["startDate"] as! NSDate;
        endDate = managedObject!["endDate"] as! NSDate;
    }
}

let MoodStrings = ["Euphoric", "Great", "Good", "Ok", "Bad", "Really Bad", "Depressed"];

enum Mood: Int {
    static let count: Int = 7;

    case Euphoric = 0
    case Great
    case Good
    case Ok
    case Bad
    case ReallyBad
    case Depressed
}

let EnergyLevelStrings = ["Manic", "Hight", "Average", "Low", "Lethargic"];

enum EnergyLevel: Int {
    static let count: Int = 5;

    case Manic = 0
    case High
    case Average
    case Low
    case Lethargic
}

