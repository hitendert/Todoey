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
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        
        didSet {
            
            loadItems()
        }
    }
    
    var thisVCItems : Results<Item>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
            loadItems()
        
        }

    
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        cell.textLabel?.text = thisVCItems?[indexPath.row].title ?? "No items added yet"
        
        
        //Ternary Operator
        // Value = condition ? ValueIfTrue : ValueIfFalse
        cell.accessoryType = (thisVCItems?[indexPath.row].done)! ? .checkmark : .none
        
        return cell

    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return thisVCItems?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let items = thisVCItems?[indexPath.row] {
            
            do {
                try realm.write {
                    items.done = !items.done
                }
            } catch {
                print(error)
            }
            
            
        }
        
        tableView.reloadData()
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add ToDo Item", message: "Add the task you want to accomplish", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Add the task"
            textField = alertTextField
            
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    self.selectedCategory?.items.append(newItem)
                }
            } catch {
                print("Error while saving items \(error)")
            }
            
            self.tableView.reloadData()
            
        }
        
       
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    //MARK: - Save Items
    
   
    
    
    func loadItems() {
       
        thisVCItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
    }

//MARK: - Search Bar Implementation.


    
}





























