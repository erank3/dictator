//
//  LocationServices.swift
//  Dictator
//
//  Created by Eran Kaufman on 5/8/16.
//  Copyright © 2016 Eran Kaufman. All rights reserved.
//
import UIKit
import PromiseKit
import INTULocationManager


class LocationService: NSObject {
    
    
    class var sharedInstance: LocationService {
        struct Static {
            static var instance: LocationService?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = LocationService()
        }
        
        return Static.instance!
    }
    private var placesClient = GMSPlacesClient.sharedClient()
    
    private var placePicker: GMSPlacePicker!
    
    let locMgr = INTULocationManager.sharedInstance()
    private(set) var lastLocation: CLLocation?
    
    private func initMap(lat:CLLocationDegrees, lng: CLLocationDegrees) -> GMSMapView{
        let detailsViewFrame: CGRect = UIScreen.mainScreen().bounds
        
        let camera = GMSCameraPosition.cameraWithLatitude(lat,
                                                          longitude: lng, zoom: 15)
        
        let mapView = GMSMapView.mapWithFrame(detailsViewFrame, camera: camera)
        
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        
        mapView.indoorEnabled = false
        
        mapView.myLocationEnabled = true
        
        return mapView
    }
    
    func loadPhotosForPlace(placeID: String, size: CGSize = CGSizeMake(100, 100) ) -> Promise<[UIImage]> {
        
        return Promise{fulfill, reject in
            placesClient.lookUpPhotosForPlaceID(placeID) { (photos, error) -> Void in
                if let error = error {
                    // TODO: handle the error.
                    print("Error: \(error.description)")
                } else {
                    if let results = photos?.results {
                        var retVal: [UIImage] = []
                        var count = 0
                        for result in results {
                            self.placesClient.loadPlacePhoto(result, constrainedToSize: size,
                            scale: 5) { (photo, error) -> Void in
                                count++
                                
                                if let error = error {
                                    // TODO: handle the error.
                                    print("Error: \(error.description)")
                                } else {
                                    if let photo = photo {
                                        retVal.append(photo)
                                    }
                                }
                                
                                if(count == results.count) {
                                    fulfill(retVal)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        
    }
    
    func getPlaceInfo(googlePlaceId: String) -> Promise<GooglePlaceModel> {
        
        return Promise{fulfill, reject in
            
            placesClient.lookUpPlaceID(googlePlaceId, callback: { (place: GMSPlace?, error: NSError?) -> Void in
                
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    //reject(NSError)
                    return
                }
                
                if let place = place {
                    var address = ""
                    
                    if let fa = place.formattedAddress {
                        
                        let reversed = fa.characters.reverse()
                        for (idx,char) in reversed.enumerate() {
                            if char == "," {
                                address = (fa as NSString).substringToIndex(fa.characters.count - idx - 1)
                                break
                            }
                        }
                    }
                    
                    
                    let placeModel = GooglePlaceModel(name: place.name, googleId: place.placeID, address: address)
                    
                    if let phoneNumber = place.phoneNumber {
                        placeModel.phoneNumber = phoneNumber
                    }
                    
                    if let website = place.website?.absoluteString {
                        placeModel.website = website
                    }
                    
                    placeModel.latitude = place.coordinate.latitude
                    placeModel.longitude = place.coordinate.longitude
                    
                    if (place.openNowStatus != GMSPlacesOpenNowStatus.Unknown) {
                        placeModel.openNow = place.openNowStatus == GMSPlacesOpenNowStatus.Yes
                    }
                    
                    placeModel.priceLevel = place.priceLevel.rawValue
                    
                    placeModel.rating = place.rating
                    
                    fulfill(placeModel)
                } else {
                    //reject(ServerError())
                }
            })
            
        }
        
    }
    
    func placeAutocomplete(query: String?,coordinate: CLLocationCoordinate2D) -> Promise<[PlaceModel]> {
        
        return Promise{fulfill, report in
            
            let filter = GMSAutocompleteFilter()
            filter.type = GMSPlacesAutocompleteTypeFilter.Establishment
            
            let map = initMap(coordinate.latitude, lng: coordinate.longitude)
            let visibleRegion = map.projection.visibleRegion()
            let bounds = GMSCoordinateBounds(region: visibleRegion)
            
            if(query == nil || query!.isEmpty) {
                
                self.placesClient.currentPlaceWithCallback({ (placeLikelihoods: GMSPlaceLikelihoodList?, error) -> Void in
                    if error != nil {
                        //return report(LocationError())
                    }
                    var retVal: [PlaceModel] = []
                    if let placeLikelihoods = placeLikelihoods?.likelihoods {
                        for likelihood in placeLikelihoods {
                            if let likelihood = likelihood as? GMSPlaceLikelihood {
                                let place = likelihood.place
                                let p = PlaceModel(name: place.name, googleId: place.placeID, address: place.formattedAddress!)
                                retVal.append(p)
                            }
                        }
                    }
                    
                    fulfill(retVal)
                })
                
                return
            }
            
            self.placesClient.autocompleteQuery(query!, bounds: bounds, filter: filter, callback: { (results, error: NSError?) -> Void in
                if let error = error {
                    return report(error)
                }
                
                var retVal: [PlaceModel] = []
                
                for result in results! {
                    if let result = result as? GMSAutocompletePrediction {
                        var placeArray = result.attributedFullText.string.componentsSeparatedByString(",")
                        let name = placeArray.removeFirst() //remove and extract the name
                        let address = placeArray.joinWithSeparator(",")
                        let p = PlaceModel(name: name, googleId: result.placeID!, address: address)
                        retVal.append(p)
                    }
                }
                
                fulfill(retVal)
            })
        }
    }
    
    
    override init(){
        super.init()
        
        locMgr.subscribeToLocationUpdatesWithBlock({loc in
            self.lastLocation = loc.0
        })
    }
    
}