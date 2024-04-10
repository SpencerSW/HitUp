//
//  LoginTextField.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/15/24.
//

import UIKit

class LoginTextField: UITextField {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.backgroundColor = UIColor.clear.withAlphaComponent(0.4)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 15.0
        self.clipsToBounds = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
