//
//  AddTransactionViewController.swift
//  Friendly Money
//
//  Created by Anuran Barman on 18/07/20.
//  Copyright © 2020 Anuran Barman. All rights reserved.
//

import UIKit
import Material

class AddTransactionViewController: UIViewController {

    var titleLabel:UILabel!
    var amountTextField:TextField!
    var msgTextField:TextField!
    var txType:UISegmentedControl!
    
    var amount:Double?
    var msg:String?
    var type:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Add Transaction"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        self.view.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        amountTextField = TextField()
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.placeholder = "Amount"
        amountTextField.keyboardType = .numberPad
        
        self.view.addSubview(amountTextField)
        
        amountTextField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10).isActive = true
        amountTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        amountTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        amountTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        amountTextField.addTarget(self, action: #selector(amountChanged(_:)), for: [.editingChanged])
        
        msgTextField = TextField()
        msgTextField.translatesAutoresizingMaskIntoConstraints = false
        msgTextField.placeholder = "Message"
        msgTextField.keyboardType = .numbersAndPunctuation
        msgTextField.addTarget(self, action: #selector(msgChanged(_:)), for: [.editingChanged])
        
        self.view.addSubview(msgTextField)
        
        msgTextField.topAnchor.constraint(equalTo: self.amountTextField.bottomAnchor, constant: 25).isActive = true
        msgTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        msgTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        msgTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        txType = UISegmentedControl(items: ["BORROWED","LENT"])
        txType.translatesAutoresizingMaskIntoConstraints=false
        txType.selectedSegmentIndex = 0
        txType.addTarget(self, action: #selector(segmentValueChanged(_:)), for: [.valueChanged])
        
        self.view.addSubview(txType)
        
        txType.topAnchor.constraint(equalTo: self.msgTextField.bottomAnchor, constant: 25).isActive = true
        txType.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        txType.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        txType.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc func segmentValueChanged(_ sender:UISegmentedControl){
        self.type = sender.selectedSegmentIndex
    }
    
    @objc func amountChanged(_ sender:TextField){
        if let amount = Double(sender.text ?? ""){
            self.amount = amount
        }
    }
    
    @objc func msgChanged(_ sender:TextField){
        if let msg = sender.text {
            self.msg = msg
        }
    }
    
}
