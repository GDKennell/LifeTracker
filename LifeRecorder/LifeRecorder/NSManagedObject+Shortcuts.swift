//
//  NSManagedObject+Shortcuts.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 5/7/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    subscript(key: String) -> AnyObject? {
        get {
            return self.valueForKey(key);
        }
        set (newValue) {
            self.setValue(newValue, forKey: key)
        }
    }
}
