//
//  NCMBManager.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/10/29.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import NCMB

class NCMBManager {
    static func saveData(className: String, keyName: String, dataValue: Any, complete: @escaping (Int) -> Void) {
        let object: NCMBObject = NCMBObject.init(className: className)
        object.setObject(dataValue, forKey: keyName)

        object.saveEventually { (error) in
            if let errorString = error?.localizedDescription {
                NSLog(errorString)
                complete(1)
            } else {
                complete(0)
            }
        }
    }

    static func saveSalesItem(item: SalesItem, complete: @escaping (Int) -> Void) {
        let object: NCMBObject = NCMBObject.init(className: Constants.NCMBClass.NCMB_SALES)
        object.setObject(item.transactionType, forKey: Constants.SalesItem.transactionType)
        object.setObject(item.num, forKey: Constants.SalesItem.num)
        object.setObject(item.price, forKey: Constants.SalesItem.price)
        object.setObject(item.total, forKey: Constants.SalesItem.total)
        object.setObject(item.ticket, forKey: Constants.SalesItem.ticket)
        object.setObject(item.user, forKey: Constants.SalesItem.user)
        object.setObject(item.time, forKey: Constants.SalesItem.time)

        object.saveEventually { (error) in
            if let errorString = error?.localizedDescription {
                NSLog(errorString)
                complete(1)
            } else {
                complete(0)
            }
        }
    }
}
