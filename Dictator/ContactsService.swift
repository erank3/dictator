//
//  ContactsService.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/6/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//

import UIKit
import Contacts
import PromiseKit


class ContactsService: NSObject {
    
    
    class var sharedInstance: ContactsService {
        struct Static {
            static var instance: ContactsService?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ContactsService()
        }
        
        return Static.instance!
    }
    
    
    var contactStore = CNContactStore()
    
    func getContacts() -> [CNContact] {
        
        var retVal: [CNContact] = []
        do {
            try contactStore.enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey])) {
                (contact, cursor) -> Void in
                retVal.append(contact)
            }
        }
        catch{
            //DialogService.instance.showException(ContactsPermissionsError(), parent: ) ()
        }
        
        return retVal
    }
    
    func requestForAccess() -> Promise<Bool> {
        return Promise{fulfill, report in
            let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
            
            switch authorizationStatus {
            case .Authorized:
                fulfill(true)
            case .Denied, .NotDetermined:
                self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
                    if access {
                        fulfill(access)
                    }
                    else {
                        if authorizationStatus == CNAuthorizationStatus.Denied {
                            fulfill(false)
                        }
                    }
                })
                
            default:
                fulfill(false)
            }
            
        }
        
    }
}