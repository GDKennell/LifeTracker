//
//  MoodStateDataStructures.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 5/7/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation
import CoreData
import UIKit

let secondsPerHour = 60.0 * 60.0;

class MoodState: StateEvent {
    static let expirationTime: NSTimeInterval! = 3.0 * secondsPerHour;
    
    var mood: Mood!;
    var energyLevel: EnergyLevel!;

    override init?(managedObject: NSManagedObject?) {
        super.init(managedObject: managedObject);

        mood = Mood(rawValue: managedObject!["mood"] as! Int);
        energyLevel = EnergyLevel(rawValue: managedObject!["energyLevel"] as! Int);

        let moodIconFilename = "mood_icon_" + String(mood.rawValue);
        self.iconImage = UIImage(named: moodIconFilename);
        self.mainDisplayText = "Mood: " + MoodStrings[mood.rawValue];
        self.secondaryDisplayText = "Energy: " + EnergyLevelStrings[energyLevel.rawValue];
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

let EnergyLevelStrings = ["Manic", "High", "Average", "Low", "Lethargic"];

enum EnergyLevel: Int {
    static let count: Int = 5;

    case Manic = 0
    case High
    case Average
    case Low
    case Lethargic
}

