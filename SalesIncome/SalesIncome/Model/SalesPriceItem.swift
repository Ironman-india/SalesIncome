//
//  SalesPriceItem.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/11/01.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import NCMB
import SwiftyUserDefaults
import SVProgressHUD

class SalesPriceItem: NSObject {
    public var objectId: String
    public var prices: [Int]

    init(objectId: String = "", prices: [Int] = [Int]()) {
        self.objectId = objectId
        self.prices = prices
    }

    public func updateSalesPrice(complete: @escaping (Int) -> Void) {
        SVProgressHUD.show()
        getSalesPrice { (datas) in
            if datas.isEmpty {
                self.saveSalesPrice(complete: { (code) in
                    SVProgressHUD.dismiss()
                    complete(code)
                })
            } else {
                for data in datas {
                    let object: NCMBObject = NCMBObject.init(className: Constants.NCMBClass.NCMB_SALES_PRICE)
                    object.objectId = data.objectId
                    object.setObject(Defaults[.USER_CLASS], forKey: Constants.SalesPrices.classes)
                    object.setObject(self.prices, forKey: Constants.SalesPrices.prices)
                    object.saveEventually { (error) in
                        SVProgressHUD.dismiss()
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

    public func saveSalesPrice(complete: @escaping (Int) -> Void) {
        SVProgressHUD.show()
        let object: NCMBObject = NCMBObject.init(className: Constants.NCMBClass.NCMB_SALES_PRICE)

        object.setObject(Defaults[.USER_CLASS], forKey: Constants.SalesPrices.classes)
        object.setObject(self.prices, forKey: Constants.SalesPrices.prices)


        object.saveEventually { (error) in
            SVProgressHUD.dismiss()
            if let errorString = error?.localizedDescription {
                NSLog(errorString)
                complete(1)
            } else {
                complete(0)
            }
        }
    }

    public func getSalesPrice(complete: @escaping ([NCMBObject]) -> Void) {
        SVProgressHUD.show()
        let query: NCMBQuery = NCMBQuery(className: Constants.NCMBClass.NCMB_SALES_PRICE)
        query.whereKey(Constants.SalesPrices.classes, equalTo: Defaults[.USER_CLASS])

        query.findObjectsInBackground { (datas, error) in
            SVProgressHUD.dismiss()
            if let errorString = error?.localizedDescription {
                NSLog(errorString)
                complete(datas as? [NCMBObject] ?? [NCMBObject]())
            } else {
                complete(datas as? [NCMBObject] ?? [NCMBObject]())
            }
        }
    }

}
