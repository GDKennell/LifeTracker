//
//  DataStructures.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 5/14/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class StateEvent {
    final var startDate: NSDate!;
    final var endDate: NSDate?;
    final var iconImage: UIImage! = UIImage();
    final var mainDisplayText: String! = "";
    final var secondaryDisplayText: String! = "";

    init?(managedObject: NSManagedObject?) {
        if (managedObject == nil) {
            return nil;
        }
        startDate = managedObject!["startDate"] as! NSDate!;
        endDate = managedObject!["endDate"] as? NSDate;
    }

    init(startDate: NSDate!, endDate: NSDate!) {
        self.startDate = startDate;
        self.endDate = endDate;
    }
}
