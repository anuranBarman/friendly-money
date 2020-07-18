//
//  AttachmentViewController.swift
//  Friendly Money
//
//  Created by Anuran Barman on 18/07/20.
//  Copyright © 2020 Anuran Barman. All rights reserved.
//

import UIKit

class AttachmentViewController: UIViewController {

    var image:UIImage!
    var imageScrollView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Attachment"
        let backButton = UIBarButtonItem(image: UIImage(named: "left_arrow")?.withRenderingMode(.alwaysTemplate), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonTapped(_:)))
        backButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = backButton

        imageScrollView = UIImageView()
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.image = self.image
        imageScrollView.contentMode = .scaleToFill
        
        self.view.addSubview(imageScrollView)
        
        imageScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive =  true
        imageScrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive =  true
        imageScrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive =  true
        imageScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive =  true
    }
    
    @objc func backButtonTapped(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
