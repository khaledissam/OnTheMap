//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Minjie Zhu on 9/3/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBookUI

class InformationPostingViewController: KeyboardViewController {
    
    // MARK: Properties
    private var address : String = ""
    private var latitude : Double = 0.0
    private var longitude : Double = 0.0
    private let regionRadius: CLLocationDistance = 1000 //  meters
    
    // MARK: Outlets
    @IBOutlet weak var topTextFiled : UITextField!
    @IBOutlet weak var midTextFiled : UITextField!
    @IBOutlet weak var botButton : UIButton!
    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var botView : UIView!
    
    // MARK: Actions
    @IBAction func buttonPressed() {
        if botButton.currentTitle == "Find on the map" {
            findOnMap()
        } else {
            submit()
        }
        
    }
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(cancel))

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTextFields([topTextFiled,midTextFiled], viewOnKeyboard: nil, distToKeyBoard: 0)
        setUI()
        
    }
    
    
    // MARK: Helpers
    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func setUI() {
        topTextFiled.enabled = false
        topTextFiled.backgroundColor = UdacityClient.Colors.grey
        topTextFiled.textColor = UdacityClient.Colors.darkBlue
        
        mapView.hidden = true
        midTextFiled.hidden = false
        
        botView.backgroundColor = UdacityClient.Colors.grey
        
        botButton.setTitle("Find on the map", forState: .Normal)
    }
    
    private func updateUI() {
        topTextFiled.enabled = true
        topTextFiled.backgroundColor = UdacityClient.Colors.darkBlue
        topTextFiled.textColor = UdacityClient.Colors.grey
        topTextFiled.text = ""
        topTextFiled.placeholder = "Type in a link"
        
        mapView.hidden = false
        midTextFiled.enabled = false
        midTextFiled.alpha = 0
        
        botView.alpha = 0.8
        
        botButton.setTitle("Submit", forState: .Normal)
        
        setMapVisibleArea()
    }
    
    private func setMapVisibleArea() {
        
        if latitude == 0 || longitude == 0 {
            return
        }
        
        // set location and region
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
        // set pin
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.coordinate = coordinate
        annotation.title = address
        mapView.addAnnotation(annotation)
    }
    
    private func findOnMap() {
        address = midTextFiled.text!
        forwardGeocoding()
    }
    
    private func forwardGeocoding() {
        
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                GlobalHelperFunction.displayAlert(self, title: "WARNING", message: "No address is found", ok: "ok")
                return
            }
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print("\nlat: \(coordinate?.latitude), long: \(coordinate?.longitude)")
                if placemark?.areasOfInterest?.count > 0 {
                    let areaOfInterest = placemark!.areasOfInterest![0]
                    print(areaOfInterest)
                } else {
                    print("No area of interest found.")
                }
                
                if coordinate == nil {
                    GlobalHelperFunction.displayAlert(self, title: "No place is found", message: "", ok: "Ok")
                    return
                }
                
                self.latitude = coordinate!.latitude
                self.longitude = coordinate!.longitude
                self.updateUI()
            }
        })
    }
    
    private func submit() {
        
        if let url = topTextFiled.text {
            
            if url.isEmpty {
                GlobalHelperFunction.displayAlert(self, title: "No url is given", message: "", ok: "ok")
                return
            }
        
            UdacityClient.sharedInstance().addStudentInfo(address, mediaURL: url, latitude: latitude, longitude: longitude, completionHandler: { (errorString) in
                performUIUpdatesOnMain({ 
                    if errorString != nil {
                        print("submit")
                        GlobalHelperFunction.displayAlert(self, title: "\(errorString!)", message: "", ok: "ok")
                        return
                    } else {
                        self.cancel()
                    }
                })
            })
        } else {
            GlobalHelperFunction.displayAlert(self, title: "No url is given", message: "", ok: "ok")
        }
    }
    
}


