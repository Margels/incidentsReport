//
//  incidentListViewModel.swift
//  motorolaCodingChallenge
//
//  Created by Martina on 15/07/22.
//

import Foundation
import UIKit

class incidentListViewModel {
    
    // incident's data
    typealias incidentPost = constants.incidentPost
    static var incidentPosts: [incidentPost] = []
    
    // list order
    static var descendingOrder = true
    
    
    // MARK: - Methods
    
    // get data from API
    static func pullData(_ completion: @escaping ([incidentPost]?) -> ()) {
        
        // get data from given url
        let url = URL(string: "https://run.mocky.io/v3/bd4d6d27-e75a-4f57-a560-313f5331c3eb")
        if let url = url {
            
            // start session
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                do {
                    guard let data = data else { return }
                    // transform data in incident post
                    let decoder = JSONDecoder()
                    let d = try decoder.decode([incidentPost].self, from: data)
                    d.forEach { post in
                        incidentPosts.append(post)
                        if post.title == d.last?.title {
                            let result = reorder()
                            completion(result)
                        }
                    }
                // error handling
                } catch {
                    self.loadingError(incidentsListViewController(), message: error.localizedDescription)
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    
    
    // error handling: display error message
    static func loadingError(_ view: UIViewController, message: String) {
        
        // find loading views (blurry and rotating image) via tag and remove them, then display error alert
        if let v = view.view.subviews.first(where: { $0.tag == 100 }), let b = view.view.subviews.first(where: { $0.tag == 101 }) {
            
            constants.badSignalAlertView(view, message: message)
            v.removeFromSuperview()
            b.removeFromSuperview()
            
        }
    }
    
    
    // sort by call time (ascending or descending)
    static func reorder() -> [incidentPost] {
        
        // from string to date format
        let incidents = incidentPosts
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        // descending and ascending order
        let descendingIncidents = incidents.sorted(by: { formatter.date(from: $0.callTime) ?? Date() > formatter.date(from: $1.callTime) ?? Date() })
        let ascendingIncidents = incidents.sorted(by: { formatter.date(from: $0.callTime) ?? Date() < formatter.date(from: $1.callTime) ?? Date() })
        
        // rearrange opposite of previous order
        let result = descendingOrder ? descendingIncidents : ascendingIncidents
        descendingOrder = !descendingOrder
        return result
                
    }
    
}
