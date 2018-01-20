//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Hitender Thejaswi on 1/18/18.
//  Copyright © 2018 Hitender Thejaswi. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var catArray : Results<Category>?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = catArray?[indexPath.row].name ?? "No Categories created yet"
        
        return cell
    }
    
    //MARK:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toItem", sender: self)
    }
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = catArray?[indexPath.row]
        }
    }
    
    
    //MARK: - Add new category
    @IBAction func catAddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "Add the category name for your To Do List", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCat = Category()
            newCat.name = textField.text!
            
            //self.catArray.append(newCat)
            
            self.saveData(category: newCat)
            
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create a category name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Save the data
    
    func saveData(category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
                
            }
        }
        catch {
            print(error)
        }
        tableView.reloadData()
        
    }
    
    
    //MARK:- Load the data
    
    func loadData() {
        
         catArray = realm.objects(Category.self)
        

        tableView.reloadData()
    }
    

    
}


























