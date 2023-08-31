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
    case cafe
    case hotel
    case theater
    case zoo
    case amusementPark
    case aquarium
}

struct Place {
    var name: String?
    var phoneNumber: String?
    var isCurrentLocation: Bool
    var pointOfInterestCategory: MKPointOfInterestCategory?
    var url: URL?
}

struct Category {
    let name: String
    var items: [Place]
}

struct PlaceList {
    var name: String
    var city: String
    var radius: Int
    var places: [Place]
    var date: Date? // Optionnel si vous voulez que ce soit facultatif
}
