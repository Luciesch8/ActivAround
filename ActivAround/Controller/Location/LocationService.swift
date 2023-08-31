//
//  LocationService.swift
//  ActivAround
//
//  Created by Lucie on 30/08/2023.
//

import Foundation
import CoreLocation

// Classe de service pour gérer la récupération de la localisation.
class LocationService: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var currentLocation: Location?
    var onLocationUpdate: ((Location) -> Void)?

    
    // Méthode pour demander la localisation.
    func requestLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let newLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            currentLocation = newLocation 
            onLocationUpdate?(newLocation)
            manager.stopUpdatingLocation()
        }
    }
}
