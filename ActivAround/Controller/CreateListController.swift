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
    
    @IBOutlet weak var tableView: UITableView!

    var cityName: String?
       var location: Location?
       var radius: Int?
       var places: [PlaceCategory: [Place]] = [:] // Un dictionnaire pour stocker les lieux par catégorie.
        var categories: [Category] = []

       override func viewDidLoad() {
           super.viewDidLoad()
           
           // Initialisation du tableau categories
           categories = PlaceCategory.allCases.map { Category(name: $0.rawValue, items: []) }

             // Appel de la méthode pour chercher les lieux
             searchNearbyPlaces()
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailSegue",
           let destinationVC = segue.destination as? DetailViewController,
           let selectedPlace = sender as? Place {
            
            destinationVC.selectedPlace = selectedPlace
        }
    }

       
    func searchNearbyPlaces() {

        guard let location = self.location else { return }
        
        for category in PlaceCategory.allCases {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = category.rawValue
            request.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), latitudinalMeters: Double(radius ?? 1000), longitudinalMeters: Double(radius ?? 1000))
            
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                if let error = error {
                    return
                }
                guard let response = response else { return }
                
                
                
                var placesForCategory: [Place] = []
                
                // Limite les résultats à 15 par catégorie
                let items = response.mapItems.prefix(15)
                
                for item in items {
                    let place = Place(name: item.name, phoneNumber: item.phoneNumber, isCurrentLocation: item.isCurrentLocation, pointOfInterestCategory: item.pointOfInterestCategory, url: item.url)
                    placesForCategory.append(place)
                                       
                }
                
                self.places[category] = placesForCategory
                                
                if let index = self.categories.firstIndex(where: { $0.name == category.rawValue }) {
                    self.categories[index].items = placesForCategory
                }
                                

                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }


    
}


protocol CategoryTableViewCellDelegate: AnyObject {
    func didSelectItem(at indexPath: IndexPath)
}

extension CreateListController: CategoryTableViewCellDelegate {
    func didSelectItem(at indexPath: IndexPath) {

        let selectedCategory = categories[indexPath.section]
        let selectedPlace = selectedCategory.items[indexPath.item]

        if indexPath.item < selectedCategory.items.count {
            let selectedPlace = selectedCategory.items[indexPath.item]
            // Faites ce que vous devez faire avec selectedPlace
        } else {
            print("Erreur: Place non trouvé à l'index \(indexPath.item)")
            return
        }
            
            // Création et présentation du DetailViewController programmatiquement
            if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewControllerID") as? DetailViewController {
                detailVC.selectedPlace = selectedPlace
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
}

extension CreateListController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {

        return categories.count
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Puisque chaque section contient une seule cellule de type UICollectionView.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell

        cell.category = categories[indexPath.section]
        cell.delegate = self
        cell.collectionView.tag = indexPath.section
        cell.collectionView.reloadData()

        return cell
    }


    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].name
    }
}


class CategoryTableViewCell: UITableViewCell {
    
    var itemSelected: ((Place) -> Void)?
    weak var delegate: CategoryTableViewCellDelegate?

    @IBOutlet var collectionView: UICollectionView!

    var category: Category? {
        didSet {
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


extension CategoryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(category?.items.count ?? 0, 15)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as! PlaceCollectionViewCell
        cell.layer.cornerRadius = 40
        cell.layer.masksToBounds = true

        if let place = category?.items[indexPath.item] {
            cell.placeNameLabel.text = place.name
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Élément sélectionné à l'index \(indexPath.item) pour la section \(collectionView.tag)")
        delegate?.didSelectItem(at: IndexPath(row: indexPath.item, section: collectionView.tag))
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        print("Préparation pour performSegue pour l'index \(indexPath.item) et la section \(indexPath.section)")

    }


}

class PlaceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var placeNameLabel: UILabel!
}
