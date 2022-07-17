//
//  incidentViewController.swift
//  motorolaCodingChallenge
//
//  Created by Martina on 15/07/22.
//

import UIKit
import MapKit


// MARK: - View Controller

class incidentViewController: UIViewController {
    
    // table view where the data will display
    var incidentTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.layer.shadowOffset = .zero
        tv.layer.shadowRadius = 5
        tv.layer.shadowColor = UIColor.label.cgColor
        tv.layer.shadowOpacity = 0.1
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // the selected incident
    var incident = incidentViewModel.incident
    
    // dictionary of the detailed data that will display
    var dictionary: [String: String] = [:]
    var headers = ["Location", "Status", "Type", "Call Time"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nav bar set up
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.sizeToFit()
        
        // view set up
        self.view.backgroundColor = .secondarySystemBackground
        
        // incident table view set up
        self.view.addSubview(incidentTableView)
        setUpIncidentTableView()
        
        // pass data
        loadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // erase data when user goes back
        incidentViewModel.incident = nil
        
    }
    
    
// MARK: - Methods
    
    // load tv data
    func loadData() {
        
        // start loading screen animation & get data as dictionary
        constants.loadingScreen(true, view: self)
        incidentViewModel.incidentDictionary { dictionary in
            self.dictionary = dictionary
            
            // reload table view
            DispatchQueue.main.async {
                self.incidentTableView.reloadData()
                // end loading screen animation and change back navbar title
                self.navigationItem.title = self.incident?.title ?? "Incident"
                constants.loadingScreen(false, view: self)
            }
        }
    }
    
    
    
    // set up incident table view constraints
    func setUpIncidentTableView() {
        
        // constraints
        let itv = self.incidentTableView
        let constraints = [
            itv.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            itv.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            itv.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            itv.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ]
        constraints.forEach { constraint in
            constraint.isActive = true
        }
        
        // cells
        itv.register(mapTableViewCell.self,
                                    forCellReuseIdentifier: "mapTableViewCell")
        itv.register(detailTableViewCell.self,
                                    forCellReuseIdentifier: "detailTableViewCell")
        itv.rowHeight = UITableView.automaticDimension
        itv.backgroundColor = .clear
        
        // tv data
        itv.delegate = self
        itv.dataSource = self
    }

}


// MARK: - Table View

extension incidentViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 1 section for map, 1 section for details
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    // 1 row for map, 4 for dictionary data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfRows = section == 0 ? 1 : dictionary.count
        return numberOfRows
        
    }
    
    // add header for details section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let title = section == 1 ? "Details" : ""
        return title
        
    }
    
    // prepare map height to be about half screen, details row should be about 60
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height: CGFloat = indexPath.section == 0 ? incidentViewModel.getMapHeight(self) : 60
        return height
        
    }
    
    // map height will be about half screen, details row should be about 60 or more for longer text
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height: CGFloat = indexPath.section == 0 ? incidentViewModel.getMapHeight(self) : UITableView.automaticDimension
        return height
        
    }
    
    // pass incident data to cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // different settings for map and details
        switch indexPath.section == 0 {
            
            // map
            case true:
            
                // map cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "mapTableViewCell", for: indexPath) as! mapTableViewCell
            
                // map should be the size of entire cell
                cell.mapView.frame = cell.contentView.bounds
            
                // translate lat/lon into pin in map
                incidentViewModel.getLocation { region in
                    // remove old pinpoints
                    cell.mapView.removeAnnotations(cell.mapView.annotations)
                    cell.mapView.delegate = self
                    cell.mapView.setRegion(region, animated: true)
                    // custom pinpoint with incident type image
                    cell.mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "incidentPin")
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = region.center
                    cell.mapView.addAnnotation(annotation)
                }
            
                // display cell
                return cell
                
            // details
            case false:
            
                // detail cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "detailTableViewCell", for: indexPath) as! detailTableViewCell
            
                // settings (cell should not be selectable)
                cell.selectionStyle = .none
                cell.backgroundColor = .systemBackground
            
                // sort and pass data from dictionary
                let ref = headers[indexPath.row]
                cell.detailLabel.text = ref
                cell.titleLabel.text = dictionary[ref]
            
                // display cell
                return cell
            
        }
    }
    
}


// MARK: - Map View

extension incidentViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // make sure it's a point annotation for custom view
        guard annotation is MKPointAnnotation else { return nil }

        // use custom pin and add custom image
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "incidentPin")
        if let pin = annotationView {
            if let url = incident?.typeIcon, let data = try? Data(contentsOf: url) {
                let img = UIImage(data: data)
                pin.image = img
                pin.frame.size = CGSize(width: 35, height: 35)
                pin.annotation = annotation
            }
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "incidentPin")
            annotationView?.canShowCallout = true
        }
        return annotationView
    }
    
}
