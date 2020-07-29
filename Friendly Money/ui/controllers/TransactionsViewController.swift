//
//  TransactionsViewController.swift
//  Friendly Money
//
//  Created by Anuran Barman on 16/07/20.
//  Copyright © 2020 Anuran Barman. All rights reserved.
//

import UIKit
import PopupDialog
import Toaster
import CoreData
class TransactionsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    var txTableView:UITableView!
    var transactions:[Transaction] = []
    var friend:Friend!
    var refreshList:(()->())!
    var summaryCard:CardView!
    var totalLentHeaderLabel:UILabel!
    var totalBorrowedHeaderLabel:UILabel!
    var totalLentLabel:UILabel!
    var totalBorrowedLabel:UILabel!
    var summaryLabel:PaddingLabel!
    var imagePicker:UIImagePickerController = UIImagePickerController()
    var selectedTransaction:Transaction!
    var logoImageView:UIImageView!
    var emptyLabel:UILabel!
    var transactionsTypeControl:UISegmentedControl!
    var selectedSegmentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = appDelegate.persistentContainer.viewContext
        
        self.navigationItem.title = "Transactions"
        self.view.backgroundColor = UIColor(hexString: Colors.backgroundColor)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "left_arrow")?.withRenderingMode(.alwaysTemplate), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonTapped(_:)))
        backButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = backButton
        
        let addButton = UIBarButtonItem(image: UIImage(named: "add_small")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(addButtonTapped(_:)))
        addButton.tintColor = .white
        let deleteButton = UIBarButtonItem(image: UIImage(named: "delete_small")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(deleteButtonTapped(_:)))
        deleteButton.tintColor = .white
        let shareButton = UIBarButtonItem(image: UIImage(named: "share")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(shareButtonTapped(_:)))
        shareButton.tintColor = .white
        self.navigationItem.rightBarButtonItems = [addButton,shareButton,deleteButton]
        
        
        transactionsTypeControl = UISegmentedControl(items: ["ALL","BORROWED","LENT"])
        transactionsTypeControl.selectedSegmentIndex = 0
        transactionsTypeControl.translatesAutoresizingMaskIntoConstraints=false
        transactionsTypeControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        self.view.addSubview(transactionsTypeControl)
        
        transactionsTypeControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        transactionsTypeControl.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        transactionsTypeControl.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        txTableView = UITableView()
        txTableView.translatesAutoresizingMaskIntoConstraints = false
        txTableView.backgroundColor = .clear
        txTableView.tableFooterView = UIView()
        txTableView.separatorStyle = .none
        txTableView.delegate = self
        txTableView.dataSource = self
        txTableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "txCell")
        
        self.view.addSubview(txTableView)
        
        txTableView.topAnchor.constraint(equalTo: self.transactionsTypeControl.bottomAnchor, constant: 10).isActive = true
        txTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        txTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        txTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -190).isActive = true
        
        logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "money")
        
        self.view.addSubview(logoImageView)
        
        logoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: 0).isActive = true
        
        emptyLabel = UILabel()
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No Transactions Happened Yet"
        emptyLabel.font = UIFont.boldSystemFont(ofSize: 20)
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .lightGray
        
        self.view.addSubview(emptyLabel)
        
        emptyLabel.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 10).isActive = true
        emptyLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        emptyLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        
        summaryCard = CardView()
        summaryCard.backgroundColor = .white
        summaryCard.translatesAutoresizingMaskIntoConstraints = false
        
        totalBorrowedHeaderLabel = UILabel()
        totalBorrowedHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        totalBorrowedHeaderLabel.text = "Total Borrowed :"
        totalBorrowedHeaderLabel.textColor = .black
        
        summaryCard.addSubview(totalBorrowedHeaderLabel)
        
        totalBorrowedHeaderLabel.topAnchor.constraint(equalTo: summaryCard.topAnchor, constant: 10).isActive = true
        totalBorrowedHeaderLabel.leftAnchor.constraint(equalTo: summaryCard.leftAnchor, constant: 10).isActive = true
        
        
        totalBorrowedLabel = UILabel()
        totalBorrowedLabel.translatesAutoresizingMaskIntoConstraints = false
        totalBorrowedLabel.textColor = .black
        totalBorrowedLabel.textAlignment = .right
        totalBorrowedLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        summaryCard.addSubview(totalBorrowedLabel)
        
        totalBorrowedLabel.topAnchor.constraint(equalTo: summaryCard.topAnchor, constant: 10).isActive = true
        totalBorrowedLabel.rightAnchor.constraint(equalTo: summaryCard.rightAnchor, constant: -10).isActive = true
        
        totalLentHeaderLabel = UILabel()
        totalLentHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLentHeaderLabel.text = "Total Lent :"
        totalLentHeaderLabel.textColor = .black
        
        summaryCard.addSubview(totalLentHeaderLabel)
        
        totalLentHeaderLabel.topAnchor.constraint(equalTo: self.totalBorrowedLabel.bottomAnchor, constant: 10).isActive = true
        totalLentHeaderLabel.leftAnchor.constraint(equalTo: summaryCard.leftAnchor, constant: 10).isActive = true
        
        totalLentLabel = UILabel()
        totalLentLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLentLabel.textColor = .black
        totalLentLabel.textAlignment = .right
        totalLentLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        summaryCard.addSubview(totalLentLabel)
        
        totalLentLabel.topAnchor.constraint(equalTo: self.totalBorrowedLabel.bottomAnchor, constant: 10).isActive = true
        totalLentLabel.rightAnchor.constraint(equalTo: summaryCard.rightAnchor, constant: -10).isActive = true
        
        let horizontalLine = UIView()
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
        horizontalLine.backgroundColor = UIColor(hexString: Colors.backgroundColor)
        
        summaryCard.addSubview(horizontalLine)
        
        horizontalLine.leftAnchor.constraint(equalTo: summaryCard.leftAnchor, constant: 10).isActive = true
        horizontalLine.rightAnchor.constraint(equalTo: summaryCard.rightAnchor, constant: -10).isActive = true
        horizontalLine.topAnchor.constraint(equalTo: totalLentLabel.bottomAnchor, constant: 10).isActive = true
        horizontalLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        summaryLabel = PaddingLabel()
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.textAlignment = .center
        summaryLabel.textColor = .black
        summaryLabel.font = UIFont.boldSystemFont(ofSize: 18)
        summaryLabel.backgroundColor = UIColor(hexString: Colors.backgroundColor)
        summaryLabel.layer.cornerRadius = 10
        summaryLabel.clipsToBounds = true
        
        summaryCard.addSubview(summaryLabel)
        
        summaryLabel.topAnchor.constraint(equalTo: horizontalLine.bottomAnchor, constant: 10).isActive = true
        summaryLabel.leftAnchor.constraint(equalTo: summaryCard.leftAnchor, constant: 10).isActive = true
        summaryLabel.rightAnchor.constraint(equalTo: summaryCard.rightAnchor, constant: -10).isActive = true
        
        self.view.addSubview(summaryCard)
        
        summaryCard.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        summaryCard.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        summaryCard.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        summaryCard.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.getTransactionsList()
        }
    }
    
    @objc func segmentChanged(_ sender:UISegmentedControl){
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        self.getTransactionsList()
    }
    
    func setTotal(){
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        var totalBorrowed = 0.0
        var totalLent = 0.0
        
        for tx in self.transactions {
            if tx.type == 0 {
                totalBorrowed += tx.amount
            }else {
                totalLent += tx.amount
            }
        }
        
        totalBorrowedLabel.text = numberFormatter.string(from: totalBorrowed as NSNumber)
        totalLentLabel.text = numberFormatter.string(from: totalLent as NSNumber)
        
        if totalBorrowed > totalLent {
            summaryLabel.text = "You have to give \(numberFormatter.string(from: (totalBorrowed - totalLent) as NSNumber)!)"
        }else if totalLent > totalBorrowed {
            summaryLabel.text = "You will get \(numberFormatter.string(from: (totalLent - totalBorrowed) as NSNumber)!)"
        }else {
            summaryLabel.text = "Balanced"
        }
    }
    
    func getTransactionsList(){
        let fetchRequest = NSFetchRequest<Transaction>(entityName: "Transaction")
        let predicate = NSPredicate(format: "userId = %@", self.friend.id!)
        fetchRequest.predicate = predicate
        do {
            var results = try self.context.fetch(fetchRequest)
            DispatchQueue.main.async { [weak self] in
                results.sort { (tx1, tx2) -> Bool in
                    return tx1.date!.timeIntervalSince1970 >= tx2.date!.timeIntervalSince1970
                }
                results = results.filter({ (tx) -> Bool in
                    if self?.selectedSegmentIndex == 1 {
                        return tx.type == 0
                    }else if self?.selectedSegmentIndex == 2 {
                        return tx.type == 1
                    }else {
                        return true
                    }
                })
                self?.transactions = results
                self?.txTableView.reloadData()
                self?.setTotal()
                if self?.transactions.count != nil && self!.transactions.count > 0 {
                    self?.logoImageView.isHidden = true
                    self?.emptyLabel.isHidden = true
                }else {
                    self?.logoImageView.isHidden = false
                    self?.emptyLabel.isHidden = false
                }
            }
        }catch{
            print("error at fetching transactions list \(error.localizedDescription)")
        }
    }
    
    @objc func addButtonTapped(_ sender:UIBarButtonItem){
        let vc = AddTransactionViewController()
        let dialog = PopupDialog(viewController: vc,buttonAlignment: .horizontal,preferredWidth: UIScreen.main.bounds.size.width - 40)
        let cancelButton = CancelButton(title: "CANCEL") {
            
        }
        let defaultButton = DefaultButton(title: "ADD") {
            let vc = dialog.viewController as! AddTransactionViewController
            let amount = vc.amount
            let msg = vc.msg
            let type = vc.type
            if amount != nil && msg != nil {
                let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: self.context)
                let newTx = NSManagedObject(entity: entity!, insertInto: self.context)
                newTx.setValue(amount, forKey: "amount")
                newTx.setValue(msg, forKey: "message")
                newTx.setValue(type, forKey: "type")
                newTx.setValue(Date(), forKey: "date")
                newTx.setValue(self.friend.id!, forKey: "userId")
                newTx.setValue(nil, forKey: "attachments")
                do {
                    try self.context.save()
                    print("new transaction is susccessfully saved.")
                    self.getTransactionsList()
                  } catch {
                   print("Failed saving new transaction.")
                }
            }else {
                Toast(text: "All fields are required to add a transaction.").show()
            }
        }
        dialog.addButtons([cancelButton,defaultButton])
        
        self.present(dialog, animated: true, completion: nil)
    }
    
    @objc func shareButtonTapped(_ sender:UIBarButtonItem){
        let text = Utility.getSharableText(friend: self.friend, transactions: self.transactions,type: self.selectedSegmentIndex)
        let fileName = "transactions_for_\(self.friend.name!.replacingOccurrences(of: " ", with: "")).txt"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                self.present(vc, animated: true, completion: nil)
            }catch {
                Toast(text: "Coult not share transactions file.").show()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "txCell", for: indexPath) as! TransactionTableViewCell
        cell.setup(transaction: self.transactions[indexPath.row])
        cell.deleteTransaction = { transaction in
            self.context.delete(transaction)
            do {
                try self.context.save()
                self.getTransactionsList()
              } catch {
                Toast(text:"Friend could not be removed.").show()
            }
        }
        cell.addAttachmentTransaction = { transaction in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.selectedTransaction = transaction
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        cell.showAttachmentTransaction = { transaction in
            if let imageData = transaction.attachments {
                if let image = UIImage(data: imageData) {
                    let vc = AttachmentViewController()
                    vc.image = image
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    Toast(text:"Attachment is corrupted.").show()
                }
            }else {
                Toast(text:"Attachment is corrupted.").show()
            }
        }
        return cell
    }
    
    @objc func deleteButtonTapped(_ sender:UIBarButtonItem){
        self.context.delete(self.friend)
        do {
            try self.context.save()
            self.refreshList()
            self.navigationController?.popViewController(animated: true)
          } catch {
            Toast(text:"Transaction could not be removed.").show()
        }
    }
    
    
    @objc func backButtonTapped(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.selectedTransaction.attachments = image.pngData()
            do {
                try self.context.save()
                Toast(text: "Attachment is successfully added to the transaction.").show()
            }catch{
                Toast(text: "Attachment could not be added to the transaction.").show()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
