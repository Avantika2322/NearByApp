//
//  PlacesDetailViewController.swift
//  FirstIosApp
//
//  Created by Avantika on 29/03/25.
//

import Foundation
import UIKit

class PlacesDetailViewController: UIViewController {
    
    let place: PlacesAnnotation
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.alpha = 0.4
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    lazy var directionButton: UIButton = {
        var config = UIButton.Configuration.borderedProminent()
        let button = UIButton(configuration: config)
        button.setTitle("Directions", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var callButton: UIButton = {
        var config = UIButton.Configuration.borderedTinted()
        let button = UIButton(configuration: config)
        button.setTitle("Call", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(place: PlacesAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        
        setUpUi()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// <#Description#>
    private func setUpUi() {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        nameLabel.text = place.name
        addressLabel.text = place.address.trimmingCharacters(in: .whitespacesAndNewlines)
        detailLabel.text = place.timeZone
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(detailLabel)

        nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        
        let contactStackView = UIStackView()
        contactStackView.axis = .horizontal
        contactStackView.translatesAutoresizingMaskIntoConstraints = false
        contactStackView.spacing = UIStackView.spacingUseSystem
     
        directionButton.addTarget(self, action: #selector(handleDirectionsClick), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(handleCallClick), for: .touchUpInside)
        contactStackView.addArrangedSubview(directionButton)
        contactStackView.addArrangedSubview(callButton)
    
        stackView.addArrangedSubview(contactStackView)
        
        view.addSubview(stackView)
        
    }
    
    @objc private func handleDirectionsClick(_ sender: UIButton) {
        let coordinate = place.location.coordinate
        let url = URL(string: "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)")!
        UIApplication.shared.open(url)
    }
    
    @objc private func handleCallClick(_ sender: UIButton) {
        let url = URL(string: "tel://\(place.phoneNum.formatPhoneForCall())")!
        UIApplication.shared.open(url)
    }
}
