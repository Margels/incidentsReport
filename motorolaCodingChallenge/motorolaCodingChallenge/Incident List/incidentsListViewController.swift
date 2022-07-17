//
//  incidentsListViewController.swift
//  motorolaCodingChallenge
//
//  Created by Martina on 15/07/22.
//

import UIKit


// MARK: - View Controller

class incidentsListViewController: UIViewController {
    
    // array of incidents
    var incidentPosts: [constants.incidentPost] = []
    
    // table view to display incidents
    var incidentsTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.shadowOffset = .zero
        tv.layer.shadowRadius = 5
        tv.layer.shadowColor = UIColor.label.cgColor
        tv.layer.shadowOpacity = 0.1
        return tv
    }()
    
    // try again label for error handling
    var tryAgainLabel: UILabel = {
        let l = UILabel()
        l.text = "Unable to fetch data. Make sure your internet connection is stable and try again."
        l.textAlignment = .center
        l.numberOfLines = 0
        l.textColor = .label
        return l
    }()
    
    // try again button to reload data
    var tryAgainButton: UIButton = {
        let b = UIButton()
        let i = UIImage(systemName: "arrow.counterclockwise")
        b.setImage(i, for: .normal)
        b.frame.size = CGSize(width: 40, height: 40)
        return b
    }()
    
    // try again stack view (label + button)
    lazy var tryAgainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        let y = self.navigationController?.navigationBar.frame.height
        sv.frame = CGRect(x: 20, y: (y ?? 0) + 150, width: self.view.frame.width - 40, height: 200)
        sv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return sv
    }()
    
    // bar button to rearrange items
    lazy var rearrangeBarButtonItem: UIBarButtonItem = {
        let i = UIImage(systemName: "arrow.up.arrow.down")
        let b = UIBarButtonItem(image: i, style: .plain, target: self, action: #selector(rearrangeIncidents(sender:)))
        return b
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nav bar set up
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = rearrangeBarButtonItem
        
        // view background
        self.view.backgroundColor = .secondarySystemBackground
        
        // table view in vc
        self.view.addSubview(incidentsTableView)
        setUpIncidentsTableView()
        
        // try again button for error handling
        tryAgainButton.addTarget(self, action: #selector(tryAgainButton(sender:)), for: .touchUpInside)
        
        // pull data API
        loadDataAPI()
        
    }
    
    // remove string from back button
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    
// MARK: - Methods
    
    // rearrange bar button action
    @objc func rearrangeIncidents(sender: UIBarButtonItem) {
        self.incidentPosts.removeAll()
        let posts = incidentListViewModel.reorder()
        self.incidentPosts.append(contentsOf: posts)
        DispatchQueue.main.async {
            self.incidentsTableView.reloadData()
        }
    }
    
    
    // try again action after error
    @objc func tryAgainButton(sender: UIButton) {
        tryAgainStackView.alpha = 0
        loadDataAPI()
    }
    
    
    // load data to table view
    func loadDataAPI() {
        
        // start loading screen and get data
        constants.loadingScreen(true, view: self)
        incidentListViewModel.pullData( { posts in
            if let posts = posts {
                self.incidentPosts.append(contentsOf: posts)
                
                // if request was successful populate tv
                DispatchQueue.main.async {
                    self.navigationItem.title = "Incidents"
                    self.incidentsTableView.reloadData()
                    constants.loadingScreen(false, view: self)
                    
                    // remove stack view if present in view
                    if self.view.contains(self.tryAgainStackView) {
                        self.tryAgainStackView.removeFromSuperview()
                    }
                }
            
            // if error
            } else {
                self.navigationItem.title = "Incidents"
                self.loadingFailed()
            }
        })
    }
        
    
    // error handling (loading failed)
    func loadingFailed() {
        
        // set navbar title back to regular title
        self.navigationItem.title = "Incidents"
        
        // if stack view is already in view
        switch view.contains(tryAgainStackView) {
        
        // if true, only use alpha component
        case true:
            tryAgainStackView.alpha = 1
            
        // if false, add to view
        case false:
            self.view.addSubview(tryAgainStackView)
            self.tryAgainStackView.addArrangedSubview(tryAgainLabel)
            self.tryAgainStackView.addArrangedSubview(tryAgainButton)
            
        }
    }
    
    
    // set up incidents table view
    func setUpIncidentsTableView() {
        
        // set up constraints
        let itv = self.incidentsTableView
        let constraints = [
            itv.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            itv.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            itv.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            itv.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
        ]
        constraints.forEach { constraint in
            constraint.isActive = true 
        }
        
        // set up for cells
        itv.register(incidentTableViewCell.self,
                                    forCellReuseIdentifier: "incidentCell")
        itv.rowHeight = UITableView.automaticDimension
        itv.backgroundColor = .clear
        
        // pass data
        itv.delegate = self
        itv.dataSource = self
    }

}


// MARK: - Table View

extension incidentsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // number of rows is of incidents
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return incidentPosts.count
        
    }
    
    // estimated height is 100
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    // set dynamic height for larger content
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    // set cells content
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // set up table view cell & its content
        let cell = tableView.dequeueReusableCell(withIdentifier: "incidentCell", for: indexPath) as! incidentTableViewCell
        
        // cell formatting
        cell.backgroundColor = .systemBackground
        cell.accessoryType = .disclosureIndicator
        
        // cell data
        let ref = incidentPosts[indexPath.row]
        cell.detailLabel.text = constants.dateFormat(ref.callTime)
        cell.titleLabel.text = ref.title
        let url = ref.typeIcon
        
        // use activity indicator while image is loading
        let activityIndicator = UIActivityIndicatorView()
        let size = cell.incidentImage.frame.size.width
        activityIndicator.frame = CGRect(x: 25,
                                         y: cell.contentView.frame.size.height / 2 - size / 2,
                                         width: size,
                                         height: size)
        activityIndicator.tintColor = .label
        cell.contentView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        if let data = try? Data(contentsOf: url) {
            cell.incidentImage.image = UIImage(data: data)
            activityIndicator.stopAnimating()
        } else {
            cell.incidentImage.image = UIImage(systemName: "photo")
            cell.incidentImage.tintColor = .label
            activityIndicator.stopAnimating()
        }
        
        // display cell
        return cell
    }
    
    // action upon cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // deselect row animation
        tableView.deselectRow(at: indexPath, animated: true)
        
        // set selected incident data
        let incident = incidentPosts[indexPath.row]
        incidentViewModel.incident = incident
        
        // perform segue (push or detail)
        self.performSegue(withIdentifier: "showIncidentSegue", sender: nil)
    }
    
}
