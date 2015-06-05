//
//  DrugDataStructures.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 5/11/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation
import CoreData
import UIKit

let DrugStrings = ["Caffeine",
                   "Alcohol",
                   "Marijuana",
                   "Tobacco",
                   "Melatonin",
                   "Ibuprophen",
                   "Antibiotic"]

let DrugIconFilenames = ["drug_icon_caffeine",
                         "drug_icon_alcohol",
                         "drug_icon_marijuana",
                         "drug_icon_tobacco",
                         "drug_icon_pill",
                         "drug_icon_pill",
                         "drug_icon_pill"]

enum Drug: Int {
    static let count: Int = 7;

    case Caffeine = 0
    case Alcohol
    case Marijuana
    case Tobacco
    case Melatonin
    case Ibuprophen
    case Antibiotic
}

class DrugState: StateEvent {
    var drug: Drug!;
    override init?(managedObject: NSManagedObject?) {
        super.init(managedObject: managedObject);
        self.drug = Drug(rawValue: managedObject!["drug"] as! Int)
        self.iconImage = UIImage(named: DrugIconFilenames[drug.rawValue]);
        self.mainDisplayText = DrugStrings[drug.rawValue];
    }
}
