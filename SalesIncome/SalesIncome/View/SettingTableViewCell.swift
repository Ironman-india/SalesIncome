//
//  SettingTableViewCell.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/11/01.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyUserDefaults

class SettingTableViewCell: UITableViewCell {
    private let settingTxf = SkyFloatingLabelTextField()
    private var item: SettingItem!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        self.priceLabel.backgroundColor = Constants.Color.PureWhite
        self.settingTxf.placeholder = ""
        self.settingTxf.title = ""
        let numberToolbar: UIToolbar = UIToolbar()
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(closeKeyBoard))
        ]
        numberToolbar.sizeToFit()
        self.settingTxf.titleColor = Constants.Color.AppleBlack
        self.settingTxf.selectedTitleColor = Constants.Color.AppleBlack
        self.settingTxf.placeholderColor = Constants.Color.AppleGray
        self.settingTxf.textColor = Constants.Color.AppleBlack
        self.settingTxf.font = UIFont.boldSystemFont(ofSize: 20)
        self.settingTxf.placeholderFont = UIFont.boldSystemFont(ofSize: 15)
        self.settingTxf.titleFont = UIFont.boldSystemFont(ofSize: 15)
        self.settingTxf.inputAccessoryView = numberToolbar
        self.settingTxf.keyboardType = .default
        self.settingTxf.textAlignment = .left
        self.settingTxf.errorColor = Constants.Color.Alizarin
        self.contentView.addSubview(self.settingTxf)
        self.settingTxf.snp.makeConstraints { (make) in
            make.height.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func setCell(item: SettingItem) {
        self.item = item
        self.settingTxf.placeholder = item.placeholder
        self.settingTxf.title = item.title
        if item.key == .prices {
            self.item?.getSalesPrice { (datas) in
                self.settingTxf.text = item.value
                for data in datas {
                    if let arr = data.object(forKey: Constants.SalesPrices.prices) as? [Int] {
                        let strArr = arr.map({ String($0) })
                        DispatchQueue.main.async {
                            self.item?.value = strArr.joined(separator: ",")
                            self.settingTxf.text = item.value
                        }
                    }
                }
            }
        }
        self.settingTxf.text = item.value
        self.settingTxf.addTarget(self, action: #selector(changedCullum), for: .editingDidEnd)
    }

    @objc func closeKeyBoard() {
        self.endEditing(true)
    }

    @objc public func changedCullum() {
        print(self.item)
        if let item = self.item {
            switch item.key {
            case .className:
                Defaults[.USER_CLASS] = self.settingTxf.text ?? "NONE"

            case .userName:
                Defaults[.USER_NAME] = self.settingTxf.text ?? "Unknown"
                break
            case .prices:
                self.item.value = self.settingTxf.text ?? ""
                let numn = self.settingTxf.text?.split(separator: ",")
                var num = [Int]()
                for numi in numn ?? [Substring]() {
                    if let newNum = Int(numi) {
                        num.append(newNum)
                    } else {
                        self.settingTxf.errorMessage = "保存に失敗しました"
                        return
                    }
                }

                self.item.updateSalesPrice(priceData: num) { (code) in
                    if code == 0 {
                        self.settingTxf.errorMessage = ""
                        Defaults[.ITEM_PRICE] = num
                    } else {
                        self.settingTxf.errorMessage = "保存に失敗しました"
                    }
                }
            }
        }
    }
}

