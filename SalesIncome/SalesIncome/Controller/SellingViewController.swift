//
//  SellingViewController.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/10/31.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit
import MaterialControls
import SkyFloatingLabelTextField

class SellingViewController: UIViewController {
    public var delegate: HomeViewControllerDelegate!
    private var item: SalesItem
    private var total: Int = 0 {
        didSet {
            self.totalLabel.text = "合計: \(total)円"
        }
    }
    private var price: Int = 0 {
        didSet {
            self.priceLabel.text = "一個: \(price)円"
        }
    }
    private var count: Int = 0 {
        didSet {
            self.total = count * price
        }
    }
    private let priceLabel = UILabel()
    private let totalLabel = UILabel()
    private let countTxf = SkyFloatingLabelTextField()
    private let enterButton = MDButton()


    init(item: SalesItem) {
        self.price = item.price
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view.addSubview(self.priceLabel)
        self.view.addSubview(self.totalLabel)
        self.view.addSubview(self.countTxf)
        self.view.addSubview(self.enterButton)
        allLayoutSetting()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.priceLabel.text = "一個: \(price)円"
        self.countTxf.becomeFirstResponder()
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
        self.navigationController?.navigationBar.barTintColor = Constants.Color.AppleBlack
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        self.setLeftBackBarButtonItem()
        self.setRightCloseBarButtonItem(action: #selector(tappedNaviCloseButton))
        self.setNavigationBarTitleString(title: "品数入力")

        // Input count
        self.priceLabel.text = "一個: 0円"
        self.priceLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.priceLabel.textColor = Constants.Color.AppleBlack
        self.priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(40)
        }

        self.totalLabel.text = "合計: 0円"
        self.totalLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.totalLabel.textColor = Constants.Color.AppleBlack
        self.totalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.priceLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(40)
        }

        self.countTxf.placeholder = "個数"
        self.countTxf.title = "販売個数"
        self.countTxf.delegate = self
        self.countTxf.setMyAppStyle()
        self.countTxf.errorColor = Constants.Color.Alizarin
        self.countTxf.addTarget(self, action: #selector(countDidChange(_:)), for: .editingChanged)
        self.countTxf.snp.makeConstraints { (make) in
            make.top.equalTo(self.totalLabel.snp.bottom).offset(10)
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
            make.top.equalTo(self.countTxf.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(60)
        }
    }

    @objc private func tappedNaviCloseButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc private func countDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if text.count <= 5 {
                self.count = Int(text) ?? 0
            }
            self.countTxf.errorMessage = ""
        } else {
            self.count = 0
        }
        self.countTxf.text = String(self.count)
    }

    @objc private func closeKeyBoard() {
        self.view.endEditing(true)
    }

    @objc private func tappedEnterButton() {
        if let text = self.countTxf.text {
            if text.count > 0 {
                self.countTxf.errorMessage = ""
                self.item.total = self.total
                self.item.count = self.count
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    let vc = PaymentViewController(item: self.item)
                    vc.delegate = self.delegate
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                self.countTxf.errorMessage = "必須"
            }
        } else {
            self.countTxf.errorMessage = "必須"
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

extension SellingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return true
    }
}
