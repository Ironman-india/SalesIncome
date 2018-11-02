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
    private let item: SettingItem? = nil
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
        self.settingTxf.placeholder = item.placeholder
        self.settingTxf.title = item.title
        self.settingTxf.text = item.value
        self.settingTxf.addTarget(self, action: #selector(changedCullum), for: .editingDidEnd)
    }

    @objc func closeKeyBoard() {
        self.endEditing(true)
    }

    @objc public func changedCullum() {
        print(self.settingTxf.text)
    }
}
