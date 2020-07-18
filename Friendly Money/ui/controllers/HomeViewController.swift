//
//  HomeViewController.swift
//  Friendly Money
//
//  Created by Anuran Barman on 16/07/20.
//  Copyright © 2020 Anuran Barman. All rights reserved.
//

import UIKit
import Material
import PopupDialog
import Toaster
import CoreData

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var addButton:RaisedButton?
    var friendsTableView:UITableView?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    var friends:[Friend] = []
    var friendsLabel:UILabel?
    var logoImageView:UIImageView!
    var emptyLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = appDelegate.persistentContainer.viewContext
        
        self.navigationItem.title = "Friendly Money"
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: Colors.buttonColor)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.view.backgroundColor = UIColor(hexString: Colors.backgroundColor)
        
        friendsLabel = UILabel()
        friendsLabel?.translatesAutoresizingMaskIntoConstraints = false
        friendsLabel?.text = "Friends"
        friendsLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        friendsLabel?.textColor = UIColor.gray
        
        self.view.addSubview(friendsLabel!)
        
        friendsLabel?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        friendsLabel?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        friendsLabel?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        friendsLabel?.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "logo")
        
        self.view.addSubview(logoImageView)
        
        logoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: 0).isActive = true
        
        emptyLabel = UILabel()
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No Friends Added Yet"
        emptyLabel.font = UIFont.boldSystemFont(ofSize: 20)
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .lightGray
        
        self.view.addSubview(emptyLabel)
        
        emptyLabel.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 10).isActive = true
        emptyLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        emptyLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        
        addButton = RaisedButton(title: "Add Friend", titleColor: .white)
        addButton?.translatesAutoresizingMaskIntoConstraints = false
        addButton?.backgroundColor = UIColor(hexString: Colors.buttonColor)
        addButton?.addTarget(self, action: #selector(addFriendTapped(_:)), for: [.touchUpInside])
        
        self.view.addSubview(addButton!)
        
        addButton?.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        addButton?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        addButton?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        addButton?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        friendsTableView = UITableView()
        friendsTableView?.translatesAutoresizingMaskIntoConstraints = false
        friendsTableView?.tableFooterView = UIView()
        friendsTableView?.separatorStyle = .none
        friendsTableView?.backgroundColor = .clear
        friendsTableView?.register(FriendsTableViewCell.self, forCellReuseIdentifier: "friendsCell")
        friendsTableView?.delegate = self
        friendsTableView?.dataSource = self
        
        self.view.addSubview(friendsTableView!)
        
        friendsTableView?.topAnchor.constraint(equalTo: self.friendsLabel!.bottomAnchor, constant: 10).isActive = true
        friendsTableView?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        friendsTableView?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        friendsTableView?.bottomAnchor.constraint(equalTo: self.addButton!.topAnchor, constant: 10).isActive = true
        
        self.getFriendsList()
    }
    
    func getFriendsList(){
        let fetchRequest = NSFetchRequest<Friend>(entityName: "Friend")
        do {
            let results = try self.context.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.friends = results
                self.friendsTableView?.reloadData()
                if self.friends.count > 0 {
                    self.logoImageView.isHidden = true
                    self.emptyLabel.isHidden = true
                }else {
                    self.logoImageView.isHidden = false
                    self.emptyLabel.isHidden = false
                }
            }
        }catch{
            print("error at fetching friends list \(error.localizedDescription)")
        }
    }
    
    @objc func addFriendTapped(_ sender:RaisedButton){
        let vc = AddNewFriendViewController()
        let dialog = PopupDialog(viewController: vc,buttonAlignment: .horizontal,preferredWidth: UIScreen.main.bounds.size.width - 40)
        let cancelButton = CancelButton(title: "CANCEL") {
            
        }
        let defaultButton = DefaultButton(title: "ADD") {
            if let name = (dialog.viewController as! AddNewFriendViewController).name {
                let entity = NSEntityDescription.entity(forEntityName: "Friend", in: self.context)
                let newFriend = NSManagedObject(entity: entity!, insertInto: self.context)
                newFriend.setValue(name, forKey: "name")
                newFriend.setValue("\(Date().timeIntervalSince1970)", forKey: "id")
                do {
                    try self.context.save()
                    print("new Friend is susccessfully saved.")
                    self.getFriendsList()
                  } catch {
                   print("Failed saving new Friend.")
                }
            }else {
                Toast(text: "Friend's name can not be empty.").show()
            }
        }
        dialog.addButtons([cancelButton,defaultButton])
        
        self.present(dialog, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsTableViewCell
        cell.setup(name: self.friends[indexPath.row].name!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let txVC = TransactionsViewController()
        txVC.friend = self.friends[indexPath.row]
        txVC.refreshList = {
            self.getFriendsList()
        }
        self.navigationController?.pushViewController(txVC, animated: true)
    }

    

}
