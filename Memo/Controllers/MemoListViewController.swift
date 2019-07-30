//
//  ViewController.swift
//  Memo
//
//  Created by Darius Turner on 7/21/19.
//  Copyright © 2019 Darius Turner. All rights reserved.
//

import UIKit
import RealmSwift

class MemoListViewController: UITableViewController {
    
    var toDoMemos : Results<Memo>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadMemos()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoMemos?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoItemCell", for: indexPath)
        
        if let memo = toDoMemos?[indexPath.row] {
            cell.textLabel?.text = memo.title
            cell.accessoryType = memo.done ? .checkmark : .none
        } else {
           cell.textLabel?.text = "No Memos Added"
        }
        
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let memo = toDoMemos?[indexPath.row] {
            do {
                try realm.write {
                    memo.done = !memo.done
                }
            } catch {
                print("Error saving done property, \(error)")
            }
        }
        
        tableView.reloadData()
        
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
                
                if let currentCategory = self.selectedCategory {
                    do {
                        
                        try self.realm.write {
                        let newMemo = Memo()
                        newMemo.title = memoTextField.text!
                        currentCategory.memos.append(newMemo)
                            
                        }
                    } catch {
                        print("Error saving new memos, \(error)")
                    }
                }
                    
                    self.tableView.reloadData()
                
            }
            
        }
        
        addItemAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new memo"
            memoTextField = alertTextField
        }
        
        addItemAlert.addAction(addItemAction)
        self.present(addItemAlert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manipulation Methods
    
    
    func loadMemos() {
        
        toDoMemos = selectedCategory?.memos.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    

}


//MARK - Search Bar Methods

//extension MemoListViewController : UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request : NSFetchRequest<Memo> = Memo.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadMemos(with: request, predicate: predicate)
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text?.count == 0 {
//            loadMemos()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
//
//}
