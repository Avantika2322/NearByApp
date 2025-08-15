//
//  ViewController.swift
//  FirstIosApp
//
//  Created by Avantika on 08/03/25.
//
import Foundation
import UIKit
import MapKit

class ViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    var placesList: [PlacesAnnotation] = []
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchText: UITextField = {
        let searchView = UITextField()
        searchView.delegate = self
        searchView.layer.cornerRadius = 10
        searchView.placeholder = "Search"
        searchView.clipsToBounds = true
        searchView.backgroundColor = UIColor.white
        searchView.leftView = UIView(frame: CGRect(x:0 , y:0, width: 10, height: 0))
        searchView.leftViewMode = .always
        searchView.translatesAutoresizingMaskIntoConstraints = false
        return searchView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initailize location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        setView()
    }
    
    private func setView(){
        
        view.addSubview(mapView)
        view.addSubview(searchText)
        //view.bringSubviewToFront(searchText)
        
        // set constraints for searchview
        searchText.heightAnchor.constraint(equalToConstant: 44).isActive = true
        searchText.widthAnchor.constraint(equalToConstant: view.bounds.size.width/1.2).isActive = true
        searchText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchText.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        searchText.returnKeyType = .go
        
        
        // set constraints for mapview
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager,
              let location = locationManager.location else {return}
        
        switch locationManager.authorizationStatus{
        case .authorizedWhenInUse, .authorizedAlways:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
            mapView.setRegion(region, animated: true)
        case .denied:
            print("")
        case .notDetermined, .restricted:
            print("")
        @unknown default:
            print("")
        }
    }
    
    private func findNearByPlaces(by query: String){
        let annotationsToRemove = self.mapView.annotations
        self.mapView.removeAnnotations(annotationsToRemove)
       // mapView.removeAnnotation(mapView.annotations)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start{ [weak self] response, error in
            guard let response = response, error == nil else {return}
            self?.placesList = response.mapItems.map(PlacesAnnotation.init)
            self?.placesList.forEach{place in
                self?.mapView.addAnnotation(place)
            }
            print(response.mapItems)
            self?.placesListView(places: self?.placesList ?? [])
        }
    }
    
    private func placesListView(places: [PlacesAnnotation]){
        guard let locationManager = locationManager,
              let userLocation = locationManager.location else {return}
        
        let placesListController = PlacesTableViewController(userLocation: userLocation, places: places)
        placesListController.modalPresentationStyle = .pageSheet
        
        if let sheet = placesListController.sheetPresentationController{
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(placesListController, animated: true)
        }
    }
}

extension ViewController: MKMapViewDelegate{
    
    // clear all selected places
    func clearAllSelectedPlaces(){
        self.placesList = self.placesList.map{place in
            place.isSelected = false
            return place
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let selectedPlace = annotation as? PlacesAnnotation else { return }
        let placeAnnotation = self.placesList.first(where: {$0.id == selectedPlace.id})
        placeAnnotation?.isSelected = true
        placesListView(places: self.placesList)
    }
}

extension ViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = searchText.text ?? ""
        
        if !text.isEmpty{
            searchText.resignFirstResponder()
            // find nearby places
            findNearByPlaces(by: text)
        }
        return true
    }
}


extension ViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
