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

        object.saveInBackground { (error) in
            if let errorString = error?.localizedDescription {
                NSLog(errorString)
                complete(1)
            } else {
                complete(0)
            }
        }
    }
}

