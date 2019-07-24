//
//  ViewController.swift
//  Memo
//
//  Created by Darius Turner on 7/21/19.
//  Copyright © 2019 Darius Turner. All rights reserved.
//

import UIKit

class MemoListViewController: UITableViewController {
    
    var itemArray = [Memo]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memo1 = Memo()
        memo1.title = "First Memo"
        itemArray.append(memo1)
        
        if let memos = defaults.array(forKey: "MemoListArray") as? [Memo] {
            itemArray = memos
        }
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoItemCell", for: indexPath)
        
        let memo = itemArray[indexPath.row]
        
        cell.textLabel!.text = memo.title
        
        cell.accessoryType = memo.done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
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
                
                let newMemo = Memo()
                newMemo.title = memoTextField.text!
                newMemo.done = false
                
                self.itemArray.append(newMemo)
                
                self.defaults.set(self.itemArray, forKey: "MemoListArray")
            
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

