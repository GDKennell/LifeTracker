//
//  SleepDataStructures.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 5/18/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SleepState: StateEvent {
    var isWakeUp: Bool!

    override init?(managedObject: NSManagedObject?) {
        super.init(managedObject: managedObject);
        self.isWakeUp = managedObject!["isWakeUp"] as! Bool;
        let iconFilename = (self.isWakeUp == true) ? "sleep_icon_wake_up" : "sleep_icon_fall_asleep";
        self.iconImage = UIImage(named: iconFilename);
        self.mainDisplayText = (self.isWakeUp == true) ? "Wake Up" : "Fall Asleep";
    }
}
