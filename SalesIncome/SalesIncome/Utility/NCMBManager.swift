//
//  NCMBManager.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/10/29.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import NCMB
import SwiftyUserDefaults

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
        let object: NCMBObject = NCMBObject.init(className: Constants.NCMBClass.NCMB_SALEA_LOG)
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

    static func saveSalesTotal(item: SalesItem, complete: @escaping (Int) -> Void) {
        let object: NCMBObject = NCMBObject.init(className: Constants.NCMBClass.NCMB_SALES_TOTAL,
                                                 objectId: "\(Constants.NCMBClass.NCMB_SALES_TOTAL)_\(Defaults[.USER_CLASS])")
        object.setObject(item.num, forKey: Constants.SalesItem.num)
        object.setObject(item.total, forKey: Constants.SalesItem.total)

        object.saveEventually { (error) in
            if let errorString = error?.localizedDescription {
                NSLog(errorString)
                complete(1)
            } else {
                complete(0)
            }
        }
    }

    static func getSalesTotal(complete: @escaping ([Int?]) -> Void) {
        let object: NCMBObject = NCMBObject.init(className: Constants.NCMBClass.NCMB_SALES_TOTAL,
                                                 objectId: "\(Constants.NCMBClass.NCMB_SALES_TOTAL)_\(Defaults[.USER_CLASS])")

        object.fetchInBackground { (error) in
            if let errorString = error?.localizedDescription {
                NSLog(errorString)
                complete([object.object(forKey: Constants.SalesItem.num) as? Int, object.object(forKey: Constants.SalesItem.total) as? Int])
            } else {
                print(object)
                complete([object.object(forKey: Constants.SalesItem.num) as? Int, object.object(forKey: Constants.SalesItem.total) as? Int])
            }
        }
    }
}
