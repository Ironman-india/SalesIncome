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

class SettingItem: NSObject {
    enum SettingKey {
        case className
        case userName
        case prices
    }

    public var title: String = ""
    public var placeholder: String = ""
    public var value: String
    public var key: SettingKey? = nil

    init(key: SettingKey) {
        switch key {
        case .className:
            self.title = "クラス名"
            self.placeholder = "保存先テーブル"
            self.value = String(Defaults[.USER_CLASS])
            self.key = key
        case .userName:
            self.title = "ユーザー名"
            self.placeholder = "識別用"
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
}
