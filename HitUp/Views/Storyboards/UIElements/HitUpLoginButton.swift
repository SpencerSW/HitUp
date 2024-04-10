//
//  HitUpLoginButton.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/14/24.
//

import UIKit

class HitUpLoginButton: UIButton {
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Set default button style
        self.setupButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set default button style
        self.setupButton()
    }
    
    // MARK: - Private Methods
    
    private func setupButton() {
        // Set corner radius
        layer.cornerRadius = 18
        
        // Set border
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemIndigo.cgColor
        
        // Set shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 3
        layer.masksToBounds = false
        
        // Set background color
        if #available(iOS 12.0, *) {
               backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor(named: "ButtonColor") : UIColor(named: "ButtonColor")
           } else {
               backgroundColor = UIColor(named: "ButtonColor") ?? UIColor(named: "ButtonColor")           }
        
        // Set title color
        setTitleColor(.white, for: .normal)
        
        // Set button width constraint to 80% of the screen width
        translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth = screenWidth * 0.8
        widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        // Add target for touch down event
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        
        // Add target for touch up inside event
        addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        addTarget(self, action: #selector(buttonReleased), for: .touchUpOutside)
    }
    
    // MARK: - Button Actions
    
    @objc private func buttonPressed() {
        // Animate button scale down
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func buttonReleased() {
        // Animate button scale up
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - Trait Collection Changes
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Update background color based on trait collection
        if #available(iOS 12.0, *) {
            backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor.darkGray : UIColor.systemBlue
        }
    }
}
