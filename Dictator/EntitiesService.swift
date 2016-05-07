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
        
        let entity = NSEntityDescription.entityForName("Party",
                                                        inManagedObjectContext:managedContext)
        
        let p = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
        
        p.setValue(party.name, forKey: "name")
        
        
        var managedMembers: [NSManagedObject] = []
        for member in party.members {
            let memberEntity = NSEntityDescription.entityForName("Member",        inManagedObjectContext:managedContext)
            
            let memberManaged = NSManagedObject(entity: memberEntity!, insertIntoManagedObjectContext: managedContext)
            
            memberManaged.setValue(member.firstName, forKey: "firstName")
            
            managedMembers.append(memberManaged)
        }
        
        p.setValue(NSSet(objects: managedMembers), forKey: "members")
        
        //p.setValue("test", forKey: "members")
        
        do {
            try managedContext.save()
            currentParties.append(party)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }

    override init() {
    
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Party")
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            if let managedParties = results as? [NSManagedObject] {
            
                for mp in managedParties {
                    if let name = mp.valueForKey("name") as? String {
                        self.currentParties.append(PartyModel(name: name))
                    }
                    
                    if let members = mp.valueForKey("members") as? NSSet {
                        for member in members {
                            print(member)
                        }
                    }
                }
                
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
}
