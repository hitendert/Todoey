//
//  ViewController.swift
//  Todoey
//
//  Created by Hitender Thejaswi on 1/13/18.
//  Copyright © 2018 Hitender Thejaswi. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loadItems()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        }

    
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
//        cell.textLabel?.text = itemArray[indexPath.row]
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        //Ternany Operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
 //     The below code is commented as we are achieving the same thing with just one line above.
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveData()
        
        
        
//        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark)
//        {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        
        //To Enable flashing of the cell when selected instead of contunous highlighting.
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
    
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
    
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
//            self.itemArray.append(textField.text!)
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            self.saveData()
           
            
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new ToDoey item"
            textField = alertTextField

        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        
        
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    // The parameters in the below func in a refactored and improved upon code.
    // Look at previous commits of the code to get the simpler version.
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        
//        let predicate = NSPredicate(format: "toParentCategory MATCHES %@", (selectedCategory?.name)!)
//
//        request.predicate = predicate

            do {
            itemArray = try context.fetch(request)
            } catch {
                print(error)
            }
        
        tableView.reloadData()

    }

}


//MARK: - Search Bar Implementation.

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //1. Read the context
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //2. Modify our request using predicate
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //3. Add this predicate to the request
        request.predicate = predicate
        
        //4. Sort the results from my request to be displayed in the TableView
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        //5. Add this sort descriptor to the request
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with : request)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}





























