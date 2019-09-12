//
//  ViewController.swift
//  Todoey
//
//  Created by Arturo  Aguilar Lopez on 03/09/2019.
//  Copyright © 2019 Arturo  Aguilar Lopez. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeTableViewController{
    
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
       
        //loadItems ya recibe el fetchedrequest. entonces no hace falta pasarle ningun parametro
        //por default al invocarla ya recibe lo que dice abajo que es el default
        loadItems()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
            guard let colourHex = selectedCategory?.colour else{fatalError()}
            
            title = selectedCategory!.name
            
            updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
        
    }
    
    //MARK: - Nav Bar Setup Methods
    func updateNavBar(withHexCode colourHexCode: String){
        guard let navBar = navigationController?.navigationBar else{fatalError("Navigation controller does not exist")}
        //If you want to change de navBar colour, just comment the line below, and asing a colour for navBar variables
        guard let navBarColor = UIColor(hexString: colourHexCode) else{fatalError()}
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        searchBar.barTintColor = navBarColor
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor :  ContrastColorOf(navBarColor, returnFlat: true) ]
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
         let cell  = super.tableView(tableView, cellForRowAt: indexPath)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
 
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Realm
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
         
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // when the users taps the ui alert, what should happend
            
            //We need to put a conditional because selectedCat is of type ?(maybe its nil)
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving newItem\(error)")
                }
        
            }
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
                
        alert.addAction(action)
        
        present(alert,animated: true, completion: nil)
        
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        //Puede fallar el categories por como está declarado
        if let itemForDeletion = self.todoItems?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(itemForDeletion)
                }
            }catch{
                print("Error deleting item\(error)")
            }
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
}


//MARK:- Search Bar Methods
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

//Decoder
//    func loadItems(){
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder =  PropertyListDecoder()
//            do{
//                todoItems = try decoder.decode([Item].self, from: data)
//            }catch{
//                print("Error decoding")
//            }
//        }
//    }


//Previous lOad items
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate{
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
//        }else{
//            request.predicate = categoryPredicate
//        }
//
//        do{
//         todoItems = try context.fetch(request)
//        } catch{
//            print("Error fetching data from contet \(error)")
//        }
//print(todoItems[indexPath.row])
//BUG: Habia puesto la de DidDeselectedRowAt entonces esto me generaba un delay de un evento
//cada vez que lo presionaba
//This deselect the gray shadow when the user tap the cellrow
//
//        context.delete(todoItems[indexPath.row])
//        todoItems.remove(at: indexPath.row)

//       todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//        saveItems()
