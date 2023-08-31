//
//  Place.swift
//  ActivAround
//
//  Created by Lucie on 31/08/2023.
//

import Foundation
import MapKit


enum PlaceCategory: String, CaseIterable {
    case restaurant
    case park
    case museum
}

struct Place {
    var name: String?
    var phoneNumber: String?
    var isCurrentLocation: Bool
    var pointOfInterestCategory: MKPointOfInterestCategory?
    var url: URL?
}
