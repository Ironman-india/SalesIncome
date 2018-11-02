//
//  SelectingViewController.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/11/01.
//  Copyright © 2018 ammYou. All rights reserved.
//

import UIKit
import SnapKit
import MaterialControls
import SkyFloatingLabelTextField

class SelectingViewController: UIViewController {
    public var delegate: HomeViewControllerDelegate!
    private var item: SalesItem
    private var dataSource = SalesPriceItem()
    private let tableView = UITableView()

    init(item: SalesItem) {
        self.item = item
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
        self.setNavigationBarTitleString(title: "価格選択")
        self.tableView.register(PriceTableViewCell.self, forCellReuseIdentifier: PriceTableViewCell.className)

        self.dataSource.getSalesPrice { (datas) in
            for data in datas {
                if let price = data.object(forKey: Constants.SalesPrices.prices) as? [Int] {
                    self.dataSource.prices = price
                    self.tableView.reloadData()
                }
            }

        }

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

extension SelectingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.prices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PriceTableViewCell.className, for: indexPath)
        (cell as? PriceTableViewCell)?.setCell(price: self.dataSource.prices[indexPath.item])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.item.price = self.dataSource.prices[indexPath.item]
            let vc = SellingViewController(item: self.item)
            vc.delegate = self.delegate
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
