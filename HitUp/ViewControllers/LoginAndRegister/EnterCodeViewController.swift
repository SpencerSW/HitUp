//
//  EnterCodeViewController.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/16/24.
//

import UIKit

class EnterCodeViewController: UIViewController {

    @IBOutlet weak var verificationCodeTextField: LoginTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        verificationCodeTextField.becomeFirstResponder()
        customizeBackButton()
    }
    
    @IBAction func passwordButtonPressed(_ sender: LoginButton) {
        performSegue(withIdentifier: "newPasswordSegue", sender: nil)
    }
}
