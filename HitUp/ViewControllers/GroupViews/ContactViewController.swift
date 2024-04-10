//
//  ContactViewController.swift
//  HitUp
//
//  Created by Spencer McLaughlin on 2/28/24.
//
import UIKit
import CoreData

protocol ContactSelectionDelegate: AnyObject {
    func didSelectContacts(_ contacts: Set<Contact>)
}

class ContactViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var groups: Storeable?
    var contacts: Storeable?
    
    var user: User? {
        didSet {
            groups = Storeable(of: "Group", with: NSPredicate(format: "parentUser.email MATCHES %@", user!.email ?? "empty"))
            contacts = Storeable(of: "Contact", with: NSPredicate(format: "parentUser.email MATCHES %@", user!.email ?? "empty"))
        }
    }
    
    var selectedContacts: Set<Contact> = []
    weak var delegate: ContactSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        delegate?.didSelectContacts(selectedContacts)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate

extension ContactViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let contact = contacts?.data[indexPath.row] as? Contact {
            if selectedContacts.contains(contact) {
                selectedContacts.remove(contact)
            } else {
                selectedContacts.insert(contact)
            }
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = contacts?.data[indexPath.row] as? Contact
        cell.textLabel?.text = contact?.name
        print(contact?.name)
        
        cell.accessoryType = selectedContacts.contains(contact!) ? .checkmark : .none
        
        return cell
    }
}
