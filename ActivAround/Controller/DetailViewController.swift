//
//  DetailViewController.swift
//  ActivAround
//
//  Created by Lucie on 31/08/2023.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var urlLabel: UILabel!
    
    var selectedPlace: Place? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        guard isViewLoaded else { return }
        nameLabel.text = selectedPlace?.name
        urlLabel.text = selectedPlace?.url?.absoluteString
        phoneNumberLabel.text = selectedPlace?.phoneNumber
    }
    
}
