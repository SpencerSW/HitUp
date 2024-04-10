//
//  TextMessageViewController.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/9/24.
//

import UIKit
import CoreData

class MessageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    var storeable: Storeable?
    
    var selectedGroup: Group? {
        didSet{
            if let group = selectedGroup, let currentUser = group.parentUser {
                storeable = Storeable(of: "Items", with: NSPredicate(format: "parentGroup == %@ AND parentUser == %@", group, currentUser))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        messageTextField?.resignFirstResponder()
    }
    
    func getCurrentUser() -> User {
        return (selectedGroup?.parentUser)!
    }
}

//MARK: - Table view functions

extension MessageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeable?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messages = storeable?.data as! [Items]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        
        cell.textMessageLabel.text = messages[indexPath.row].text
        
        return cell
    }
}

//MARK: - textField delegate

extension MessageViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Text field did begin editing")
        messageTextField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let newMessage = Items(context: self.storeable!.context)
        newMessage.parentGroup = selectedGroup
        newMessage.text = text
        newMessage.parentUser = getCurrentUser()
        
        storeable?.addItem(newMessage)
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
        return true
    }
}
