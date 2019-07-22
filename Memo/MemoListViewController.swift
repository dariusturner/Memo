//
//  ViewController.swift
//  Memo
//
//  Created by Darius Turner on 7/21/19.
//  Copyright © 2019 Darius Turner. All rights reserved.
//

import UIKit

class MemoListViewController: UITableViewController {
    
    var itemArray = ["Item 1", "Item 2", "Item 3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoItemCell", for: indexPath)
        
        cell.textLabel!.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        } else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Higher scope variable to hold alertTextField's text
        var memoTextField = UITextField()
        
        //Error Alert
        let textErrorAlert = UIAlertController(title: "Error", message: "Please add some text to your memo", preferredStyle: .alert)
        let textErrorAlertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        //Add Item Alert
        let addItemAlert = UIAlertController(title: "Add New Memo", message: "", preferredStyle: .alert)
        let addItemAction = UIAlertAction(title: "Add Memo", style: .default) { (UIAlertAction) in
            
            //What will happen when a user clicks on Add Memo
            
            if memoTextField.text == nil || memoTextField.text == "" {
                
                textErrorAlert.addAction(textErrorAlertAction)
                self.present(textErrorAlert, animated: true, completion: nil)
                
            } else {
                
                self.itemArray.append(memoTextField.text!)
            
                self.tableView.reloadData()
                
            }
            
        }
        
        addItemAlert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new memo"
            memoTextField = alertTextField
            
        }
        
        addItemAlert.addAction(addItemAction)
        
        present(addItemAlert, animated: true, completion: nil)
        
    }
    

}

