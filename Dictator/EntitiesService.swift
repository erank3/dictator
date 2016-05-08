//
//  EntitiesService.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/6/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//

import UIKit
import SQLite

class EntitiesService: NSObject {
    
    private var currentParties: [PartyModel]!
    
    private var db: Connection!
    private var parties: Table!
    private var partyId: Expression<Int>!
    
    private var member_partyId: Expression<Int>!

    
    private var partyName: Expression<String?>!
    
    
    private var firstName: Expression<String?>!
    private var lastName: Expression<String?>!
    


    private let members = Table("Members")

    
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
        if currentParties == nil {
            currentParties = []
            do {
                var party: PartyModel!
                
                for db_party in try db.prepare(parties) {
                    party = PartyModel(id: db_party[partyId], name: db_party[partyName]!)
                    
                    
                    let members_query = members.select(*)
                        .filter(member_partyId == party.id)     // WHERE "name" IS NOT NULL
                    
                    for db_members in try db.prepare(members_query) {
                        party.members.append(MemberModel(firstName: db_members[firstName]!, lastName: db_members[lastName]!))
                    }
                    
                    self.currentParties.append(party)
                }
                
            } catch {
                print("error \(error)")
            }
            
        }
        
        return currentParties
    }
    
    func saveParty(party: PartyModel) {
        do {
            currentParties.append(party)
            party.id = currentParties.count

            let insert = parties.insert(partyName <- party.name, partyId <- party.id)
            try db.run(insert)
            
            for member in party.members {
                let memberInsert = members.insert(firstName <- member.firstName, lastName <- member.lastName, member_partyId <- party.id)
                
                try db.run(memberInsert)
            }
        } catch {
            
        }
    }

    private func initDB() {
        do {
            try db.run(parties.create { t in
                t.column(partyId)
                t.column(partyName)
                })
            
            
            let firstName = Expression<String?>("firstName")
            let lastName = Expression<String?>("lastName")
            
            try db.run(members.create { t in
                t.column(member_partyId)
                t.column(firstName)
                t.column(lastName)
                })
        } catch {
            print("caught: \(error)")
        }
    }
    
    override init() {
        super.init()
        
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first as String!
        
        self.parties = Table("Party")
        self.partyName = Expression<String?>("name")
        self.partyId = Expression<Int>("id")
        
        self.member_partyId = Expression<Int>("party_id")
        
        self.firstName = Expression<String?>("firstName")
        self.lastName = Expression<String?>("lastName")
        
        do {
            db = try Connection("\(path)/db.sqlite3")

            if NSUserDefaults.standardUserDefaults().stringForKey("db_ready") == nil {
                initDB()
                NSUserDefaults.standardUserDefaults().setValue(true, forKey: "db_ready")
            }
        } catch {
            print("caught: \(error)")
        }
        
    }
    
}
