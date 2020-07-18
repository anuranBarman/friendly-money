//
//  AddNewFriendViewController.swift
//  Friendly Money
//
//  Created by Anuran Barman on 16/07/20.
//  Copyright © 2020 Anuran Barman. All rights reserved.
//

import UIKit
import Material

class AddNewFriendViewController: UIViewController {
    
    var nameTextField:TextField!
    var name:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Add Friend"
        titleLabel.textColor = .black
        titleLabel.textAlignment  = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        self.view.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        nameTextField = TextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Your Friend's Name"
        nameTextField.addTarget(self, action: #selector(textDidChange(_:)), for: [.editingChanged])
        
        
        self.view.addSubview(nameTextField)
        
        nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true

        
    }
    
    @objc func textDidChange(_ sender:TextField){
        self.name = sender.text
    }
    
    

}
