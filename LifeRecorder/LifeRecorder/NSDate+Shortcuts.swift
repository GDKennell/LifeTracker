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

func <=(pattern: NSDate, value: NSDate) -> Bool {
    return pattern.timeIntervalSinceDate(value) <= 0;
}

func >(pattern:NSDate, value: NSDate) -> Bool {
    return pattern.isAfter(value);
}

func >=(pattern: NSDate, value: NSDate) -> Bool {
    return pattern.timeIntervalSinceDate(value) >= 0;
}

extension NSDate {
    func isBefore(otherDate: NSDate!) -> Bool {
        return self.timeIntervalSinceDate(otherDate) < 0;
    }

    func isAfter(otherDate: NSDate!) -> Bool {
        return self.timeIntervalSinceDate(otherDate) > 0;
    }

    func isBetween(firstDate: NSDate!, and secondDate: NSDate!) -> Bool {
        return (self >= firstDate && self <= secondDate);
    }

    func timeString() -> String {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "HH:mm a";
        dateFormatter.locale = NSLocale.currentLocale();
//        let dateFormatter: NSDateFormatter! = NSDateFormatter.dateFormatFromTemplate("hh:mm a", options: 0, locale: NSLocale.currentLocale());
        return dateFormatter.stringFromDate(self);
    }

    static func now() -> NSDate {
        return NSDate();
    }

    static func startOfDay() -> NSDate {
        let rightNow = NSDate();
        let cal: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian);
        var newDate : NSDate?
        cal.rangeOfUnit(.CalendarUnitDay, startDate: &newDate, interval: nil, forDate: rightNow)
        return newDate!;
    }

    static func endOfDay() -> NSDate {
        let fullDayTimeInterval: NSTimeInterval = 24 * 60 * 60;
        return startOfDay().dateByAddingTimeInterval(fullDayTimeInterval);
    }
}