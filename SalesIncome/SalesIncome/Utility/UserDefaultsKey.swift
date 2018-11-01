//
//  UserDefaultsKey.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/11/01.
//  Copyright © 2018 ammYou. All rights reserved.
//


import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let IS_FIRST_LUNCH = DefaultsKey<Bool>("IS_FIRST_LUNCH", defaultValue: false)
    static let USER_CLASS = DefaultsKey<String>("USER_CLASS", defaultValue: "None")
    static let USER_NAME = DefaultsKey<String>("USER_NAME", defaultValue: "Unknown")
    static let ITEM_PRICE = DefaultsKey<Int>("ITEM_PRICE", defaultValue: 0)
}
