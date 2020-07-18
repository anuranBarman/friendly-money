//
//  TransactionTableViewCell.swift
//  Friendly Money
//
//  Created by Anuran Barman on 18/07/20.
//  Copyright © 2020 Anuran Barman. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    var card:CardView!
    var amountLabel:UILabel!
    var msgLabel:PaddingLabel!
    var typeLabel:PaddingLabel!
    var deleteButton:UIImageView!
    var attachmentButton:UIImageView!
    var dateLabel:PaddingLabel!
    var deleteTransaction:((_ transaction:Transaction)->())!
    var addAttachmentTransaction:((_ transaction:Transaction)->())!
    var showAttachmentTransaction:((_ transaction:Transaction)->())!
    var transaction:Transaction!
    
    func setup(transaction:Transaction){
        
        self.transaction = transaction
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        card = CardView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        amountLabel = UILabel()
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.text = "\(numberFormatter.string(from: transaction.amount as NSNumber) ?? "")"
        amountLabel.font = UIFont.boldSystemFont(ofSize: 23)
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.numberOfLines = 0
        amountLabel.lineBreakMode = .byTruncatingTail
        
        card.addSubview(amountLabel)
        
        amountLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 5).isActive = true
        amountLabel.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 5).isActive = true
        amountLabel.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -90).isActive = true
        amountLabel.heightAnchor.constraint(equalToConstant:20).isActive = true
        
        msgLabel = PaddingLabel()
        msgLabel.translatesAutoresizingMaskIntoConstraints = false
        msgLabel.text = "\(transaction.message ?? "")"
        msgLabel.numberOfLines = 0
        msgLabel.lineBreakMode = .byWordWrapping
        msgLabel.backgroundColor = UIColor(hexString: Colors.backgroundColor)
        msgLabel.textColor = .black
        
        card.addSubview(msgLabel)
        
        msgLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 10).isActive = true
        msgLabel.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 5).isActive = true
        msgLabel.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -5).isActive = true
        
        typeLabel = PaddingLabel()
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.text = transaction.type == 0 ? "BORROWED" : "LENT"
        typeLabel.font = UIFont.boldSystemFont(ofSize: 13)
        typeLabel.textAlignment = .center
        typeLabel.backgroundColor = transaction.type == 0 ? UIColor(hexString: Colors.borrowBackgroundColor) : UIColor(hexString: Colors.lentBackgroundColor)
        typeLabel.textColor = transaction.type == 0 ? UIColor(hexString: Colors.borrowTextColor) : UIColor(hexString: Colors.lentTextColor)
        typeLabel.layer.cornerRadius = 10
        typeLabel.clipsToBounds = true
        
        card.addSubview(typeLabel)
        
        typeLabel.topAnchor.constraint(equalTo: msgLabel.bottomAnchor, constant: 10).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: msgLabel.leftAnchor, constant: 0).isActive = true
        typeLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -10).isActive = true
        
        deleteButton = UIImageView()
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.image = UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate)
        deleteButton.tintColor = UIColor(hexString: Colors.lentBackgroundColor)
        deleteButton.isUserInteractionEnabled = true
        let deleteGesture = UITapGestureRecognizer(target: self, action: #selector(deleteTapped(_:)))
        deleteButton.addGestureRecognizer(deleteGesture)
        
        card.addSubview(deleteButton)
        
        deleteButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -5).isActive = true
        deleteButton.topAnchor.constraint(equalTo: card.topAnchor, constant: 5).isActive = true
        
        
        attachmentButton = UIImageView()
        attachmentButton.translatesAutoresizingMaskIntoConstraints = false
        attachmentButton.image = UIImage(named: "attachment")?.withRenderingMode(.alwaysTemplate)
        attachmentButton.tintColor = UIColor(hexString: Colors.buttonColor)
        attachmentButton.isUserInteractionEnabled = true
        let attachmentGesture = UITapGestureRecognizer(target: self, action: #selector(attachmentTapped(_:)))
        attachmentButton.addGestureRecognizer(attachmentGesture)
        
        card.addSubview(attachmentButton)
        
        attachmentButton.widthAnchor.constraint(equalToConstant: 23).isActive = true
        attachmentButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        attachmentButton.rightAnchor.constraint(equalTo: deleteButton.leftAnchor, constant: -5).isActive = true
        attachmentButton.topAnchor.constraint(equalTo: deleteButton.topAnchor, constant: 3).isActive = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy hh:mm:ss a"
        
        dateLabel = PaddingLabel()
        dateLabel.textAlignment = .right
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = dateFormatter.string(from: transaction.date!)
        dateLabel.font = dateLabel.font.withSize(13)
        
        card.addSubview(dateLabel)
        
        dateLabel.bottomAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 0).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -5).isActive = true
        
        
        self.contentView.addSubview(card)
        
        card.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        card.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5).isActive = true
        card.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5).isActive = true
        card.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
    }
    
    @objc func deleteTapped(_ sender:UITapGestureRecognizer){
        self.deleteTransaction(self.transaction)
    }
    @objc func attachmentTapped(_ sender:UITapGestureRecognizer){
        if self.transaction.attachments == nil {
            self.addAttachmentTransaction(self.transaction)
        }else {
            self.showAttachmentTransaction(self.transaction)
        }
    }
    
}
