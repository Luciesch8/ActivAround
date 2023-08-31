//
//  ActivityLocationController.swift
//  ActivAround
//
//  Created by Lucie on 30/08/2023.
//

import UIKit
import CoreLocation

class ActivityLocationController: UIViewController{
    
    // MARK: - Outlets
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var distanceSlider: UISlider!
    @IBOutlet var activateCurrentPositionButton: UIButton! // Bouton pour activer la localisation.
    @IBOutlet var distanceRadiusLabel: UILabel!
    @IBOutlet var cityLabel: UILabel! // Label pour afficher la localisation.

    

    //MARK: Variable
    let locationService = LocationService() // Instance du service de localisation.

    // MARK: - Cycle de Vie
    override func viewDidLoad(){
        super.viewDidLoad()
        setupLocationService()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail", let destinationVC = segue.destination as? CreateListController {
            destinationVC.cityName = cityLabel.text
            destinationVC.location = locationService.currentLocation // Supposons que vous ayez une propriété currentLocation dans locationService.
            destinationVC.radius = Int(distanceSlider.value)
        }
    }
    
    // MARK: - Actions
    @IBAction func activateCurrentPositionButtonTapped(_ sender: Any) {
        locationService.requestLocation()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let sliderValue = Int(sender.value) // Convertit la valeur en entier pour un affichage plus propre.
        distanceRadiusLabel.text = "\(sliderValue) km"
    }
    
    // MARK: - Configuration
    func setupLocationService() {
            locationService.onLocationUpdate = { [weak self] location in
                self?.getCityName(from: location)
            }
        }
        
    
    func getCityName(from location: Location) {
        let geocoder = CLGeocoder()
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geocoder.reverseGeocodeLocation(clLocation) { [weak self] (placemarks, error) in
            if let error = error {
                print("Erreur de géocodage inversé : \(error)")
                return
            }
            
            if let placemark = placemarks?.first, let city = placemark.locality {
                self?.cityLabel.text = city
            } else {
                self?.cityLabel.text = "Ville inconnue"
            }
        }
    }
    
}
