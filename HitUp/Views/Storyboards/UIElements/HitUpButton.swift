//
//  HitUpButton.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/14/24.
//

import UIKit

class HitUpButton: UIButton {
      
      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          
          // Set default properties
          self.setupButton()
      }
      
      private func setupButton() {
          let backgroundColor = UIColor.systemBlue
          let backgroundImage = UIImage.pixel(ofColor: backgroundColor)
          
          self.setBackgroundImage(backgroundImage, for: .normal)
          self.setTitle("Tap Me", for: .normal)
          self.tintColor = .white
          self.layer.cornerRadius = 20
          self.layer.masksToBounds = true
      }
}
