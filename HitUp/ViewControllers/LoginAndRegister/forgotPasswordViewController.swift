//
//  ForgotPasswordViewController.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/16/24.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: LoginTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.becomeFirstResponder()
        customizeBackButton()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "newCodeSegue", sender: nil)
    }
}
