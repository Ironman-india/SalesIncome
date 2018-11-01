//
//  SalesItem.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/10/29.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import NCMB
import SwiftyUserDefaults

class SalesItem: NSObject {
    public var objectId: String
    public var transactionType: String
    public var count: Int
    public var price: Int
    public var total: Int
    public var ticket: Int
    public var time: Date

    init(objectId: String = "", transactionType: String,
         count: Int, price: Int, total: Int, ticket: Int, time: Date = Date()) {
        self.objectId = objectId
        self.transactionType = transactionType
        self.count = count
        self.price = price
        self.total = total
        self.ticket = ticket
        self.time = time
    }

    public func outputStringOneLine() -> String {
        var oTime: String {
            get {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                return formatter.string(from: self.time)
            }
        }

        return "\(self.transactionType), 金額: \(self.total)円, 個数: \(self.count)個, \(self.price)円/個, 食券: \(self.ticket)毎, \(oTime)"
    }

    public func saveSalesItem(complete: @escaping (Int) -> Void) {
        let object: NCMBObject = NCMBObject.init(className: Constants.NCMBClass.NCMB_SALEA_LOG)
        object.setObject(self.transactionType, forKey: Constants.SalesItem.transactionType)
        object.setObject(Defaults[.USER_CLASS], forKey: Constants.SalesTotal.classes)
        object.setObject(self.count, forKey: Constants.SalesItem.count)
        object.setObject(self.price, forKey: Constants.SalesItem.price)
        object.setObject(self.total, forKey: Constants.SalesItem.total)
        object.setObject(self.ticket, forKey: Constants.SalesItem.ticket)
        object.setObject(Defaults[.USER_NAME], forKey: Constants.SalesItem.user)
        object.setObject(self.time, forKey: Constants.SalesItem.time)

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
