//
//  ViewController.swift
//  PixelCity
//
//  Created by Trinh Thai on 10/29/19.
//  Copyright © 2019 Trinh Thai. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {

    @IBOutlet weak var ibpullUpViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var ibMapView: MKMapView!
    @IBOutlet weak var ibPullUpView: UIView!
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    
    var spinner: UIActivityIndicatorView?
    var progressLbl: UILabel?
    var screenSize = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ibMapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()
        addDoubleTap()
    }
    
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(_:)))
        doubleTap.numberOfTapsRequired = 2
        ibMapView.addGestureRecognizer(doubleTap)
    }
    
    func addSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
        swipe.direction = .down
        ibPullUpView.addGestureRecognizer(swipe)
    }
    
    func animateViewUp() {
        ibpullUpViewHeightConstant.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func animateViewDown() {
        ibpullUpViewHeightConstant.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dropPin(_ recognizer: UITapGestureRecognizer) {
        removePin()
        animateViewUp()
        addSwipe()
        addSpinner()
        
        let touchPoint = recognizer.location(in: ibMapView)
        print(touchPoint)
        let touchCoordinate = ibMapView.convert(touchPoint, toCoordinateFrom: ibMapView)
        
        print(touchCoordinate)
        
        //add chấm đỏ
        let annotation = DroppablePin(coordinate: touchCoordinate, indentifier: "droppalePin")
        ibMapView.addAnnotation(annotation)
//
        //set lại center là ngay chấm đỏ đó
        let region = MKCoordinateRegion(center: touchCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        ibMapView.setRegion(region, animated: true)
        
    }
    
    func addSpinner() {
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: screenSize.width / 2 - (spinner?.frame.width)! / 2, y: 150)
        spinner?.style = .whiteLarge
        spinner?.color = .lightGray
        spinner?.startAnimating()
        ibPullUpView.addSubview(spinner!)
    }

    @IBAction func ibCenterMapBntPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
    
    func removePin() {
        for annotation in ibMapView.annotations {
            ibMapView.removeAnnotation(annotation)
        }
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //kt annotation co ngay toa do cua user k
        if annotation is MKUserLocation {
            return nil
        }
        //pin thi co them animatesDrop
        let annotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        annotation.pinTintColor = .orange
        annotation.animatesDrop = true
        return annotation
    }
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        ibMapView.setRegion(region, animated: true)
    }
}

extension MapVC: CLLocationManagerDelegate {
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else { //denied or approve
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
}

extension MapVC {
    func example() {
        // Xac dinh vi tri
        let location = CLLocationCoordinate2D(latitude: 51.50007773,
                                              longitude: -0.1246402)
        
        // Xac dinh vung hien thi voi khoang cach(span cang nho zoom cang lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        ibMapView.setRegion(region, animated: true)
        
        // Hien thi chu thich
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Big Ben"
        annotation.subtitle = "London"
        ibMapView.addAnnotation(annotation)
    }
}
