//
//  backButton.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/17/24.
//

import UIKit

extension UIViewController {
    func customizeBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backButtonImage")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backButtonImage")
    }
}
