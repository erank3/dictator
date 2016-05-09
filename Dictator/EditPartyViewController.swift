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

extension EditPartyViewController: PlaceSearchDelegate {
    
    func placeDidSelected(place: PlaceModel) {
        pickPlaceBtn.setTitle(place.placeName, forState: .Normal)
        self.currentParty.location = place.placeName
    }
}

class EditPartyViewController: SADetailViewController {
    
    private var pickPlaceBtn: UIButton!
    private var middleView: UIStackView!
    
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
        
        let partyNameLbl = UILabel()
        partyNameLbl.textColor = UIColor.whiteColor()

        partyNameLbl.text = currentParty.name
        partyNameLbl.font = UIFont.systemFontOfSize(24)
        partyNameLbl.sizeToFit()
        self.headerView?.addSubview(partyNameLbl)
        partyNameLbl.anchorInCenter(width: partyNameLbl.width, height: partyNameLbl.height)
        
        middleView = UIStackView()
        middleView.axis = .Vertical
        self.view.addSubview(middleView)
        middleView.align(.UnderCentered, relativeTo: self.imageView, padding: 0, width: self.view.width, height: 1000)
        
        
        pickPlaceBtn = UIButton()
        pickPlaceBtn.frame = CGRectMake(0, 0, 200, 100)
        pickPlaceBtn.contentHorizontalAlignment = .Left
        pickPlaceBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        pickPlaceBtn.titleLabel?.font = UIFont.systemFontOfSize(20)
        pickPlaceBtn.addTarget(self, action: #selector(pickPlaceBtnDidTap), forControlEvents: .TouchUpInside)
        
        if let loc = self.currentParty.location where loc != "" {
            pickPlaceBtn.setTitle(loc, forState: .Normal)
        } else {
            pickPlaceBtn.setTitle("Pick a place", forState: .Normal)
        }
        
        
        middleView.addArrangedSubview(pickPlaceBtn)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let votersVC = mainStoryboard.instantiateViewControllerWithIdentifier("VotersViewController") as! VotersViewController
        
        votersVC.currentParty = currentParty
        self.addChildViewController(votersVC)
        middleView.addArrangedSubview(votersVC.view)
        //votersVC.view.anchorAndFillEdge(.Bottom, xPad: -15, yPad: 0, otherSize: 300)
        
       // votersVC.view.align(.UnderCentered, relativeTo: pickPlaceBtn, padding: 0, width: self.view.width, height: 300)
        
        
        

        return;
        partyNameLbl.align(.UnderCentered, relativeTo: self.imageView, padding: 0, width: partyNameLbl.width, height: 30)

        
       
     
        pickPlaceBtn.align(.UnderMatchingLeft, relativeTo: partyNameLbl, padding: 0, width: pickPlaceBtn.width, height: 30)

        //partyNameLbl.anchorAndFillEdge(.Top, xPad: self.imageView.height, yPad: self.imageView.height, otherSize: 50)
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
