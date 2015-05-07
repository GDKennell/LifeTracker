//
//  NSDate+Shortcuts.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 5/7/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation

func +(pattern: NSDate, value: NSTimeInterval) -> NSDate {
    return pattern.dateByAddingTimeInterval(value);
}

func +=(inout pattern: NSDate, value: NSTimeInterval) -> NSDate {
    pattern = pattern.dateByAddingTimeInterval(value);
    return pattern;
}

func <(pattern: NSDate, value: NSDate) -> Bool {
    return pattern.isBefore(value);
}

func >(pattern:NSDate, value: NSDate) -> Bool {
    return pattern.isAfter(value);
}

extension NSDate {
    func isBefore(otherDate: NSDate!) -> Bool {
        return self.timeIntervalSinceDate(otherDate) < 0;
    }

    func isAfter(otherDate: NSDate!) -> Bool {
        return !self.isBefore(otherDate);
    }
}