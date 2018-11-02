//
//  PaymentViewController.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/11/01.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD
import ZFRippleButton

class PaymentViewController: UIViewController {
    public var delegate: HomeViewControllerDelegate!
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
            let receiptTicket = self.ticketPrice * self.ticket
            if self.total < receiptTicket {
                self.change = 0
            } else {
                self.change = receiptTicket + self.receipt - self.total
            }
        }
    }
    private var ticket: Int = 0 {
        didSet {
            let receiptTicket = self.ticketPrice * self.ticket
            if self.total < receiptTicket {
                self.change = 0
            } else {
                self.change = receiptTicket + receipt - self.total
            }
        }
    }
    private let totalLabel = UILabel()
    private let changeLabel = UILabel()
    private let receiptTxf = SkyFloatingLabelTextField()
    private let ticketTxf = SkyFloatingLabelTextField()
    private let enterButton = ZFRippleButton()

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
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.receiptTxf.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.view.endEditing(true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.enterButton.isHighlighted = false
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
        self.navigationController?.navigationBar.barTintColor = Constants.Color.AppleBlack
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        self.setLeftBackBarButtonItem()
        self.setRightCloseBarButtonItem(action: #selector(tappedNaviCloseButton))
        self.setNavigationBarTitleString(title: "支払い")

        // Input count
        self.totalLabel.text = "合計: \(self.total)円"
        self.totalLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.totalLabel.textColor = Constants.Color.AppleBlack
        self.totalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.05)
        }

        self.changeLabel.text = "お釣り: \(self.change)円"
        self.changeLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.changeLabel.textColor = Constants.Color.AppleBlack
        self.changeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.totalLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.05)
        }

        self.receiptTxf.placeholder = "預かり: \(total)円"
        self.receiptTxf.title = "預かり金額"
        self.receiptTxf.setMyAppStyle()
        self.receiptTxf.errorColor = Constants.Color.Alizarin
        self.receiptTxf.addTarget(self, action: #selector(receiptDidChange(_:)), for: .editingChanged)
        self.receiptTxf.snp.makeConstraints { (make) in
            make.top.equalTo(self.changeLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.1)
        }

        self.ticketTxf.placeholder = "食券: \(ticket)枚"
        self.ticketTxf.title = "食券枚数(\(self.ticketPrice)円)"
        self.ticketTxf.setMyAppStyle()
        self.ticketTxf.addTarget(self, action: #selector(ticketDidChange(_:)), for: .editingChanged)
        self.ticketTxf.snp.makeConstraints { (make) in
            make.top.equalTo(self.receiptTxf.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.1)
        }

        self.enterButton.trackTouchLocation = true
        self.enterButton.buttonCornerRadius = 5
        self.enterButton.rippleColor = Constants.Color.AppleGray
        self.enterButton.rippleBackgroundColor = Constants.Color.AppleBlack
        self.enterButton.backgroundColor = Constants.Color.AppleBlack
        self.enterButton.setTitle("支払い完了", for: .normal)
        self.enterButton.setTitleColor(UIColor.white, for: .normal)
        self.enterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.enterButton.addTarget(self, action: #selector(tappedEnterButton), for: .touchUpInside)
        self.enterButton.addShadow(direction: .bottom)
        self.enterButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.ticketTxf.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
    }


//MARK:- Function
    private func canPay() {
    }

// MARK: - Action
    @objc private func receiptDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if text.count <= 10 {
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
            if text.count <= 10 {
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

    @objc private func tappedNaviCloseButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc private func tappedEnterButton() {
        if self.change >= 0 {
            SVProgressHUD.show()
            self.enterButton.isUserInteractionEnabled = false
            self.receiptTxf.errorMessage = ""
            self.receiptTxf.text = String(self.receipt)
            self.ticketTxf.text = String(self.ticket)

            self.item.ticket = self.ticket
            self.item.time = Date()

            self.item.saveSalesItem { (code) in
                if code == 0 {
                    let total = SalesTotalItem(total: self.item.total, count: self.item.count)
                    total.updateSalesTotal(complete: { (code) in
                        SVProgressHUD.dismiss()
                        if code == 0 {
                            self.enterButton.isUserInteractionEnabled = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.navigationController?.dismiss(animated: true, completion: nil)
                            }
                            self.delegate.successPayment(item: self.item)
                        } else {
                            self.enterButton.isUserInteractionEnabled = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.navigationController?.dismiss(animated: true, completion: nil)
                            }
                        }
                    })
                } else {
                    SVProgressHUD.dismiss()
                    self.enterButton.isUserInteractionEnabled = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }
                }
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
