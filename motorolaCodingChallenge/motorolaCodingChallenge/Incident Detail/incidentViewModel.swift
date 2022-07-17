//
//  incidentViewModel.swift
//  motorolaCodingChallenge
//
//  Created by Martina on 15/07/22.
//

import Foundation
import MapKit

class incidentViewModel {
    
    // selected incident
    static var incident: constants.incidentPost?
    
    // delta for map view "zoom"
    static var delta: Double = 0.0025
    
    // details that will be displayed in the detail section
    static var incidentDataDictionary: [String: String] = [:]

    
    
// MARK: - Methods
    
    // use latitude and longitude to set a pinpoint on the map
    static func getLocation(_ completion: @escaping (MKCoordinateRegion) -> ()) {
        
        // safe unwrap optional
        if let incident = incident {
            
            // find map point from latitude and longitude and set region
            let center = CLLocationCoordinate2D(latitude: incident.latitude,
                                                longitude: incident.longitude)
            let region = MKCoordinateRegion(center: center,
                                            span: MKCoordinateSpan(latitudeDelta: delta,
                                                                   longitudeDelta: delta))
            
            // pass data to closure
            completion(region)
            
        }
    }
    
    
    // create a dictionary with the details of the incident
    static func incidentDictionary(_ completion: @escaping ([String: String]) -> () ) {
        
        // safely unwrap optional and convert date format to readable format
        if let incident = incident, let callTime = constants.dateFormat(incident.callTime) {
            incidentDataDictionary = [
                "Type" : incident.type,
                "Status" : incident.status,
                "Location" : incident.location,
                "Call Time": callTime
            ]
            
            // pass data on to closure
            completion(incidentDataDictionary)
        }
    }
    
    
    // set the height of the map dynamically depending on device & orientation
    static func getMapHeight(_ view: UIViewController) -> CGFloat {
        
        // map should be about half the height of the safe area
        let estimatedHeight = view.view.safeAreaLayoutGuide.layoutFrame.size.height / 2
        let mapHeight = estimatedHeight <= 400 ? estimatedHeight : 400
        return mapHeight
        
    }
    
    
}
