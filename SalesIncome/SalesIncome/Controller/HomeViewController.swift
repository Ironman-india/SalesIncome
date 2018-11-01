//
//  HomeViewController.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/10/29.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit
import SnapKit
import MaterialControls
import NCMB

protocol HomeViewControllerDelegate {
    func outLogSales(logs: String)
}

class HomeViewController: UIViewController {
    private let salesProceedsLabel = UILabel()
    private let salesCount = UILabel()
    private let sellButton = MDButton()
    private let cancellButton = MDButton()
    private let customButton = MDButton()
    private let logTextView = UITextView()

    override func loadView() {
        super.loadView()
        self.view.addSubview(self.salesProceedsLabel)
        self.view.addSubview(self.salesCount)
        self.view.addSubview(self.sellButton)
        self.view.addSubview(self.cancellButton)
//        self.view.addSubview(self.customButton)
        self.view.addSubview(self.logTextView)

        allLayoutSetting()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        NCMBManager.saveData(className: "test", keyName: "test", dataValue: "test") { (error) in
//            print(error)
//        }
        // Do any additional setup after loading the view.
    }


    // MARK: - LayoutSetting
    private func allLayoutSetting() {
        //グラデーションの開始色
        //let topColor = UIColor(red: 0.07, green: 0.13, blue: 0.26, alpha: 1)
        //グラデーションの開始色
        //let bottomColor = UIColor(red: 0.54, green: 0.74, blue: 0.74, alpha: 1)
        let topColor = Constants.Color.PureWhite
        let middleColor = UIColor.white
        let bottomColor = Constants.Color.PureWhite
        let gradientColors: [CGColor] = [topColor.cgColor, middleColor.cgColor, bottomColor.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)

        let barButtonItem = UIBarButtonItem()
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 24.0, height: 24.0))
        button.setBackgroundImage(R.image.settingMix(), for: .normal)
        button.addTarget(self, action: #selector(tappedSettingButton), for: .touchUpInside)
        barButtonItem.customView = button
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        self.navigationItem.rightBarButtonItem = barButtonItem
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .blackOpaque

        self.setNavigationBarTitleString(title: "売上計算")

        self.salesProceedsLabel.text = "売り上げ: -円"
        self.salesProceedsLabel.font = UIFont.boldSystemFont(ofSize: 25)
        self.salesProceedsLabel.textColor = Constants.Color.AppleBlack
        self.salesProceedsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(90)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }

        self.salesCount.text = "売り個数: -個"
        self.salesCount.font = UIFont.boldSystemFont(ofSize: 25)
        self.salesCount.textColor = Constants.Color.AppleBlack
        self.salesCount.snp.makeConstraints { (make) in
            make.top.equalTo(self.salesProceedsLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }

        self.sellButton.mdButtonType = .raised
        self.sellButton.rippleColor = Constants.Color.AppleGray
        self.sellButton.backgroundColor = Constants.Color.AppleBlack
        self.sellButton.layer.cornerRadius = 5
        self.sellButton.setTitle("販売", for: .normal)
        self.sellButton.setTitleColor(UIColor.white, for: .normal)
        self.sellButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.sellButton.addTarget(self, action: #selector(tappedSellButton), for: .touchUpInside)
        self.sellButton.addShadow(direction: .bottom)
        self.sellButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.salesCount.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(80)
        }

        self.cancellButton.mdButtonType = .raised
        self.cancellButton.rippleColor = Constants.Color.AppleGray
        self.cancellButton.backgroundColor = Constants.Color.AppleBlack
        self.cancellButton.layer.cornerRadius = 5
        self.cancellButton.setTitle("取り消し", for: .normal)
        self.cancellButton.setTitleColor(UIColor.white, for: .normal)
        self.cancellButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.cancellButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
        self.cancellButton.addShadow(direction: .bottom)
        self.cancellButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.sellButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(50)
        }

        self.logTextView.text = "売り, 金額: -円, 個数: -個, -円/個, 食券: -枚, ----/--/-- - --:--:--\n"
        self.logTextView.textColor = Constants.Color.PureWhite
        self.logTextView.backgroundColor = Constants.Color.AppleBlack
//        self.logTextView.layer.cornerRadius = 5
        self.logTextView.alpha = 1.0
        self.logTextView.isSelectable = true
        self.logTextView.isScrollEnabled = true
        self.logTextView.isEditable = false
        self.logTextView.addShadow(direction: .top)
        self.logTextView.snp.makeConstraints { (make) in
            make.top.equalTo(self.cancellButton.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

// MARK: - Action

    @objc private func tappedSettingButton() {
    }

    @objc private func tappedSellButton() {
        let item = SalesItem(transactionType: "売り", count: 0, price: 20, total: 0, ticket: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let vc = SellingViewController(item: item)
            vc.delegate = self
            self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
    }

    @objc private func tappedCancelButton() {
    }

    @objc private func tappedCustomButton() {
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

extension HomeViewController: HomeViewControllerDelegate {
    func outLogSales(logs: String) {
        self.logTextView.insertText(logs)
    }


}
