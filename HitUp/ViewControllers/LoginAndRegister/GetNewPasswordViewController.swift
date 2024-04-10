//
//  GetNewPasswordViewController.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/17/24.
//

import UIKit

class GetNewPasswordViewController: UIViewController {

    @IBOutlet weak var newPasswordTextField: LoginTextField!
    @IBOutlet weak var confirmNewPasswordTextField: LoginTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newPasswordTextField.becomeFirstResponder()
        customizeBackButton()
    }
    
    @IBAction func savePasswordButtonPressed(_ sender: LoginButton) {
        
        dismiss(animated: true) {
            // Get the navigation controller
            if let navigationController = self.navigationController {
                // Get the root view controller
                if let rootViewController = navigationController.viewControllers.first as? LoginOrRegisterViewController {
                    // Perform the segue from the root view controller
                    rootViewController.performSegue(withIdentifier: "messageViewSegue", sender: nil)
                } else {
                    print("Error: Unable to find root view controller or cast it to LoginOrRegisterViewController")
                }
            } else {
                print("Error: Unable to access navigation controller")
            }
        }
    }
}
