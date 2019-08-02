//
//  ViewController.swift
//  Memo
//
//  Created by Darius Turner on 7/21/19.
//  Copyright © 2019 Darius Turner. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class MemoListViewController: SwipeTableTableViewController {
    
    var toDoMemos : Results<Memo>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            loadMemos()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.separatorStyle = .none
        

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name

        guard let colorHex = selectedCategory?.color else {fatalError()}
        
        updateNavBar(withHexCode: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "4FFF53")
    }
    
    //MARK - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colorHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
    }
    
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoMemos?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let memo = toDoMemos?[indexPath.row] {
            cell.textLabel?.text = memo.title
            
            if let color = (HexColor(selectedCategory!.color))!.darken(byPercentage: CGFloat(indexPath.row) / (CGFloat(toDoMemos!.count) + 10.0)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
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
                            newMemo.dateCreated = Date()
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
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let memoForDeletion = self.toDoMemos?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(memoForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
            
            tableView.reloadData()
        }
    }
    

}


//MARK - Search Bar Methods

extension MemoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoMemos = toDoMemos?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

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


