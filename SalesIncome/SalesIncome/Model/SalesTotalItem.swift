//
//  SalesTotalItem.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/10/30.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import NCMB
import SwiftyUserDefaults

class SalesTotalItem: NSObject {
    public var objectId: String
    public var total: Int
    public var count: Int

    init(objectId: String = "", classes: String = Defaults[.USER_CLASS], total: Int, count: Int) {
        self.objectId = objectId
        self.total = total
        self.count = count
    }

    public func updateSalesTotal(complete: @escaping (Int) -> Void) {
        getSalesTotal { (datas) in
            print(datas)
            if datas.isEmpty {
                self.saveSalesTotal(complete: { (code) in
                    complete(code)
                })
            } else {
                for data in datas {
                    let object: NCMBObject = NCMBObject.init(className: Constants.NCMBClass.NCMB_SALES_TOTAL)
                    object.objectId = data.objectId
                    object.setObject(Defaults[.USER_CLASS], forKey: Constants.SalesTotal.classes)
                    object.setObject(self.count + (data.object(forKey: Constants.SalesTotal.count) as? Int ?? 0), forKey: Constants.SalesTotal.count)
                    object.setObject(self.total + (data.object(forKey: Constants.SalesTotal.total) as? Int ?? 0), forKey: Constants.SalesTotal.total)
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
        }
    }

    public func saveSalesTotal(complete: @escaping (Int) -> Void) {
        let object: NCMBObject = NCMBObject.init(className: Constants.NCMBClass.NCMB_SALES_TOTAL)

        object.setObject(Defaults[.USER_CLASS], forKey: Constants.SalesTotal.classes)
        object.setObject(self.count, forKey: Constants.SalesTotal.count)
        object.setObject(self.total, forKey: Constants.SalesTotal.total)

        object.saveEventually { (error) in
            if let errorString = error?.localizedDescription {
                NSLog(errorString)
                complete(1)
            } else {
                complete(0)
            }
        }
    }

    public func getSalesTotal(complete: @escaping ([NCMBObject]) -> Void) {
        let query: NCMBQuery = NCMBQuery(className: Constants.NCMBClass.NCMB_SALES_TOTAL)
        query.whereKey(Constants.SalesTotal.classes, equalTo: Defaults[.USER_CLASS])

        query.findObjectsInBackground { (datas, error) in
            if let errorString = error?.localizedDescription {
                NSLog(errorString)
                complete(datas as? [NCMBObject] ?? [NCMBObject]())
            } else {
                complete(datas as? [NCMBObject] ?? [NCMBObject]())
            }
        }
    }

}
