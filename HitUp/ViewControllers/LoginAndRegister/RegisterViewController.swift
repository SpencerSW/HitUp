//
//  RegisterViewController.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/16/24.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var confirmPasswordTextField: LoginTextField!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTextField.becomeFirstResponder()
    }
    
    @IBAction func createAccountButtonPressed(_ sender: LoginButton) {
        // Ensure password and confirm password fields match
        guard let email = registerTextField.text, !email.isEmpty else {
            // Handle empty email field
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            // Handle empty password field
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            // Handle empty confirm password field
            return
        }
        
        guard password == confirmPassword else {
            print("Error: Passwords do not match")
            
            return
        }
        
        let storeable = Storeable(of: "User")
        let newUser = User(context: storeable.context)
        newUser.email = email
        newUser.loggedIn = true
        UserDefaults.updateLoggedInStatus(newUser.loggedIn)
        storeable.addItem(newUser)
        user = newUser
        
        createUserAndDismiss(withEmail: email, password: password) { [weak self] newUser, error in
            guard let self = self else { return }
            
            dismiss(animated: true) {
                // Get the navigation controller
                print(self.user?.email)
                if let navigationController = self.navigationController {
                    // Get the root view controller
                    if let rootViewController = navigationController.viewControllers.first as? LoginOrRegisterViewController {
                        // Perform the segue from the root view controller
                        rootViewController.user = self.user
                        rootViewController.performSegue(withIdentifier: "messageViewSegue", sender: nil)
                    } else {
                        print("Error: Unable to find root view controller or cast it to LoginOrRegisterViewController")
                    }
                } else {
                    print("Error: Unable to access navigation controller")
                }
            }
        }
        
        func createUserAndDismiss(withEmail email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                guard self != nil else {
                    completion(nil, NSError(domain: "YourDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Self is nil"]))
                    return
                }
                
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                completion(newUser, nil)
            }
        }
    }
}
