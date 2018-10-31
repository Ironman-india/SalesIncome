//
//  SalesItem.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/10/29.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import NCMB

class SalesItem: NSObject {
    public var objectId: String
    public var transactionType: String
    public var num: Int
    public var price: Int
    public var total: Int
    public var ticket: Int
    public var user: String
    public var time: Date

    init(objectId: String = "", transactionType: String,
         num: Int, price: Int, total: Int, ticket: Int, user: String, time: Date = Date()) {
        self.objectId = objectId
        self.transactionType = transactionType
        self.num = num
        self.price = price
        self.total = total
        self.ticket = ticket
        self.user = user
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

        return "\(self.transactionType), 金額: \(self.total)円, 個数: \(self.num)個, \(self.price)円/個, 食券: \(self.ticket)毎, \(oTime)"
    }
}
