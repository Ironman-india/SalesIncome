//
//  UIViewControllerEx.swift
//  FiMap
//
//  Created by AmamiYou on 2018/10/09.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /// Push ViewController on new NavigationController

    /// Sets the navigation bar menu on the left bar button.
    /// Also add the left gesture.
    func setLeftBackBarButtonItem(action: Selector = #selector(tappedBackButton)) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButton(image: R.image.back(), position: .left, target: self, action: action)
    }
    /// Sets the navigation bar menu on the left bar button.
    /// Also add the left gesture.
    func setRightCloseBarButtonItem(action: Selector = #selector(tappedCloseButton)) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButton(image: R.image.close(), position: .right, target: self, action: action)
    }

    @objc private func tappedBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func tappedCloseButton() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    func setNavigationBarTitleString(title: String) {
        let titleLbl = UILabel()
        titleLbl.font = UIFont.boldSystemFont(ofSize: 22)
        titleLbl.text = title
        titleLbl.sizeToFit()
        titleLbl.textColor = UIColor.white//Constants.Color.AppleGray
        titleLbl.textAlignment = .center
        titleLbl.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleLbl
    }

//    func setNavigationBarTitleLogo() {
//        let logoView = UIImageView(image: UIImage(named: "logo_pay_header"))
//        logoView.contentMode = .scaleAspectFit
//        self.navigationItem.titleView = logoView
//    }
}
