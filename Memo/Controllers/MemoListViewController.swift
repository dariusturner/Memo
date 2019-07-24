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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Memos.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMemos()
        
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
        
        self.saveMemos()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Memos
    
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
                
                self.saveMemos()
                
            }
            
        }
        
        addItemAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new memo"
            memoTextField = alertTextField
        }
        
        addItemAlert.addAction(addItemAction)
        present(addItemAlert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manipulation Methods
    
    func saveMemos() {
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding itemArray, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadMemos() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Memo].self, from: data)
            } catch {
                print("Error decoding the itemArray, \(error)")
            }
        }
        
    }
    

}

