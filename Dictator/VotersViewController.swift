//
//  VotersViewController.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/8/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//

import UIKit
protocol VotersViewControllerDelegate {
    func currentDictatorDidChange(dictator: MemberModel?)
}

class VotersViewController: UITableViewController {

    private var dictatorCell: UITableViewCell?
    
    var currentParty: PartyModel!
    var delegate: VotersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentParty.members.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let model = currentParty.members[indexPath.row]
            
            if (self.currentParty.dictator == model) {
                cell.accessoryView = nil
                self.currentParty.dictator = nil
            } else {
                self.currentParty.dictator = model
                self.dictatorCell?.accessoryView = nil
                
                let activeCellView = UIImageView(frame: CGRectMake(0,0,50,50))
                activeCellView.image = UIImage(named: "Law-100")
                cell.accessoryView = activeCellView
                
                self.dictatorCell = cell
            }
            
            self.delegate?.currentDictatorDidChange(self.currentParty.dictator)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let member = currentParty.members[indexPath.row]
    
        if let cell = tableView.dequeueReusableCellWithIdentifier("VoterViewCell", forIndexPath: indexPath) as? VoterViewCell {
            
            cell.selectionStyle = .None
            cell.nameLbl.text = "\(member.firstName) \(member.lastName)"
    
            if (self.currentParty.dictator == member) {
                self.currentParty.dictator = member
                self.dictatorCell?.accessoryView = nil
                
                let activeCellView = UIImageView(frame: CGRectMake(0,0,50,50))
                activeCellView.image = UIImage(named: "Law-100")
                cell.accessoryView = activeCellView
                
                self.dictatorCell = cell
            }
            
            return cell
        }
        
        return UITableViewCell()
    }

}
