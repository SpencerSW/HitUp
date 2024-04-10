//
//  GroupDisplayTableViewController.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/7/24.
//

import UIKit
import CoreData

class GroupDisplayTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var groups: Storeable?
    var contacts:  Storeable?
    var contactDelegate: ContactSelectionDelegate?
    var groupContacts: Storeable?
    
    var user: User? {
        didSet {
            groups = Storeable(of: "Group", with: NSPredicate(format: "parentUser.email MATCHES %@", user!.email ?? "empty"))
            contacts = Storeable(of: "Contact", with: NSPredicate(format: "parentUser.email MATCHES %@", user!.email ?? "empty"))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactDelegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupTableViewCell")
        tableView.reloadData()
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MessageViewSegue" {
            if let tabBarController = segue.destination as? UITabBarController,
               let messageViewController = tabBarController.viewControllers?.first as? MessageViewController {
                   if let indexPath = tableView.indexPathForSelectedRow {
                       messageViewController.selectedGroup = groups?.data[indexPath.row] as? Group
                   }
                   if let selectedIndexPath = tableView.indexPathForSelectedRow {
                       tableView.deselectRow(at: selectedIndexPath,  animated: true
                       )}
            }
        } else if segue.identifier == "ContactViewSegue" {
            if let contactSelectionVC = segue.destination as? ContactViewController {
                contactSelectionVC.user = self.user
                print(self.contacts)
                
                if let unwrappedContacts = contacts {
                    for contact in unwrappedContacts.data {
                        if let name = contact.value(forKey: "name") as? String {
                                 print(name)
                             }
                             if let parentUser = contact.value(forKey: "parentUser") as? Any {
                                 print("Hello")
                                 print(parentUser)
                             }
                    }
                }
                
                contactSelectionVC.delegate = contactDelegate
            }
        }
    }

    //MARK: - Add new Group
    
    @IBAction func addConversationButtonPressed(_ sender: UIBarButtonItem) {
        
        let newGroup = Group(context: self.groups!.context)
        
        pickContacts(newGroup)
        addGroup()
    }
    
    @IBAction func addContactButtonPressed(_ sender: UIBarButtonItem) {
        addContact()
    }
    
    func pickContacts(_ newGroup: Group) {
        performSegue(withIdentifier: "ContactViewSegue", sender: self)
    }
    
    func addContact() {
        let users = Storeable(of: "User", with: NSPredicate(format: "email != nil"))
        
        let addContactAlert = UIAlertController(title: "New Contact", message: "Enter the name and email of the new contact", preferredStyle: .alert)
        addContactAlert.addTextField { textField in
            textField.placeholder = "Name"
        }
        addContactAlert.addTextField { textField in
            textField.placeholder = "Email"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let nameTextField = addContactAlert.textFields?.first,
                  let emailTextField = addContactAlert.textFields?.last,
                  let name = nameTextField.text,
                  let email = emailTextField.text,
                  !name.isEmpty, !email.isEmpty else {
                // Handle the case where either name or email is empty
                return
            }
            
            // Check if a user with the provided email exists
            let userPredicate = NSPredicate(format: "email == %@", email)
            let existingUsers = users.fetchItems(withPredicate: userPredicate)
            
            if (existingUsers?.first) != nil {
                // If a user with the email exists, create the contact
                let newContact = Contact(context: self.contacts!.context)
                newContact.name = name
                newContact.email = email
                print(self.user as Any)
                newContact.parentUser = self.user
                self.contacts?.addItem(newContact)
            } else {
                // Handle the case where no user with the provided email exists
                let alertController = UIAlertController(title: "User Not Found", message: "No user found with the provided email.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addContactAlert.addAction(addAction)
        addContactAlert.addAction(cancelAction)

        self.present(addContactAlert, animated: true, completion: nil)

    }

    func addGroup() {
        let alert = UIAlertController(title: "Group Name", message: "Add a group name for this conversation", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter group name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            // Handle adding the group
            guard let groupName = alert.textFields?.first?.text, !groupName.isEmpty else {
                let emptyNameAlert = UIAlertController(title: "Empty Group Name", message: "Please enter a group name.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.addGroup()
                }
                emptyNameAlert.addAction(okAction)
                self.present(emptyNameAlert, animated: true, completion: nil)
                return
            }
            
            var newGroup = Group(context: self.groups!.context)
            newGroup.name = groupName
            newGroup.parentUser = self.user
            
            // Assign selected contacts to the new group
//            for contact in self.selectedContacts {
//                newGroup.addToContacts(contact)
//            }
            
            self.groups?.addItem(newGroup)
            self.tableView.reloadData()
            
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Table view functions

extension GroupDisplayTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groups = groups?.data as! [Group]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath) as! GroupTableViewCell
        
        cell.groupNameLabel.text = groups[indexPath.row].name
        cell.recentTextLabel.text = "Howdy"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            // Perform delete action
            self.groups?.removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MessageViewSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
}

//MARK: - Contact selection

extension GroupDisplayTableViewController: ContactSelectionDelegate {
    
    func didSelectContacts(_ contacts: Set<Contact>) {
        
//        groupContacts = Storeable(of: "Contact")
//        
//        for contact in contacts {
//            groupContacts?.addItem(contact)
//        }
        
        self.tableView.reloadData()
    }
}
