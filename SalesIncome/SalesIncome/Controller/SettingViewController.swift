//
//  SettingViewController.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/11/01.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyUserDefaults

class SettingViewController: UIViewController {
    public var delegate: HomeViewControllerDelegate!
    private var dataSource = [
        SettingItem(key: .className),
        SettingItem(key: .userName),
        SettingItem(key: .prices)
    ]

    private let tableView = UITableView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view.addSubview(self.tableView)
        allLayoutSetting()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }

    private func allLayoutSetting() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.backgroundColor = Constants.Color.AppleBlack
        self.tableView.backgroundColor = Constants.Color.AppleBlack
        self.tableView.sectionIndexBackgroundColor = UIColor.clear
        self.tableView.separatorStyle = .singleLine
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        self.tableView.tableFooterView = UIView(frame: .zero)

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
        self.setLeftBackBarButtonItem(action: #selector(tappedNaviBackButton))
        self.setNavigationBarTitleString(title: "設定")
        self.tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.className)
    }

    @objc private func tappedNaviBackButton() {
        self.dismiss(animated: true, completion: nil)
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

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.className, for: indexPath)
        (cell as? SettingTableViewCell)?.setCell(item: dataSource[indexPath.item])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
