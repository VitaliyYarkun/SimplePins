//
//  MapViewController.swift
//  vitaliy_yarkun_SimplePins
//
//  Created by Vitaliy Yarkun on 9/13/17.
//  Copyright © 2017 Vitaliy Yarkun. All rights reserved.
//

import UIKit
import CoreData
import MapKit

final class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Properties
    fileprivate lazy var managedContext:NSManagedObjectContext = {
        return DatabaseController.getContext()
    }()
    var currentUser: User?
    var token: String?
    var userID: String!
    
    let locationManager = CLLocationManager()
    var startDragLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUIElements()
        loadUser()
        loadUserPins()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_ :)))
        tapGesture.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(tapGesture)
        
        mapView.showsUserLocation = true
        checkLocationAuthorizationStatus()
    }
    
    //MARK: - Methods
    func loadUIElements() {
        let rightButtonItem = UIBarButtonItem.init(
            title: "Log out",
            style: .done,
            target: self,
            action: #selector(logOutAction(sender:))
        )
        
        let leftButtonItem = UIBarButtonItem.init(
            title: "Back",
            style: .done,
            target: self,
            action: #selector(backAction(sender:))
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
        self.navigationItem.leftBarButtonItem = leftButtonItem
    }
    
    func logOutAction(sender: UIBarButtonItem) {
        self.clearCookies()
        
        managedContext.delete(currentUser!)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Saving error: \(error), description: \(error.userInfo)")
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func backAction(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func tap(_ recognizer: UITapGestureRecognizer) {
        
        let point = recognizer.location(in: mapView)
        let coordinate: CLLocationCoordinate2D = mapView.convert(point, toCoordinateFrom: self.view)
        
        let pinEntity = NSEntityDescription.entity(forEntityName: "Pin", in: managedContext)
        let pin = Pin(entity: pinEntity!, insertInto: managedContext)
        pin.longitude = coordinate.longitude
        pin.latitude = coordinate.latitude
        currentUser?.addToPins(pin)
        do {
            try managedContext.save()
            loadUserPins()
        } catch let error as NSError {
            print("Save error: \(error), description: \(error.userInfo)")
        }
    }

    //MARK: - CoreData methods
    func loadUser() {
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)
        
        let userFetch: NSFetchRequest<User> = User.fetchRequest()
        userFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(User.userID), userID)
        
        do {
            let results = try managedContext.fetch(userFetch)
            if results.count > 0 {
                currentUser = results.first
            } else {
                let user = User(entity: userEntity!, insertInto: managedContext)
                user.userID = userID
                user.accessToken = token
                currentUser = user
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func loadUserPins() {
        
        guard let pins = currentUser?.pins else { return }
        mapView.removeAnnotations(mapView.annotations)
        for pin in pins {
            if let lPin = pin as? Pin {
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lPin.latitude, longitude: lPin.longitude)
                let annotation: MKPointAnnotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "Deletion"
                annotation.subtitle = "Tap the button on the right to delete the pin"
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    func getPinFrom(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> Pin? {
        let predicate = NSPredicate(format: "%K == %lf && %K == %lf", #keyPath(Pin.latitude), (latitude), #keyPath(Pin.longitude), (longitude))
        let results = currentUser?.pins?.filtered(using: predicate)
        return results?.first as? Pin
    }
    
    }

//MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            
            if let pin = getPinFrom(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!) {
                
                managedContext.delete(pin)
                do {
                    try managedContext.save()
                    loadUserPins()
                } catch let error as NSError {
                    print("Saving error: \(error), description: \(error.userInfo)")
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.isDraggable = true
            pinView?.canShowCallout = true
            let button = UIButton(type: .infoLight)
            
            pinView?.rightCalloutAccessoryView = button
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        if oldState == .starting {
            startDragLocation.latitude = (view.annotation?.coordinate.latitude)!
            startDragLocation.longitude =  (view.annotation?.coordinate.longitude)!
        }
        if newState == .ending {
            _ = view.annotation?.coordinate
            if let pin = getPinFrom(latitude: startDragLocation.latitude, longitude: startDragLocation.longitude) {
                
                pin.latitude = (view.annotation?.coordinate.latitude)!
                pin.longitude = (view.annotation?.coordinate.longitude)!
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Saving error: \(error), description: \(error.userInfo)")
                }
            }
        }
    }
}
