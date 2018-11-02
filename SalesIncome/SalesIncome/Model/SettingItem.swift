//
//  SettingItem.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/11/01.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import UIKit
import SVProgressHUD
import NCMB

class SettingItem: NSObject {
    enum SettingKey {
        case className
        case userName
        case prices
    }

    public var title: String = ""
    public var placeholder: String = ""
    public var value: String
    public var key: SettingKey

    init(key: SettingKey) {
        switch key {
        case .className:
            self.title = "保存先クラス"
            self.placeholder = "保存先クラス"
            self.value = String(Defaults[.USER_CLASS])
            self.key = key
        case .userName:
            self.title = "識別名"
            self.placeholder = "識別名"
            self.value = String(Defaults[.USER_NAME])
            self.key = key
        case .prices:
            self.title = "価格"
            self.placeholder = "「,」区切り"
            let strArr = Defaults[.ITEM_PRICE].map({ String($0) })
            self.value = strArr.joined(separator: ",")
            self.key = key
        }
    }

    public func updateSalesPrice(priceData: [Int] = [Int](), complete: @escaping (Int) -> Void) {
        SVProgressHUD.show()

        var num = [Int]()
        if priceData.isEmpty {
            let numn = self.value.split(separator: ",")
            for numi in numn {
                if let newNum = Int(numi) {
                    num.append(newNum)
                } else {
                    complete(0)
                    return
                }
            }
        } else {
            num = priceData
        }

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
                    object.setObject(num, forKey: Constants.SalesPrices.prices)
                    object.saveInBackground { (error) in
                        SVProgressHUD.dismiss()
                        if let errorString = error?.localizedDescription {
                            NSLog(errorString)
                            SVProgressHUD.showError(withStatus: errorString)
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
        var num = [Int]()
        let numn = self.value.split(separator: ",")
        for numi in numn {
            if let newNum = Int(numi) {
                num.append(newNum)
            } else {
                complete(0)
                return
            }
        }

        let object: NCMBObject = NCMBObject.init(className: Constants.NCMBClass.NCMB_SALES_PRICE)

        object.setObject(Defaults[.USER_CLASS], forKey: Constants.SalesPrices.classes)
        object.setObject(Defaults[.USER_CLASS], forKey: Constants.SalesPrices.classes)
        object.setObject(num, forKey: Constants.SalesPrices.prices)
        object.saveInBackground { (error) in
            SVProgressHUD.dismiss()
            if let errorString = error?.localizedDescription {
                NSLog(errorString)
                SVProgressHUD.showError(withStatus: errorString)
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
                SVProgressHUD.showError(withStatus: errorString)
                complete(datas as? [NCMBObject] ?? [NCMBObject]())
            } else {
                complete(datas as? [NCMBObject] ?? [NCMBObject]())
            }
        }
    }
}
