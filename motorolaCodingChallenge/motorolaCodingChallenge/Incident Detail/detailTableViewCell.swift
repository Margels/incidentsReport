//
//  detailTableViewCell.swift
//  motorolaCodingChallenge
//
//  Created by Martina on 16/07/22.
//

import UIKit

class detailTableViewCell: UITableViewCell {
    
    // detail label on top
    let detailLabel: UILabel = {
        
        var l = UILabel()
        l.backgroundColor = .clear
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        return l
        
    }()
    
    // title label bottom
    let titleLabel: UILabel = {
        
        var l = UILabel()
        let padding: CGFloat = 7
        l.backgroundColor = .clear
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        return l
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // add subviews and constraints
        self.contentView.addSubview(detailLabel)
        setDetailLabelConstraints()
        self.contentView.addSubview(titleLabel)
        setTitleLabelConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
// MARK: - Methods
    
    // detail label constraints
    func setDetailLabelConstraints() {
        
        // set leading label padding from image view, top and trailing from content view
        let l = detailLabel
        let constraints = [
            l.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            l.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            l.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -30)
        ]
        constraints.forEach { constraint in
            constraint.isActive = true
            
        }
    }
    
    // title label constraints
    func setTitleLabelConstraints() {
        
        // set top from detail label, leading from image view, bottom & trailing from content view
        let l = titleLabel
        let constraints = [
            l.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            l.topAnchor.constraint(equalTo: self.detailLabel.bottomAnchor, constant: 5),
            l.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -30),
            l.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ]
        constraints.forEach { constraint in
            constraint.isActive = true
            
        }
    }
    
    
}
