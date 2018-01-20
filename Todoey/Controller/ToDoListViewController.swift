//
//  ViewController.swift
//  Todoey
//
//  Created by Hitender Thejaswi on 1/13/18.
//  Copyright © 2018 Hitender Thejaswi. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    //Declare the Item Array
    var itemArray : Results<Item>?
    
    //Initialize Realm
    let realm = try! Realm()
    
    //Declare the selected Category which will be initialized only when it gets a value from the other VC.
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        }

    
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            //Ternany Operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
                
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items added"
        }
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray?.count ?? 1
    
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            
            do {
               try realm.write {
                item.done = !item.done
                
                }
            } catch {
                print("Error saving done status, \(error)")
            }
            
        }
        
        tableView.reloadData()
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//
//        saveData()
//
        
        //To Enable flashing of the cell when selected instead of contunous highlighting.
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
    
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
    
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new Items, \(error)")
                }
                
            }
            
            
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new ToDoey item"
            textField = alertTextField

        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadItems() {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }

//MARK: - Search Bar Implementation.

//extension ToDoListViewController : UISearchBarDelegate {
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        
//        //1. Read the context
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        
//        //2. Modify our request using predicate
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        
//        //3. Add this predicate to the request
//        //request.predicate = predicate
//        
//        //4. Sort the results from my request to be displayed in the TableView
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        
//        //5. Add this sort descriptor to the request
//        request.sortDescriptors = [sortDescriptor]
//        
//        loadItems(with : request , predicate : predicate)
//        
//        tableView.reloadData()
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        if searchBar.text?.count == 0 {
//            
//            loadItems()
//            
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//            
//        }
//    }
    
}





























