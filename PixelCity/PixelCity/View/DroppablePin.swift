//
//  DroppablePin.swift
//  PixelCity
//
//  Created by Trinh Thai on 10/30/19.
//  Copyright © 2019 Trinh Thai. All rights reserved.
//

import UIKit
import MapKit

class DroppablePin: NSObject, MKAnnotation {
     var coordinate: CLLocationCoordinate2D
    var indentifier: String
    
    init(coordinate: CLLocationCoordinate2D, indentifier: String) {
        self.coordinate = coordinate
        self.indentifier = indentifier
        super.init()
    }
}
