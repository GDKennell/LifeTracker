//
//  DrugDataStructures.swift
//  LifeRecorder
//
//  Created by Grant Kennell on 5/11/15.
//  Copyright (c) 2015 Grant Kennell. All rights reserved.
//

import Foundation

let AllDrugs: [Drug] = [Drug(drugName:"Caffeine", iconFileName:"drug_icon_caffeine"),
                        Drug(drugName:"Alcohol", iconFileName:"drug_icon_alcohol"),
                        Drug(drugName:"Marijuana", iconFileName:"drug_icon_marijuana"),
                        Drug(drugName:"Tobacco", iconFileName:"drug_icon_tobacco"),
                        Drug(drugName:"Prozac", iconFileName:"drug_icon_pill"),
                        Drug(drugName:"Xanax", iconFileName:"drug_icon_pill")]

struct Drug {
    let drugName: String!;
    let iconFileName: String!;

    init(drugName: String!, iconFileName: String!) {
        self.drugName = drugName;
        self.iconFileName = iconFileName;
    }
}
