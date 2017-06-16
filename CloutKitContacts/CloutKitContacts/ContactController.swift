//
//  ContactController.swift
//  CloutKitContacts
//
//  Created by ALIA M NEELY on 6/16/17.
//  Copyright © 2017 Wylan. All rights reserved.
//

import Foundation
import CloudKit



class ContactController {
    
    static let contactsWereUpdatedNotification = Notification.Name("ContactsWereUpdated")
    static var contacts: [Contact] = [] {
        didSet {
            DispatchQueue.main.async{NotificationCenter.default.post(name: contactsWereUpdatedNotification, object: self)}
        }}
    
    //MARK: - CloudKit Functions
    
    static func createContactWith(name: String, email: String, phoneNumber: String) {
        let contact = Contact(name: name, email: email, phoneNumber: phoneNumber)
        CKContainer.default().publicCloudDatabase.save(contact.cloudKitRecord) { (record, error) in
            if let error = error { NSLog("Error Saving Record to CLOUDKIT: \(error.localizedDescription) ") }
            else { self.contacts.append(contact) }
        }
    }
    
    static func fetchContacts() {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Contact.cKRecordTypeKey, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error { NSLog("Error Fetching from CLOUTKIT: \(error.localizedDescription)")}
            guard let records = records else { return }
            
            let contacts = records.flatMap({ Contact(CKRecord: $0) })
            self.contacts = contacts
        }
    }
    
    static func modifyContactRecord(contact: Contact ,newContactRecord: CKRecord) {
        
        let cKRecordID = CKRecordID.init(recordName: contact.cKRecordIdString)
        let operation = CKModifyRecordsOperation(recordsToSave: [newContactRecord], recordIDsToDelete: [cKRecordID])
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    static func deleteContactFromCoudKit(contact: Contact, completion: ((_ recordID: CKRecordID?, _ error: Error?) -> Void)?) {
        let ckRecordID = CKRecordID.init(recordName: contact.cKRecordIdString)
        CKContainer.default().publicCloudDatabase.delete(withRecordID: ckRecordID) { (recordID, error) in
            completion?(recordID, error)
        }
    }
    
    static func subscribeToContactCreations() {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: Contact.cKRecordTypeKey, predicate: predicate, options: .firesOnRecordCreation)
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = "A New Contact Has Been Created!"
        notificationInfo.soundName = "default"
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        CKContainer.default().publicCloudDatabase.save(subscription) { (_, error) in
            if let error = error { NSLog("Error Subscribing to Creation of Contacts: \(error.localizedDescription)") }
        }
    }

    
    
    
    
    
    
    
}
