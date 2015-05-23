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
    final var eventDate: NSDate!;
    final var iconImage: UIImage! = UIImage();
    final var mainDisplayText: String! = "";
    final var secondaryDisplayText: String! = "";
    final var managedObject: NSManagedObject!;

    init?(managedObject: NSManagedObject?) {
        if (managedObject == nil) {
            return nil;
        }
        eventDate = managedObject!["eventDate"] as! NSDate!;
        self.managedObject = managedObject!;
    }
}
