//
//  DrugDataStructures.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 5/11/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation
import CoreData

let DrugStrings = ["Caffeine",
                   "Alcohol",
                   "Marijuana",
                   "Tobacco",
                   "Prozac",
                   "Xanax"]

let DrugIconFilenames = ["drug_icon_caffeine",
                         "drug_icon_alcohol",
                         "drug_icon_marijuana",
                         "drug_icon_tobacco",
                         "drug_icon_pill",
                         "drug_icon_pill"]

enum Drug: Int {
    static let count: Int = 6;

    case Caffeine = 0
    case Alcohol
    case Marijuana
    case Tobacco
    case Prozac
    case Xanax
}

class DrugState: StateEvent {
    var drug: Drug!;
    override init?(managedObject: NSManagedObject?) {
        super.init(managedObject: managedObject);
        self.drug = Drug(rawValue: managedObject!["drug"] as! Int)
    }

    init(drug: Drug!, startDate: NSDate!, endDate: NSDate!) {
        self.drug = drug;
        super.init(startDate: startDate, endDate: endDate);
    }
}
