//
//  MembersTableViewController.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/6/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//

import UIKit
import Dollar

class MembersTableViewController: UITableViewController {
    
    private var members: [MemberModel] = []
    
    var parentVC: PartyFormViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contacts = ContactsService.sharedInstance.getContacts()
        
        
        for c in contacts {
            members.append(MemberModel(firstName: c.givenName, lastName: c.familyName))
        }
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let model = members[indexPath.row]
            
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                
                if let parentMembers = self.parentVC?.currentParty.members {
                    self.parentVC!.currentParty.members = parentMembers.filter {
                        $0.firstName != model.firstName && $0.lastName != model.lastName
                    }
                }
            } else {
                cell.accessoryType = .Checkmark
                self.parentVC?.currentParty.members.append(model)
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let member = self.members[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemberViewCell" ,forIndexPath: indexPath) as! MemberViewCell
        
        if let partyMembers = parentVC?.currentParty.members {
            if let _ = $.find(partyMembers, callback: {
                $0.firstName == member.firstName && $0.lastName == member.lastName
            }) {
                cell.accessoryType = .Checkmark
            }
        }
        
        
        
        cell.selectionStyle = .None
        cell.memberNameLbl.text = "\(member.firstName)  \(member.lastName)"
        
        return cell
    }
}
