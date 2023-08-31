//
//  CreateListController.swift
//  ActivAround
//
//  Created by Lucie on 30/08/2023.
//

import Foundation
import UIKit
import MapKit

class CreateListController: UIViewController{
    
    var cityName: String?
       var location: Location?
       var radius: Int?
       var places: [PlaceCategory: [Place]] = [:] // Un dictionnaire pour stocker les lieux par catégorie.
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           searchNearbyPlaces()
       }
       
    func searchNearbyPlaces() {
        guard let location = self.location else { return }
        
        for category in PlaceCategory.allCases {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = category.rawValue
            request.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), latitudinalMeters: Double(radius ?? 1000), longitudinalMeters: Double(radius ?? 1000))
            
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard let response = response else { return }
                
                var placesForCategory: [Place] = []
                
                // Limite les résultats à 15 par catégorie
                let items = response.mapItems.prefix(15)
                
                for item in items {
                    let place = Place(name: item.name, phoneNumber: item.phoneNumber, isCurrentLocation: item.isCurrentLocation, pointOfInterestCategory: item.pointOfInterestCategory, url: item.url)
                    placesForCategory.append(place)
                    
                    // Affichage des informations pour le debug
                    print("-------- \(category.rawValue.uppercased()) --------")
                    print("Nom : \(item.name ?? "Inconnu")")
                    print("Téléphone : \(item.phoneNumber ?? "Inconnu")")
                    print("Est-ce le lieu actuel ? \(item.isCurrentLocation)")
                    print("Catégorie : \(item.pointOfInterestCategory?.rawValue ?? "Inconnu")")
                    print("URL : \(String(describing: item.url))")
                    print("----------------------------------")
                }
                
                self.places[category] = placesForCategory
                
                // Vous pouvez ici mettre à jour la vue (par exemple, une tableView) pour afficher les lieux récupérés pour cette catégorie.
            }
        }
    }


}
