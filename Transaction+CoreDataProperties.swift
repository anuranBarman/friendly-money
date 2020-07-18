//
//  Transaction+CoreDataProperties.swift
//  
//
//  Created by Anuran Barman on 18/07/20.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Double
    @NSManaged public var message: String?
    @NSManaged public var type: Int16
    @NSManaged public var date: Date?
    @NSManaged public var userId: String?
    @NSManaged public var attachments: Data?

}
