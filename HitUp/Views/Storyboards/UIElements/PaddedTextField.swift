//
//  PaddedTextField.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/15/24.
//

import UIKit

class PaddedTextField: UITextField {
    
    // Padding for the bottom of the text field
    var bottomPadding: CGFloat = 0.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: bottomPadding, right: 0))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: bottomPadding, right: 0))
    }
}
