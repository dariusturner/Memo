//
//  CategoryViewController.swift
//  Memo
//
//  Created by Darius Turner on 7/25/19.
//  Copyright © 2019 Darius Turner. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableTableViewController {
    
    let realm = try! Realm()


    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none

    }

    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel!.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToMemos", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MemoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Higher scope variable to hold alertTextField's text
        var categoryTextField = UITextField()
        
        //Error Alert
        let textErrorAlert = UIAlertController(title: "Error", message: "Please name your category", preferredStyle: .alert)
        let textErrorAlertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        //Add Item Alert
        let addItemAlert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let addItemAction = UIAlertAction(title: "Add Category", style: .default) { (UIAlertAction) in
            
            //What will happen when a user clicks on Add Memo
            
            if categoryTextField.text == nil || categoryTextField.text == "" {
                
                textErrorAlert.addAction(textErrorAlertAction)
                self.present(textErrorAlert, animated: true, completion: nil)
                
            } else {
                
                let newCategory = Category()
                newCategory.name = categoryTextField.text!
                newCategory.color = RandomFlatColor().hexValue()
                
                self.save(category: newCategory)
                
            }
            
        }
        
        addItemAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            categoryTextField = alertTextField
        }
        
        addItemAlert.addAction(addItemAction)
        self.present(addItemAlert, animated: true, completion: nil)
    }
    
    //MARK - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }

            tableView.reloadData()
        }
    }
    
}

