//
//  Array+Shortcuts.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 5/7/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation

extension Array {
    mutating func insertAtFront(object: T) {
        self.insert(object, atIndex: 0);
    }
    
    mutating func insertAtEnd(object: T) {
        self.insert(object, atIndex: self.count);
    }
}