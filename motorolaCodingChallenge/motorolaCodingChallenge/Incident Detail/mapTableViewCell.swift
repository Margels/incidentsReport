//
//  mapTableViewCell.swift
//  motorolaCodingChallenge
//
//  Created by Martina on 16/07/22.
//

import UIKit
import MapKit


class mapTableViewCell: UITableViewCell {
    
    // selected incident
    var incident = incidentViewModel.incident
    
    // reset map to initial view
    var resetViewButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .systemBackground
        b.tintColor = .link
        b.setImage(UIImage(systemName: "dot.arrowtriangles.up.right.down.left.circle"), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.cornerRadius = 20
        return b
    }()
    
    
    // map view
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.bounds = self.contentView.bounds
        return mv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // add map view
        self.contentView.addSubview(mapView)
        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // add a button to return to initial view
        self.contentView.addSubview(resetViewButton)
        self.contentView.bringSubviewToFront(resetViewButton)
        resetViewButton.addTarget(self, action:#selector(resetMapView(sender:)), for: .touchUpInside)
        setUpResetButton()
        
    }
    
// MARK: - Methods
    
    // go back to initial region action
    @objc func resetMapView(sender: UIButton) {
        incidentViewModel.getLocation { region in
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    // reset button constraints
    func setUpResetButton() {
        
        // bottom right of the map view
        let constraints = [
            resetViewButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20),
            resetViewButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            resetViewButton.heightAnchor.constraint(equalToConstant: 40),
            resetViewButton.widthAnchor.constraint(equalToConstant: 40)
        ]
        constraints.forEach { constraint in
            constraint.isActive = true
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

