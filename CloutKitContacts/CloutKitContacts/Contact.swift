//
//  Contact.swift
//  CloutKitContacts
//
//  Created by ALIA M NEELY on 6/16/17.
//  Copyright © 2017 Wylan. All rights reserved.
//

import Foundation
import CloudKit

class Contact {
    
    //MARK: - Properties
    
    let name: String
    let email: String
    let phoneNumber: String
    let cKRecordIdString: String
    
    var cloudKitRecord: CKRecord {
        
        let recordID = CKRecordID.init(recordName: cKRecordIdString)
        let record = CKRecord(recordType: Contact.cKRecordTypeKey, recordID: recordID)
        
        record.setValue(name, forKey: kName)
        record.setValue(phoneNumber, forKey: kPhoneNumber)
        record.setValue(email, forKey: kEmail)
        record.setValue(cKRecordIdString, forKey: kCKRecordIdString)
        
        return record
    }
    
    //MARK: - Inits
    
    init(name: String, email: String, phoneNumber: String, uuid: UUID = UUID()) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.cKRecordIdString = uuid.uuidString
    }
    
    init?(CKRecord: CKRecord) {
        guard let name = CKRecord[kName] as? String,
            let email = CKRecord[kEmail] as? String,
            let phoneNumber = CKRecord[kPhoneNumber] as? String,
            let cKRecordIdString = CKRecord[kCKRecordIdString] as? String else {return nil}
        
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.cKRecordIdString = cKRecordIdString
    }
    
    //MARK: - Keys
    static let cKRecordTypeKey = "Contact"
    private let kName = "name"
    private let kPhoneNumber = "phoneNumber"
    private let kEmail = "email"
    private let kCKRecordIdString = "recordIDString"
    
}

