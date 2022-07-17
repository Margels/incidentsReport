//
//  Constants.swift
//  motorolaCodingChallenge
//
//  Created by Martina on 16/07/22.
//

import Foundation
import UIKit

// for properties and methods used across multiple VC
class constants {
    
    // define incident post
    struct incidentPost: Codable {
        
        var title: String
        var callTime: String
        var id: String
        var latitude: Double
        var longitude: Double
        var description: String?
        var location: String
        var status: String
        var type: String
        var typeIcon: URL
    }
    
    // blur view behind loading scren
    static var blurryView: UIVisualEffectView = {
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.frame = .zero
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
        
    }()
    

// MARK: - Methods
    
    
    // loading screen animation
    static func loadingScreen(_ bool: Bool, view: UIViewController) {
        
        // start or stop animation
        switch bool {
            
            // start animation
            case true:
                
                // nav bar title text set to "loading"
                view.navigationItem.title = "Loading..."
            
                // check user settings and blur view
                if !UIAccessibility.isReduceTransparencyEnabled {
                
                    // add blur view and bring to front
                    view.view.addSubview(blurryView)
                    view.view.bringSubviewToFront(blurryView)
                    blurryView.frame = view.view.bounds
                    // tag view to find and remove later
                    blurryView.tag = 101
                    
                    // animate the view
                    UIView.animate(withDuration: 1, delay: 1) {
                        blurryView.alpha = 0.75
                    }
                }
                
                // create blue hexagon system image to view
                let img = UIImage(systemName: "circle.hexagongrid.fill")
                let iv = UIImageView(image: img)
                iv.contentMode = .scaleAspectFill
                iv.tintColor = .tintColor
                // tag iv to find and remove from superview later
                iv.tag = 100
            
                // set position of iv
                let hw: CGFloat = 60
                let centrex = UIScreen.main.bounds.width/2 - hw/2
                iv.frame = CGRect(x: centrex,
                                  y: 250,
                                  width: hw,
                                  height: hw)
                view.view.addSubview(iv)
                view.view.bringSubviewToFront(iv)
                
                // set rotation animation
                UIView.animate(withDuration: 2, delay: 0, options: [.repeat, .curveLinear]) {
                    iv.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                }
            
            // stop animation if any
            case false:
                
                // find image view and blur view using tag and remove them if in view
                if let v = view.view.subviews.first(where: { $0.tag == 100 }), let b = view.view.subviews.first(where: { $0.tag == 101 }) {
                    v.removeFromSuperview()
                    b.removeFromSuperview()
                }
            
        }
    }
    
    
    
    // display alert when URLSession catches an error
    static func badSignalAlertView(_ view: UIViewController, message: String) {
        
        // display error details in the message
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        // only cancel action required
        let OK = UIAlertAction(title: "OK", style: .cancel)
        
        // set up and present alert
        alert.addAction(OK)
        alert.view.tintColor = .label
        view.present(alert, animated: true)
    }
    
    

    // change date format from original to extended
    static func dateFormat(_ string: String) -> String? {
        
        // change date from format
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let input = inputFormatter.date(from: string) else { return nil }
        
        // to more readable date format
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "E, d MMM yyyy 'at' hh:mm:ss a"
        outputFormatter.locale = Locale(identifier: "au")
        outputFormatter.timeZone = TimeZone.current
        
        // replace original string
        let date = outputFormatter.string(from: input)
        return date
    }
    
    
}
