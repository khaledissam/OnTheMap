//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Minjie Zhu on 8/27/16.
//  Copyright © 2016 Minjie Zhu. All rights reserved.
//

import UIKit
import MapKit

// MARK: - MapViewController: UIViewController
class MapViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var mapView : MKMapView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        mapView.delegate = self
    }

    // MARK: Helper
    func updateAnnotation() {
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for info in UdacityClient.sharedInstance().studentInfo {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(info.latitude)
            let long = CLLocationDegrees(info.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = info.firstName
            let last = info.lastName
            let mediaURL = info.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)

        mapView.reloadInputViews()
    }

}

// MARK: - MapViewController: MKMapViewDelegate
extension MapViewController : MKMapViewDelegate {
    
    // MARK: MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = MKPinAnnotationView.redPinColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == view.rightCalloutAccessoryView {

            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {

                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
}