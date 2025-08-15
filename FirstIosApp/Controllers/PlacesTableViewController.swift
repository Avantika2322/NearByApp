//
//  Untitled.swift
//  FirstIosApp
//
//  Created by Avantika on 16/03/25.
//

import Foundation
import UIKit
import MapKit

class PlacesTableViewController: UITableViewController{
    var userLocation: CLLocation
    var places: [PlacesAnnotation]
    
    init(userLocation: CLLocation, places: [PlacesAnnotation]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlacesCell")
        self.places.swapAt(selectedPlaceIndex ?? 0, 0)
    }
    
    private var selectedPlaceIndex: Int? {
        self.places.firstIndex(where: {$0.isSelected == true})
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesCell", for: indexPath)
        let place = places[indexPath.row]
        
        // cell configuration
        var content = cell.defaultContentConfiguration()
        content.text = place.name
        content.secondaryText = formatDistanceInMiles(calculateDistance(source: userLocation, destination: place.location))
        cell.backgroundColor = place.isSelected ? UIColor.systemBlue : UIColor.clear
        cell.contentConfiguration = content
        return cell
    }
    
    private func calculateDistance(source: CLLocation, destination: CLLocation) -> CLLocationDistance{
        source.distance(from: destination)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlace = places[indexPath.row]
        let placeDetailVC = PlacesDetailViewController(place: selectedPlace)
        present(placeDetailVC, animated: true)
    }
    
    private func formatDistanceInMiles(_ distance: CLLocationDistance)-> String{
        let meters = Measurement(value: distance, unit: UnitLength.meters)
        return meters.converted(to: .miles).formatted()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

