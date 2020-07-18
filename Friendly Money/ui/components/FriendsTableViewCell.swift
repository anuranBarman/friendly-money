//
//  FriendsTableViewCell.swift
//  Friendly Money
//
//  Created by Anuran Barman on 16/07/20.
//  Copyright © 2020 Anuran Barman. All rights reserved.
//

import UIKit
import Material

class FriendsTableViewCell: UITableViewCell {
    
    var card:CardView?
    var nameLabel:UILabel?
    var arrowImage:UIImageView?
    
    func setup(name:String){
        
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        card = CardView()
        card?.backgroundColor = .white
        card?.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel = UILabel()
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        nameLabel?.text = name
        nameLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel?.lineBreakMode = .byWordWrapping
        nameLabel?.numberOfLines = 0
        
        self.card!.addSubview(nameLabel!)
        
        nameLabel?.topAnchor.constraint(equalTo: self.card!.topAnchor, constant: 10).isActive = true
        nameLabel?.leftAnchor.constraint(equalTo: self.card!.leftAnchor, constant: 10).isActive = true
        nameLabel?.rightAnchor.constraint(equalTo: self.card!.rightAnchor, constant: -60).isActive = true
        nameLabel?.bottomAnchor.constraint(equalTo: self.card!.bottomAnchor, constant: -10).isActive = true
        
        
        self.contentView.addSubview(card!)
        
        arrowImage = UIImageView()
        arrowImage?.translatesAutoresizingMaskIntoConstraints = false
        arrowImage?.image = UIImage(named: "right_arrow")
        
        self.card?.addSubview(arrowImage!)
        
        arrowImage?.widthAnchor.constraint(equalToConstant: 40).isActive = true
        arrowImage?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        arrowImage?.centerYAnchor.constraint(equalTo: card!.centerYAnchor, constant: 0).isActive = true
        arrowImage?.rightAnchor.constraint(equalTo: card!.rightAnchor, constant: -10).isActive = true
        
        card?.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        card?.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 2).isActive = true
        card?.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -2).isActive = true
        card?.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
    }
}
