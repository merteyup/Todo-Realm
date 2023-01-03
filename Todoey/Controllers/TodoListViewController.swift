//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    // MARK: - Variables
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    // When category selected from CategoryViewController, that's the time point to load items.
    // That's why didSet special keyword used. When optional get it's value, load items.
#warning("6. step")
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Statements
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // View loaded but TodoListViewController is not in the stack yet.
        // View did load can call before navigationController created.
        // That's why navigationController? can give fatal error in viewDidLoad.
        if let colorHex = selectedCategory?.color {
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation controller does not exist.")
            }
            title = selectedCategory!.name
            // Create color based on selectedCategory's color and use it in necessary places.
            if let navBarColor = UIColor(hexString: colorHex) {
                searchBar.barTintColor = navBarColor
                navBar.barTintColor = navBarColor
                // Create contrast color based on selected color.
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Create text field for having bigger scope to use alert's textview.
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // Check is selected category nil or not.
            // If not nil create new item in this category with title and date properties.
            // Write newItem to realm.
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error on writing item: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            // Equalize text field of alert to bigger scope textfield.
            textField = alertTextField
        }
        // Add action to alert controller and present alert.
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
    func loadItems() {
        // Loads all todo items as a collection of result Item object.
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    /// Works with superclass for be able to delete selected item.
    /// - Parameter indexPath: IndexPath of item for deletion.
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print(error)
                
            }
        }
    }
}

// MARK: - TableViewDataSource

extension TodoListViewController  {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // As many cells as todoItem count.
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell from super class.
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // If there's item, proceed.
        if let item = todoItems?[indexPath.row] {
            // Create color based on selectedCategory's color or use default value.
            let categoryColor = UIColor(hexString: selectedCategory!.color) ?? UIColor.systemBlue
            // Create darker color for every new item. First change index and count to float than use it for darken percentage.
            if let color = categoryColor.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)}
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            // If no items.
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
}

// MARK: - TableViewDelegate

extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
#warning("7. step")
        tableView.deselectRow(at: indexPath, animated: true)
        // Grab reference to item in necessary index.
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
#warning("8. step delete or update possible.")
                    // realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
    }
}


// MARK: - SearchBarDelegate

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Not even need to loadItems. Because we've already loaded them. Now we just filter them.
        // Update collection of results with filtered predicate version and sort them.
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            // Leave being first responder. No cursor, keyboard leaves. Needs to be done in main thread.
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

