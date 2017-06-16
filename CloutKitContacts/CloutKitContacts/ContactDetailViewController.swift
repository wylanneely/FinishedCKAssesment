//
//  ContactDetailViewController.swift
//  CloutKitContacts
//
//  Created by ALIA M NEELY on 6/16/17.
//  Copyright © 2017 Wylan. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    var contact: Contact?
    var indexOfContactInController: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if contact == nil {
            guard let contact = contact
                else { return }
            self.nameTextField.text = contact.name
            self.emailTextField.text = contact.email
            self.phoneNumberTextField.text = contact.phoneNumber
        } else {
            guard let contact = contact
                else {return}
            self.nameTextField.text = contact.name
            self.emailTextField.text = contact.email
            self.phoneNumberTextField.text = contact.phoneNumber
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if contact == nil {
            guard let name = nameTextField.text, name != "",
                let phoneNumber = phoneNumberTextField.text,
                let email = emailTextField.text
                else { return }
            ContactController.createContactWith(name: name, email: email, phoneNumber: phoneNumber)
            navigationController?.popViewController(animated: true)
            
        } else {
            guard let contact = contact,
                let name = nameTextField.text,
                let phoneNumber = phoneNumberTextField.text,
                let email = emailTextField.text,
                let indexOfContactInController = indexOfContactInController
                else { return }
            let modifiedContact = Contact(name: name, email: email, phoneNumber: phoneNumber)
            ContactController.modifyContactRecord(contact: contact, newContactRecord: modifiedContact.cloudKitRecord)
            ContactController.contacts.remove(at: indexOfContactInController)
            ContactController.contacts.insert(modifiedContact, at: indexOfContactInController)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
}
