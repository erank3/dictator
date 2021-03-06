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
    private var partyLocation: Expression<String?>!
    private var partyCategory: Expression<String?>!

    
    
    private var firstName: Expression<String?>!
    private var lastName: Expression<String?>!
    private var isDictator: Expression<Bool?>!


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
                    party.location = db_party[partyLocation]
                    
                    if let category = db_party[partyCategory] {
                        party.category = category
                    }
                    
                    
                    
                    let members_query = members.select(*)
                        .filter(member_partyId == party.id)     // WHERE "name" IS NOT NULL
                    
                    for db_members in try db.prepare(members_query) {
                        
                        let member = MemberModel(firstName: db_members[firstName]!, lastName: db_members[lastName]!)
                        
                        party.members.append(member)
                        
                        if(db_members[isDictator] == true) {
                            party.dictator = member
                        }
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
            
            if(party.id > 0) {
                let party_query = parties.filter(partyId == party.id)
                print(try db.run(party_query.update(partyLocation <- party.location)))
                
                
                for member in party.members {
                    let member_query = members.filter(partyId == partyId && firstName == member.firstName && lastName == member.lastName)
                    
                    for member_db in try db.prepare(member_query) {
                        if let dictator = party.dictator where member_db[firstName] == dictator.firstName  && member_db[lastName] == dictator.lastName {
                            // member_db
                            try db.run(member_query.update(isDictator <- true))
                            
                        } else {
                            try db.run(member_query.update(isDictator <- false))
                        }
                    }
                }
            } else {
                currentParties.append(party)
                party.id = currentParties.count
                
                let insert = parties.insert(partyName <- party.name, partyId <- party.id, partyCategory <- party.category)
                
                try db.run(insert)
                
                for member in party.members {
                    var memberInsertQuery: SQLite.Insert!
                    
                    if(member == party.dictator) {
                        memberInsertQuery = members.insert(firstName <- member.firstName, lastName <- member.lastName, member_partyId <- party.id, isDictator <- true)
                    } else {
                        memberInsertQuery = members.insert(firstName <- member.firstName, lastName <- member.lastName, member_partyId <- party.id)
                    }
                    
                    try db.run(memberInsertQuery)
                }
            }

        } catch {
            print("error saving parties \(error)")
        }
    }

    private func initDB() {
        do {
            try db.run(parties.create { t in
                t.column(partyId)
                t.column(partyName)
                t.column(partyLocation)
                t.column(partyCategory)
                })
            
            
            let firstName = Expression<String?>("firstName")
            let lastName = Expression<String?>("lastName")
            
            try db.run(members.create { t in
                t.column(member_partyId)
                t.column(firstName)
                t.column(lastName)
                t.column(isDictator)
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
        self.partyLocation = Expression<String?>("location")
        self.partyCategory = Expression<String?>("category")
        
        self.member_partyId = Expression<Int>("party_id")
        self.isDictator = Expression<Bool?>("isDictator")

        
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
