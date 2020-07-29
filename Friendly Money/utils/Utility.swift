//
//  Utility.swift
//  Friendly Money
//
//  Created by Anuran Barman on 29/07/20.
//  Copyright © 2020 Anuran Barman. All rights reserved.
//

import Foundation
class Utility {
    
    static func getSharableText(friend:Friend,transactions:[Transaction],type:Int)->String{
        var text = ""
        if type == 0 {
            text += "Transactions for \(friend.name!) :\n\n"
        }else if type == 1 {
            text += "Transactions(Borrowed) for \(friend.name!) :\n\n"
        }else {
            text += "Transactions(Lent) for \(friend.name!) :\n\n"
        }
        var index = 1
        var totalBorrowed = 0.0
        var totalLent = 0.0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy hh:mm:ss a"
        
        for transaction in transactions {
            if transaction.type == 0 {
                totalBorrowed += transaction.amount
            }else {
                totalLent += transaction.amount
            }
            text += "\(index). \(numberFormatter.string(for: transaction.amount as NSNumber)!)\n"
            text += "Message : \(transaction.message ?? "")\n"
            text += "Type : \(transaction.type == 0 ? "Borrowed" : "Lent")\n"
            text += "\(dateFormatter.string(from: transaction.date!))\n\n"
            index += 1
        }
        text += "Total Borrowed : \(numberFormatter.string(for: totalBorrowed as NSNumber)!)\n"
        text += "Total Lent : \(numberFormatter.string(for: totalLent as NSNumber)!)\n\n"
        
        var summary = ""
        if totalBorrowed > totalLent {
            summary = "\(friend.name!) will get \(numberFormatter.string(from: (totalBorrowed - totalLent) as NSNumber)!)"
        }else if totalLent > totalBorrowed {
            summary = "\(friend.name!) has to give \(numberFormatter.string(from: (totalLent - totalBorrowed) as NSNumber)!)"
        }else {
            summary = "Balanced"
        }
        
        text += "\(summary)\n\n"
        
        text += "Generated by : Friendly Money\nLink : https://github.com/anuranBarman/friendly-money"
        return text
    }
    
}
