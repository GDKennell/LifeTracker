//
//  ActivityDataStructures.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 5/16/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// To add: Studying, Working, Gaming, Internet-ing
let ActivityStrings = ["Exercise",
                       "Cook",
                       "Eat",
                       "Shower",
                       "Socialize"]

let ActivityIconFilenames = ["activity_icon_exercise",
                             "activity_icon_cooking",
                             "activity_icon_food",
                             "activity_icon_shower",
                             "activity_icon_socialize"]

enum Activity: Int {
    static let count: Int = 5;

    case Exercise = 0
    case Cook
    case Eat
    case Shower
    case Socialize
}

class ActivityState: StateEvent {
    var activity: Activity!;
    override init?(managedObject: NSManagedObject?) {
        super.init(managedObject: managedObject);
        self.activity = Activity(rawValue: managedObject!["activity"] as! Int);
        self.iconImage = UIImage(named: ActivityIconFilenames[activity.rawValue]);
        self.mainDisplayText = ActivityStrings[activity.rawValue];
    }
}