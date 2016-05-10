//
//  EditPartyViewController.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/8/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//

import UIKit
import SAParallaxViewControllerSwift
import Neon
import FontAwesome_swift

extension EditPartyViewController: VotersViewControllerDelegate {
    func currentDictatorDidChange(dictator: MemberModel?) {
        if let dictator = dictator {
            partyDictatorLbl?.text = " \(String.fontAwesomeIconWithName(.Legal)) \(dictator.firstName) \(dictator.lastName)"
        } else {
            partyDictatorLbl?.text = " \(String.fontAwesomeIconWithName(.Legal)) Select dictator"
        }
        
        partyDictatorLbl?.sizeToFit()
        //partyDictatorLbl.anchorAndFillEdge(.Bottom, xPad: 0, yPad: 0, otherSize: 30)
        self.view.layoutIfNeeded()
    }
}

extension EditPartyViewController: PlaceSearchDelegate {
    func placeDidSelected(place: PlaceModel) {
        pickPlaceBtn.setTitle("  \(String.fontAwesomeIconWithName(.LocationArrow)) \(place.placeName)", forState: .Normal)
        self.currentParty.location = place.placeName
    }
}

class EditPartyViewController: SADetailViewController {
    
    private var pickPlaceBtn: UIButton!
    private var middleView: UIStackView!
    private var partyDictatorLbl: UILabel!
    
    var currentParty: PartyModel!

    func pickPlaceBtnDidTap(btn: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let placesVC = mainStoryboard.instantiateViewControllerWithIdentifier("PlacesAutocompleteViewController") as! PlacesAutocompleteViewController
        
        placesVC.delegate = self
        
        if let lastLoc = LocationService.sharedInstance.lastLocation {
             placesVC.coordinate = lastLoc.coordinate
            
            presentViewController(placesVC, animated: true, completion: nil)
        }
    }
    
    func sendBtnDidTap(btn: UIButton) {
        var message: String, title = "Oops"
        
        if self .currentParty.location == nil {
            message = "please choose a location"
        } else if currentParty.dictator == nil {
            message = "please select a dictator"
        } else {
             message  = "\(self.currentParty.dictator!.firstName)'s ruling sent to \(self.currentParty.members.count) members"
           title = "\(self.currentParty.location!)"
        }
        
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        UIView.animateWithDuration(0.5, animations: {
            self.middleView?.alpha = 1
        })

    }

    override func viewWillDisappear(animated: Bool) {
        
        UIView.animateWithDuration(0.5, animations: {
            self.middleView.alpha = 0
            })

        EntitiesService.sharedInstance.saveParty(currentParty)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //party name labael
        let partyNameLbl = UILabel()
        partyNameLbl.textColor = UIColor.whiteColor()
        partyNameLbl.text = currentParty.name
        partyNameLbl.font = UIFont.systemFontOfSize(24)
        partyNameLbl.sizeToFit()
        self.headerView?.addSubview(partyNameLbl)
        partyNameLbl.anchorInCenter(width: partyNameLbl.width, height: partyNameLbl.height)
        
        //place picker button
        pickPlaceBtn = UIButton()
        pickPlaceBtn.frame = CGRectMake(0, self.headerView!.height, self.view.width, 30)
        pickPlaceBtn.contentHorizontalAlignment = .Left
        pickPlaceBtn.addTarget(self, action: #selector(pickPlaceBtnDidTap), forControlEvents: .TouchUpInside)
        pickPlaceBtn.titleLabel?.font = UIFont.fontAwesomeOfSize(18)
        
        if let loc = self.currentParty.location where loc != "" {
            pickPlaceBtn.setTitle("  \(String.fontAwesomeIconWithName(.LocationArrow)) \(loc)", forState: .Normal)
        } else {
            pickPlaceBtn.setTitle("  \(String.fontAwesomeIconWithName(.LocationArrow)) Select a place", forState: .Normal)
        }
        
        pickPlaceBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        pickPlaceBtn.backgroundColor = self.view.tintColor
        pickPlaceBtn.alpha = 0.8
        
        self.view.addSubview(pickPlaceBtn)
        
        
        //create middle view
        middleView = UIStackView()
        middleView.axis = .Vertical
        middleView.spacing = 0
        self.view.addSubview(middleView)
        middleView.align(.UnderCentered, relativeTo: self.imageView, padding: 0, width: self.view.width, height: self.view.height - self.imageView.height)
        
        
        //dictator label
        partyDictatorLbl = UILabel()
        partyDictatorLbl.textColor = UIColor.whiteColor()
        partyDictatorLbl.font = UIFont.fontAwesomeOfSize(20)
        partyDictatorLbl.text = "  \(String.fontAwesomeIconWithName(.Legal)) Select dictator"
        partyDictatorLbl.backgroundColor = self.headerView?.backgroundColor
        
        if let dictator = currentParty.dictator {
            partyDictatorLbl?.text = " \(String.fontAwesomeIconWithName(.Legal)) \(dictator.firstName) \(dictator.lastName)"
        }
        partyDictatorLbl.sizeToFit()
        partyDictatorLbl.alpha = 0.6
        
        self.imageView.addSubview(partyDictatorLbl)
        partyDictatorLbl.anchorAndFillEdge(.Bottom, xPad: 0, yPad: 0, otherSize: 30)

        
        
        //members table
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let votersVC = mainStoryboard.instantiateViewControllerWithIdentifier("VotersViewController") as! VotersViewController
        votersVC.delegate = self
        votersVC.currentParty = currentParty
        self.addChildViewController(votersVC)
        middleView.addArrangedSubview(votersVC.view)
        
        
        //send button 
        let sendMessageBtn = UIButton()
        sendMessageBtn.backgroundColor = UIColor.blackColor()
        sendMessageBtn.contentHorizontalAlignment = .Center
        sendMessageBtn.addTarget(self, action: #selector(sendBtnDidTap), forControlEvents: .TouchUpInside)
        sendMessageBtn.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
        sendMessageBtn.setTitle("Send", forState: .Normal)
        
        sendMessageBtn.setTitleColor(UIColor.greenColor(), forState: .Normal)
        
        
        sendMessageBtn.heightAnchor.constraintEqualToConstant(50).active = true

        middleView.addArrangedSubview(sendMessageBtn)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
