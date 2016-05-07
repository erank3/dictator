//
//  EntitiesService.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/6/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//

import UIKit
import CoreData

class EntitiesService: NSObject {
    
    private var currentParties: [PartyModel] = []
    
    class var sharedInstance: EntitiesService {
        struct Static {
            static var instance: EntitiesService?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = EntitiesService()
        }
        
        return Static.instance!
    }

    
    func getParties() -> [PartyModel] {
        return currentParties
    }
    
    func saveParty(party: PartyModel) {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
    
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Party",
                                                        inManagedObjectContext:managedContext)
        
        let p = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
        
        p.setValue(party.name, forKey: "name")
        
        do {
            try managedContext.save()
            currentParties.append(party)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }

}
