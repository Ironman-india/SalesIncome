//
//  SalesLogItem.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/10/30.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import NCMB

class SalesLogItem: NSObject {
    public var objectId: String
    public var salesProceeds: Int
    public var salesCount: Int

    init(objectId: String = "", salesProceeds: Int, salesCount: Int) {
        self.objectId = objectId
        self.salesProceeds = salesProceeds
        self.salesCount = salesCount
    }


}
