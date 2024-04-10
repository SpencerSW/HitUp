//
//  LoginViewController.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/7/24.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goToMainViewOne(_ sender: UIButton) {
        performSegue(withIdentifier: "groupMessagingSegue", sender: nil)
    }
    
}
