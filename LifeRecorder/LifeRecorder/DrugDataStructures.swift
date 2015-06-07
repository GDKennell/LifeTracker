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

struct Drug {
    let name: String!;
    let iconFilename: String!;
}

let AllDrugIconFilenames = ["drug_icon_pill", "drug_icon_caffeine", "drug_icon_alcohol", "drug_icon_marijuana", "drug_icon_tobacco"]

var AllDrugs = [Drug(name: "Caffeine", iconFilename: "drug_icon_caffeine"),
                Drug(name: "Alcohol", iconFilename: "drug_icon_alcohol"),
                Drug(name: "Marijuana", iconFilename: "drug_icon_marijuana"),
                Drug(name: "Tobacco", iconFilename: "drug_icon_tobacco"),
                Drug(name: "Melatonin", iconFilename: "drug_icon_pill"),
                Drug(name: "Ibuprophen", iconFilename: "drug_icon_pill"),
                Drug(name: "Antibiotic", iconFilename: "drug_icon_pill")];

func lookupDrug(named drugName:String!) -> Drug? {
    for aDrug in AllDrugs {
        if aDrug.name == drugName {
            return aDrug
        }
    }
    assertionFailure("Could not lookup Drug named \(drugName)");
    return nil;
}

class DrugState: StateEvent {
    var drug: Drug!;
    override init?(managedObject: NSManagedObject?) {
        super.init(managedObject: managedObject);
        let drugName = managedObject!["drug"] as! String;
        self.drug = lookupDrug(named: drugName)!

        self.iconImage = UIImage(named: drug.iconFilename);
        self.mainDisplayText = drug.name;
    }
}
