//
//  ViewController.swift
//  PixelCity
//
//  Created by Trinh Thai on 10/29/19.
//  Copyright © 2019 Trinh Thai. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var ibMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ibMapView.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func ibCenterMapBntPressed(_ sender: Any) {
    }
}

extension MapVC: MKMapViewDelegate {
    
}



