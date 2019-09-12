//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Arturo  Aguilar Lopez on 09/09/2019.
//  Copyright © 2019 Arturo  Aguilar Lopez. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{
    
    //MARK: - Definition of variables and constants
    
    var categories : Results<Category>?
    
    let realm = try! Realm()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none
    }
    
    //MARK: -TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    //        cell.delegate = self
    //        return cell
    //    }
    //
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        //super indication goes to the swipeview controller to triger the function that creeates the cell.
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]{
            
            cell.textLabel?.text = category.name
            
            guard let categoryNameColour = UIColor(hexString: category.colour) else{fatalError()}
            
            cell.backgroundColor = categoryNameColour
            
            cell.textLabel?.textColor = ContrastColorOf(categoryNameColour, returnFlat: true)
        }
        
      
        
        return cell
        
    }

    //MARK: - Data Manipulation Methods
    
    func save(category : Category){
        do{
            try realm.write{
                realm.add(category)
            }
        } catch{
            print("Error saving context\(error)")
            
        }
        //Forces the tableview to call the data sources methods again
        self.tableView.reloadData()
    }
    
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        //Puede fallar el categories por como está declarado
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                self.realm.delete(categoryForDeletion)
                }
            }catch{
                    print("Error deleting category\(error)")
                    }
            }
    }
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default){ (action) in
            
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.colour = UIColor.randomFlat.hexValue()
            
            
                self.save(category: newCategory)
            }
        
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "Create a new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true, completion: nil)
            
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}
