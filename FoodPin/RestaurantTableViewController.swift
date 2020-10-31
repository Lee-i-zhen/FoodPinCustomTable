
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Simon Ng on 28/10/2019.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    
    
    var restaurantNames = ["Watermellon","Apple","Orange","Strawberry","Pear"]
    
    @IBOutlet var myLabel: UILabel!
    
    var restaurantTypes = ["$500","$100","$90","$200","$150"]
    var price = [500,100,90,200,150]
    
    var restaurantImages = ["watermellon","apple","orange","Strawberry","pear"]
    
    
    
    var restaurantIsVisited = Array(repeating: false, count: 5)//解決重複出現
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "datacell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        
        // Configure the cell...
        cell.nameLabel?.text = restaurantNames[indexPath.row]
        cell.typeLabel.text = restaurantTypes[indexPath.row]
        cell.thumbnailImageView.image = UIImage(named: restaurantImages[indexPath.row])
        if restaurantIsVisited[indexPath.row] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        //cell.accessoryType = restaurantIsVisited[indexPath.row] ? .checkmark : .none
        return cell
    }
    
    
    
    
    func add(totalprice: [Int]) -> Int {
        var total3 = 0
        if totalprice.count == 0
        {
            return 0
        }
        else{
            
            for i in 0...totalprice.count-1
            {
                total3 = total3 + totalprice[i]
            }
            return total3
        }
    }
    
    
    var arr3 = [Int]()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Create an option menu as an action sheet
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        
        //for ipad
        if let popoverController = optionMenu.popoverPresentationController {
            if let cell = tableView.cellForRow(at: indexPath) {
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            }
        }

        
        let checkInAction = UIAlertAction(title: "Check in", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            cell?.backgroundColor = UIColor(red: 32.0/255.0, green:100.0/255.0, blue: 140.0/255.0, alpha: 1.0)
            self.restaurantIsVisited[indexPath.row] = true
            let tt = self.price[indexPath.row]
            self.arr3.append(tt)
            let t2 = self.add(totalprice: self.arr3)
            self.myLabel.text = "   Total price = " + String(t2)
            
        })

        
        optionMenu.addAction(checkInAction)
        
        //Add Undo check-in action讓勾勾不見
        let UncheckAction = UIAlertAction(title: "Uncheck", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            let cell = tableView.cellForRow(at: indexPath)
            if self.restaurantIsVisited[indexPath.row]
            {
                cell?.accessoryType = .none
                self.restaurantIsVisited[indexPath.row] = false
                
            }
            
            
            let tt = self.price[indexPath.row]
            if self.arr3[0] == tt{
                self.arr3.remove(at: 0)
            }
            else{
                for i in 1...self.arr3.count-1
                {
                    if self.arr3[i] == tt
                    {
                        self.arr3[i] = 0
                    }
                }
                
            }
            let t2 = self.add(totalprice: self.arr3)
            self.myLabel.text = "   Total price = " + String(t2)

            
        })
        
        optionMenu.addAction(UncheckAction)
        
        // Add actions to the menu
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        // Display the menu
        present(optionMenu, animated: true, completion: nil)
        
        // Deselect a row讓灰灰的不見
        tableView.deselectRow(at: indexPath, animated: false)
        //myLabel.text = "   Total price = " + restaurantNames[indexPath.row]
        
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            // Delete the row from the data source
            self.restaurantNames.remove(at: indexPath.row)
            self.restaurantTypes.remove(at: indexPath.row)
            self.restaurantIsVisited.remove(at: indexPath.row)
            self.restaurantImages.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Call completion handler with true to indicate
            completionHandler(true)
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            let defaultText = "Just checking in at " + self.restaurantNames[indexPath.row]
            
            let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        // Set the icon and background color for the actions
        deleteAction.backgroundColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        deleteAction.image = UIImage(systemName: "trash")
        
        shareAction.backgroundColor = UIColor(red: 150.0/255.0, green: 140.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])//array
        
        return swipeConfiguration
        
        
        
    }
    
    
}
