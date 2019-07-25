//
//  ViewController.swift
//  Memo
//
//  Created by Darius Turner on 7/21/19.
//  Copyright © 2019 Darius Turner. All rights reserved.
//

import UIKit
import CoreData

class MemoListViewController: UITableViewController {
    
    var itemArray = [Memo]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Memos.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
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
                
                let newMemo = Memo(context: self.context)
                
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
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
        
    }
    
    func loadMemos(with request: NSFetchRequest<Memo> = Memo.fetchRequest()) {
//        let request : NSFetchRequest<Memo> = Memo.fetchRequest()
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        tableView.reloadData()
    }
    

}


//MARK - Search Bar Methods

extension MemoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Memo> = Memo.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadMemos(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadMemos()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
