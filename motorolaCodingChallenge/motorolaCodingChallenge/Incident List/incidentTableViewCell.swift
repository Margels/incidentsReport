//
//  incidentTableViewCell.swift
//  motorolaCodingChallenge
//
//  Created by Martina on 15/07/22.
//

import UIKit

class incidentTableViewCell: UITableViewCell {
    
    // image symbol image view
    let incidentImage: UIImageView = {
        
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
        
    }()
    
    // detail label on top
    let detailLabel: UILabel = {
        
        var l = UILabel()
        l.backgroundColor = .clear
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontForContentSizeCategory = true
        return l
        
    }()
    
    // title label bottom
    let titleLabel: UILabel = {
        
        var l = UILabel()
        let padding: CGFloat = 20
        l.backgroundColor = .clear
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontForContentSizeCategory = true
        return l
        
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // add subviews and constraints
        self.contentView.addSubview(incidentImage)
        setImageConstraints()
        self.contentView.addSubview(detailLabel)
        setDetailLabelConstraints()
        self.contentView.addSubview(titleLabel)
        setTitleLabelConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
// MARK: - Methods
    
    // set image constraints
    func setImageConstraints() {
        
        // centre y to centre y of content view and padding from top, bottom, leading
        let iv = incidentImage
        let size: CGFloat = 40
        let constraints = [
            iv.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            iv.heightAnchor.constraint(equalToConstant: size),
            iv.widthAnchor.constraint(equalToConstant: size),
            iv.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20)
        ]
        constraints.forEach { constraint in
            constraint.isActive = true
        }
    }
    
    
    // set detail label constraints
    func setDetailLabelConstraints() {
        
        // set leading label padding from image view, top and trailing from content view
        let l = detailLabel
        let constraints = [
            l.leadingAnchor.constraint(equalTo: self.incidentImage.trailingAnchor, constant: 20),
            l.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            l.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -30)
        ]
        constraints.forEach { constraint in
            constraint.isActive = true
            
        }
    }
    
    
    // set title label constraints
    func setTitleLabelConstraints() {
        
        // set top from detail label, leading from image view, bottom & trailing from content view
        let l = titleLabel
        let constraints = [
            l.leadingAnchor.constraint(equalTo: self.incidentImage.trailingAnchor, constant: 20),
            l.topAnchor.constraint(equalTo: self.detailLabel.bottomAnchor, constant: 10),
            l.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -30),
            l.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)
        ]
        constraints.forEach { constraint in
            constraint.isActive = true
            
        }
    }
    
    
}
