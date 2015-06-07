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

let AllDrugIconFilenames = ["drug_icon_pill", "drug_icon_caffeine", "drug_icon_alcohol", "drug_icon_marijuana", "drug_icon_tobacco"]

struct Drug {
    let name: String!;
    let iconFilename: String!;
    init(managedObject: NSManagedObject) {
        name = managedObject["name"] as! String;
        iconFilename = managedObject["iconFilename"] as! String;
    }
    init(name name_:String!, iconFilename filename:String!) {
        name = name_;
        iconFilename = filename;
    }
}

class DrugState: StateEvent {
    var drug: Drug!;
    override init?(managedObject: NSManagedObject?) {
        super.init(managedObject: managedObject);
        let drugName = managedObject!["drug"] as! String;
        self.drug = DataStore.sharedDataStore.lookupDrug(named: drugName)!

        self.iconImage = UIImage(named: drug.iconFilename);
        self.mainDisplayText = drug.name;
    }
}
