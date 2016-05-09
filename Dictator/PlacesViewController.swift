//
//  PlacesViewController.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/8/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//

import UIKit

extension PlacesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.placesTableView.dequeueReusableCellWithIdentifier("PlaceViewCell", forIndexPath: indexPath) as! PlaceViewCell
        
        cell.placeNameLabel.text = places[indexPath.item].placeName
        cell.addressLabel.text = places[indexPath.item].address
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedPlace = self.places[indexPath.row]
        self.delegate?.placeDidSelected(self.selectedPlace)
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
}

class PlacesViewController: UIViewController {
    
    var selectedPlace: PlaceModel!
    private var initalized = false
    
    var places : [PlaceModel]! = [] {
        didSet{
            placesTableView?.reloadData()
        }
    }
    
    @IBOutlet var placesTableView: UITableView!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    
    var delegate: PlaceSearchDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 42, right: 0) //adjust for height of searchbar
        placesTableView.rowHeight = UITableViewAutomaticDimension
        placesTableView.estimatedRowHeight = 150
        placesTableView.tableFooterView = UIView() //hide empty cells
        placesTableView.separatorColor = UIColor.blackColor()
    }
    
    @IBAction func onTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
}
