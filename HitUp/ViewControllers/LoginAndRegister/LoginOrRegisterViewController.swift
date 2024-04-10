//
//  LoginOrRegisterViewController.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/7/24.
//

import UIKit
import FirebaseAuth

class LoginOrRegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var logoView: UILogo!
    @IBOutlet weak var stackView: UIStackView!
    
    var originalPadding: UIEdgeInsets = .zero
    var keyboardHeight: CGFloat = 0
    var user: User?

    var tap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardTouchOutside))
        
        self.dismissKeyboard()
        
        logoView.setText("Immortalis")
        logoView.setImage(UIImage(named: "Immortalis")!)
        
        customizeBackButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
          
        // Store the original padding of the stack view
        originalPadding = stackView.layoutMargins
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print(user?.email)
        
        if segue.identifier == "messageViewSegue" {
            if let navController = segue.destination as? UINavigationController,
               let groupDisplayTableViewController = navController.topViewController as? GroupDisplayTableViewController {
                groupDisplayTableViewController.user = user
            }
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            // Handle empty email field
            print("Email field is empty")
            return
        }
            
        guard let password = passwordTextField.text, !password.isEmpty else {
            // Handle empty password field
            print("Password field is empty")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                // Handle authentication error
                print("Error signing in: \(error.localizedDescription)")
                return
            }
            
            let storeable = Storeable(of: "User", with: NSPredicate(format: "email LIKE %@", email))

            if let currentUser = storeable.data.first as? User {
                currentUser.loggedIn = true
                storeable.saveData()
            } else {
                print("User not found with email: \(email)")
                return
            }
            
            user = storeable.data.first as? User
            UserDefaults.updateLoggedInStatus(user!.loggedIn)
            
            self.performSegue(withIdentifier: "messageViewSegue", sender: nil)
        }   
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "registerViewSegue", sender: nil)
    }
    
    @IBAction func forgotButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "forgotPasswordSegue", sender: nil)
    }
    
    func dismissKeyboard() {
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
           
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
          if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
              let keyboardRect = keyboardFrame.cgRectValue
              keyboardHeight = keyboardRect.height
              
              // Adjust padding of the stack view to move it above the keyboard
              stackView.layoutMargins.top -= keyboardHeight
          }
      }
      
      @objc func keyboardWillHide(_ notification: Notification) {
          // Reset padding of the stack view to its original value
          stackView.layoutMargins = originalPadding
      }
}
