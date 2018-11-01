//
//  Constants.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/23.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Key {
        static let NCMB_APPLICATION_KEY = "1ac513ece048f601e6a99a22d1cc55a034728429bff42c0d200823178af83345"
        static let NCMB_CLIENT_KEY = "b30d9d3a3668bf203db07db51993be7b06bb84293136d6e4b1c20fa07767ffcd"
    }

    struct NCMBClass {
        static let NCMB_SALES_PRICE = "salesPrice"
        static let NCMB_SALES_TOTAL = "salesTotal"
        static let NCMB_SALEA_LOG = "salesLog"
    }
    struct SalesPrices {
        static let objectId = "objectId"
        static let classes = "class"
        static let prices = "prices"
    }

    struct SalesTotal {
        static let objectId = "objectId"
        static let classes = "class"
        static let count = "count"
        static let total = "total"
    }

    struct SalesItem {
        static let objectId = "objectId"
        static let transactionType = "transactionType"
        static let count = "count"
        static let price = "price"
        static let total = "total"
        static let ticket = "ticket"
        static let user = "user"
        static let time = "time"
    }

    struct Color {
        // Apple Sky
        static let AppleSky = UIColor(red255: 140, green255: 190, blue255: 220)
        static let AppleSkyShadow = UIColor(red255: 98, green255: 113, blue255: 124)

        // Apple Black
        static let AppleBlack = UIColor(red255: 55, green255: 55, blue255: 55)
        static let AppleBlackShadow = UIColor(red255: 75, green255: 75, blue255: 75)

        // Gray
        static let AppleGray = UIColor(red255: 201, green255: 201, blue255: 201)

        // Aqua blue
        static let AppleAquaBlue = UIColor(red255: 37, green255: 218, blue255: 234)
        static let AppleAquaBlueShadow = UIColor(red255: 18, green255: 132, blue255: 201)

        /// Blue
        static let Peterriver = UIColor(hex: 0x3498db)
        static let PeterriverShadow = UIColor(hex: 0x2980b9)
        /// Naby
        static let Wetasphalt = UIColor(hex: 0x34495e)
        static let WetasphaltShadow = UIColor(hex: 0x2c3e50)
        /// Red
        static let Alizarin = UIColor(hex: 0xe74c3c)
        static let AlizarinShadow = UIColor(hex: 0xc0392b)
        /// Green
        static let Emerland = UIColor(hex: 0x2ecc71)
        static let EmerlandShadow = UIColor(hex: 0x27ae60)
        /// White
        static let PureWhite = UIColor(hex: 0xecf0f1)
        static let PureWhiteShadow = UIColor(hex: 0xbdc3c7)

    }

    struct Font {
        static let NOTO_SANS = "Noto Sans Chakma Regular"
        static let GUJA_SAN = "Gujarati Sangam MN"
    }

    struct Notification {
        static let SETTING_OPEN = NSNotification.Name("SETTING_OPEN")
    }
}
