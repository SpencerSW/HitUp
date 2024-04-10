//
//  LoginButton.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/16/24.
//

import UIKit

class LoginButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    private func setupButton() {
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor(red: 0.36, green: 0.75, blue: 0.75, alpha: 1.00)
        layer.cornerRadius = 20
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 6
    }
}
