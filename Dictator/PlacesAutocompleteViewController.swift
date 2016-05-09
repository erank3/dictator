//
//  PlacesAutocompleteViewController.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/8/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//

import UIKit

protocol PlaceSearchDelegate {
    func placeDidSelected(place: PlaceModel)
}


extension PlacesAutocompleteViewController : UISearchBarDelegate {
    
    func retrievePlaces(query: String?) {
        LocationService.sharedInstance.placeAutocomplete(query, coordinate: coordinate).then{ places in
            self.updatePlaces(places)
            }.error { err in
                //DialogService.instance.showException(err, parent: self.parent)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        retrievePlaces(placeSearchBar.text!)
    }
    
    func updatePlaces(places: [PlaceModel]) {
        self.placesVC.places = places
        self.placesSpinner.stopAnimating()
    }
    
    func doSearch(sender:AnyObject) {
        retrievePlaces(placeSearchBar.text!)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.placesSpinner.startAnimating()
        self.timer?.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "doSearch:", userInfo: nil, repeats: false)
    }
    
}

extension PlacesAutocompleteViewController: PlaceSearchDelegate {
    
    func placeDidSelected(place: PlaceModel) {
        self.selectedPlace = place
        self.delegate?.placeDidSelected(place)
    }
}

class PlacesAutocompleteViewController: UIViewController {
    
    @IBOutlet var placeSearchBar: UISearchBar!
    @IBOutlet weak var placesSpinner: UIActivityIndicatorView!
    weak internal var timer: NSTimer?
    
    var initalized: Bool = false
    
    var coordinate: CLLocationCoordinate2D!
    
    var selectedPlace: PlaceModel!
    
    var delegate: PlaceSearchDelegate!
    
    var placesVC: PlacesViewController!
    
    
    @IBOutlet var tableView: UIView!
    @IBOutlet var searchBarView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        placeSearchBar.delegate = self
        
        self.title = "Place Around"
        self.placesVC = storyboard?.instantiateViewControllerWithIdentifier("PlacesSearchTable") as! PlacesViewController
        placesVC.delegate = self
        placesVC.view.frame.size.width = tableView.frame.width
        
        self.retrievePlaces(selectedPlace?.placeName)
        placeSearchBar.text = selectedPlace?.placeName
        
        tableView.addSubview(placesVC.view)
        
        self.addChildViewController(placesVC)
        
    }
    
    @IBAction func onCloseTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
}
