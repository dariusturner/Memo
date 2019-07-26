//
//  CategoryViewController.swift
//  Memo
//
//  Created by Darius Turner on 7/25/19.
//  Copyright © 2019 Darius Turner. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel!.text = categories[indexPath.row].name
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToMemos", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MemoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    //MARK - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Higher scope variable to hold alertTextField's text
        var categoryTextField = UITextField()
        
        //Error Alert
        let textErrorAlert = UIAlertController(title: "Error", message: "Please add some text to your memo", preferredStyle: .alert)
        let textErrorAlertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        //Add Item Alert
        let addItemAlert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let addItemAction = UIAlertAction(title: "Add Category", style: .default) { (UIAlertAction) in
            
            //What will happen when a user clicks on Add Memo
            
            if categoryTextField.text == nil || categoryTextField.text == "" {
                
                textErrorAlert.addAction(textErrorAlertAction)
                self.present(textErrorAlert, animated: true, completion: nil)
                
            } else {
                
                let newCategory = Category(context: self.context!)
                
                newCategory.name = categoryTextField.text!
                
                self.categories.append(newCategory)
                self.saveCategories()
                
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
    
    func saveCategories() {
        do {
            try context!.save()
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context!.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        tableView.reloadData()
    }
    
}
