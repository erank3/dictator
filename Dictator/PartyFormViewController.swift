//
//  PartyFormViewController.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/5/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//

import UIKit
import Former


class PartyFormViewController: FormViewController {
    
    var currentParty = PartyModel()
    
    private func initForm() {
        let nameRow = TextFieldRowFormer<FormTextFieldCell>().configure{ row in
            row.placeholder = "Party Name"
            }.onTextChanged({ text in
                self.currentParty.name = text
            })
        
        let editMembersRow = LabelRowFormer<FormLabelCell>()
            .configure { row in
                row.text = "Members"
                row.subText = self.currentParty.members.count.description
            }.onSelected { row in
                self.performSegueWithIdentifier("showMembers", sender: self)
        }
        
        let header = LabelViewFormer<FormLabelHeaderView>() { view in
            view.titleLabel.text = "Create Your Party"
        }
        
        let section = SectionFormer(rowFormer: nameRow).append(rowFormer: editMembersRow)
            .set(headerViewFormer: header)
        former.append(sectionFormer: section)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showMembers") {
            
            if let membersVC = segue.destinationViewController as? MembersTableViewController {
                
                membersVC.parentVC = self
            }
            
        }
    }
    
    func closeBtnDidTap(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveBtnDidTap(sender: UIButton) {
        EntitiesService.sharedInstance.saveParty(currentParty)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        print(self.currentParty.members.count)
        former.reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeBtn = UIButton(frame: CGRectMake(0,0,20,30))
        closeBtn.addTarget(self, action: #selector(closeBtnDidTap), forControlEvents: .TouchUpInside)
        closeBtn.backgroundColor = UIColor.redColor()
        closeBtn.setTitle("Cancel", forState: .Normal)
        let closeNavBtn = UIBarButtonItem(customView: closeBtn)
        self.navigationItem.setLeftBarButtonItems([closeNavBtn, UIBarButtonItem(customView: UIView(frame: CGRectMake(0,0,20,30)))], animated: true)
        
        
        let saveBtn = UIButton(frame: CGRectMake(0,0,20,30))
        saveBtn.addTarget(self, action: #selector(saveBtnDidTap), forControlEvents: .TouchUpInside)
        saveBtn.backgroundColor = UIColor.greenColor()
        saveBtn.setTitle("Cancel", forState: .Normal)
        let saveNavBtn = UIBarButtonItem(customView: saveBtn)
        self.navigationItem.setRightBarButtonItems([saveNavBtn, UIBarButtonItem(customView: UIView(frame: CGRectMake(0,0,20,30)))], animated: true)
        
        initForm()

        return
        let labelRow = LabelRowFormer<FormLabelCell>()
            .configure { row in
                row.text = "Label Cell"
            }.onSelected { row in
                // Do Something
        }
        let inlinePickerRow = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
            $0.titleLabel.text = "Inline Picker Cell"
            }.configure { row in
                row.pickerItems = (1...5).map {
                    InlinePickerItem(title: "Option\($0)", value: Int($0))
                }
            }.onValueChanged { item in
                // Do Something
        }
    }

    override func didReceiveMemoryWarning() {
    }

}
