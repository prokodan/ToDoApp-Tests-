//
//  Location.swift
//  ToDoApp(Tests)
//
//  Created by Данил Прокопенко on 11.11.2022.
//

import Foundation
import CoreLocation

struct Location {
    
    let name: String
    let coordinate: CLLocationCoordinate2D?
    
    init(name: String, coordinate: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinate = coordinate
    }
}

extension Location: Equatable {
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        guard lhs.coordinate?.latitude == rhs.coordinate?.latitude &&
                rhs.coordinate?.longitude == lhs.coordinate?.longitude &&
                lhs.name == rhs.name else {return false}
                
        return true
    }
    
}
