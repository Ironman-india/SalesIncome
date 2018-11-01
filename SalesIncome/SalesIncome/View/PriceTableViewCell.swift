//
//  PriceTableViewCell.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/11/01.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit
import SnapKit

class PriceTableViewCell: UITableViewCell {
    private let priceLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.priceLabel.backgroundColor = Constants.Color.PureWhite
        self.priceLabel.textColor = Constants.Color.AppleBlack
        self.priceLabel.font = UIFont.boldSystemFont(ofSize: 30)
        self.priceLabel.textAlignment = .center
        self.contentView.addSubview(self.priceLabel)
        self.priceLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func setCell(price: Int) {
        priceLabel.text = "\(price)円"
    }
}
