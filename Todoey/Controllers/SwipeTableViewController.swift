//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Arturo  Aguilar Lopez on 11/09/2019.
//  Copyright © 2019 Arturo  Aguilar Lopez. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Item deleted")
            
            self.updateModel(at: indexPath)

            
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "trash-circle")
        
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath){
        //Update data model

    }
    
}


//Puede fallar el categories por como está declarado
//            if let categoryForDeletion = self.categories?[indexPath.row]{
//                do{
//                    try self.realm.write{
//                        self.realm.delete(categoryForDeletion)
//                    }
//                }catch{
//                    print("Error deleting category\(error)")
//                }
//            }
