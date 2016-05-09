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
    }
}

class EditPartyViewController: SADetailViewController {

    var currentParty: PartyModel!
    
    private var pickPlaceBtn: UIButton!

    
    func pickPlaceBtnDidTap(btn: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let placesVC = mainStoryboard.instantiateViewControllerWithIdentifier("PlacesAutocompleteViewController") as! PlacesAutocompleteViewController
        
        placesVC.delegate = self
        
        if let lastLoc = LocationService.sharedInstance.lastLocation {
             placesVC.coordinate = lastLoc.coordinate
            
            presentViewController(placesVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerView?.backgroundColor = UIColor.redColor()

        let headerView = UIView()
        
        let partyNameLbl = UILabel()
        partyNameLbl.textColor = UIColor.redColor()

        partyNameLbl.text = currentParty.name
        partyNameLbl.font = UIFont.systemFontOfSize(24)
        partyNameLbl.sizeToFit()
        self.view.addSubview(partyNameLbl)
        partyNameLbl.align(.UnderCentered, relativeTo: self.imageView, padding: 0, width: partyNameLbl.width, height: 30)

        
        pickPlaceBtn = UIButton()
        pickPlaceBtn.frame = CGRectMake(0, 0, 200, 100)
        pickPlaceBtn.contentHorizontalAlignment = .Left
        pickPlaceBtn.setTitle("Pick a place", forState: .Normal)
        pickPlaceBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        pickPlaceBtn.titleLabel?.font = UIFont.systemFontOfSize(20)
        self.view.addSubview(pickPlaceBtn)
        pickPlaceBtn.addTarget(self, action: #selector(pickPlaceBtnDidTap), forControlEvents: .TouchUpInside)
        pickPlaceBtn.align(.UnderMatchingLeft, relativeTo: partyNameLbl, padding: 0, width: pickPlaceBtn.width, height: 30)

        //partyNameLbl.anchorAndFillEdge(.Top, xPad: self.imageView.height, yPad: self.imageView.height, otherSize: 50)

        
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let votersVC = mainStoryboard.instantiateViewControllerWithIdentifier("VotersViewController") as! VotersViewController
        
        votersVC.currentParty = currentParty
        self.addChildViewController(votersVC)
        self.view.addSubview(votersVC.view)
        //votersVC.view.anchorAndFillEdge(.Bottom, xPad: -15, yPad: 0, otherSize: 300)
        
        votersVC.view.align(.UnderCentered, relativeTo: pickPlaceBtn, padding: 0, width: self.view.width, height: 300)
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
