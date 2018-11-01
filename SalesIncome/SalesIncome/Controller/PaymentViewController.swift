//
//  PaymentViewController.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/11/01.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MaterialControls

class PaymentViewController: UIViewController {
    private var item: SalesItem
    private let ticketPrice = 100

    private var total: Int = 0 {
        didSet {
            self.totalLabel.text = "合計: \(total)円"
        }
    }
    private var change: Int = 0 {
        didSet {
            if change >= 0 {
                self.changeLabel.text = "お釣り: \(change)円"
            } else {
                self.changeLabel.text = "不足: \(change * -1)円"
            }
        }
    }
    private var receipt: Int = 0 {
        didSet {
            if self.ticket > 0 {
                let reChange = (receipt + (self.ticket * self.ticketPrice)) - self.total
                if reChange <= 0 {
                    self.change = reChange
                } else {
                    self.change = 0
                }
            } else {
                self.change = receipt - self.total
            }
        }
    }
    private var ticket: Int = 0 {
        didSet {
            if ticket > 0 {
                let reChange = (self.receipt + (ticket * self.ticketPrice)) - self.total
                if reChange <= 0 {
                    self.change = reChange
                } else {
                    self.change = 0
                }
            } else {
                self.change = self.receipt - self.total
            }
        }
    }
    private let totalLabel = UILabel()
    private let changeLabel = UILabel()
    private let receiptTxf = SkyFloatingLabelTextField()
    private let ticketTxf = SkyFloatingLabelTextField()
    private let enterButton = MDButton()

    init(item: SalesItem) {
        self.total = item.total
        self.receipt = self.total
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view.addSubview(self.totalLabel)
        self.view.addSubview(self.changeLabel)
        self.view.addSubview(self.receiptTxf)
        self.view.addSubview(self.ticketTxf)
        self.view.addSubview(self.enterButton)
        allLayoutSetting()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.receiptTxf.becomeFirstResponder()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.view.endEditing(true)
    }

    // MARK: - Layout Setting
    private func allLayoutSetting() {
        let topColor = Constants.Color.PureWhite
        let middleColor = UIColor.white
        let bottomColor = Constants.Color.PureWhite
        let gradientColors: [CGColor] = [topColor.cgColor, middleColor.cgColor, bottomColor.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //        self.navigationController?.navigationBar.barTintColor = Constants.Color.AppleBlack
        //        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .blackOpaque
        self.setLeftBackBarButtonItem(action: #selector(tappedNaviBackButton))
        self.setRightCloseBarButtonItem(action: #selector(tappedNaviCloseButton))
        self.setNavigationBarTitleString(title: "支払い")

        // Input count
        self.totalLabel.text = "合計: \(self.total)円"
        self.totalLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.totalLabel.textColor = Constants.Color.AppleBlack
        self.totalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(90)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(40)
        }

        self.changeLabel.text = "お釣り: \(self.change)円"
        self.changeLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.changeLabel.textColor = Constants.Color.AppleBlack
        self.changeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.totalLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(40)
        }

        self.receiptTxf.placeholder = "預かり: \(total)円"
        self.receiptTxf.title = "預かり金額"
        self.receiptTxf.setMyAppStyle()
        self.receiptTxf.errorColor = Constants.Color.Alizarin
        self.receiptTxf.addTarget(self, action: #selector(receiptDidChange(_:)), for: .editingChanged)
        self.receiptTxf.snp.makeConstraints { (make) in
            make.top.equalTo(self.changeLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
        }

        self.ticketTxf.placeholder = "食券: \(ticket)枚"
        self.ticketTxf.title = "食券枚数(\(self.ticketPrice)円)"
        self.ticketTxf.setMyAppStyle()
        self.ticketTxf.addTarget(self, action: #selector(ticketDidChange(_:)), for: .editingChanged)
        self.ticketTxf.snp.makeConstraints { (make) in
            make.top.equalTo(self.receiptTxf.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
        }

        self.enterButton.mdButtonType = .raised
        self.enterButton.rippleColor = Constants.Color.AppleGray
        self.enterButton.backgroundColor = Constants.Color.AppleBlack
        self.enterButton.layer.cornerRadius = 5
        self.enterButton.setTitle("支払い", for: .normal)
        self.enterButton.setTitleColor(UIColor.white, for: .normal)
        self.enterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.enterButton.addTarget(self, action: #selector(tappedEnterButton), for: .touchUpInside)
        self.enterButton.addShadow(direction: .bottom)
        self.enterButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.ticketTxf.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(60)
        }
    }


    //MARK:- Function
    private func canPay() {
    }

    // MARK: - Action
    @objc private func receiptDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if text.count <= 5 {
                self.receipt = Int(text) ?? 0
            }
            self.receiptTxf.errorMessage = ""
        } else {
            self.receipt = 0
        }
        self.receiptTxf.text = String(self.receipt)
    }

    @objc private func ticketDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if text.count <= 5 {
                self.ticket = Int(text) ?? 0
            }
            self.receiptTxf.errorMessage = ""
        } else {
            self.ticket = 0
        }
        self.ticketTxf.text = String(self.ticket)
    }

    @objc private func closeKeyBoard() {
        self.view.endEditing(true)
    }

    @objc private func tappedNaviBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func tappedNaviCloseButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc private func tappedEnterButton() {
        if self.change >= 0 || self.ticket > 0 {
            self.receiptTxf.errorMessage = ""
            self.receiptTxf.text = String(self.receipt)
            self.ticketTxf.text = String(self.ticket)

            self.item.ticket = self.ticket
            self.item.time = Date()

            self.item.saveSalesItem { (code) in
                NSLog("Log保存%d", code)
                let total = SalesTotalItem(total: self.item.total, count: self.item.count)
                total.updateSalesTotal(complete: { (code) in
                    NSLog("Total保存%d", code)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                        //
                    }
                })
            }
        } else {
            self.receiptTxf.errorMessage = "不足"
        }
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
