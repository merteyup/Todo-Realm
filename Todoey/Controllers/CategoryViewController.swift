//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Eyüp Mert on 26.12.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    
    // MARK: - Variables
#warning("4. step")
    
    // Initialize new access point to realm.
    let realm = try! Realm()
    
    // Auto updating data type. Whenever update comes, it comes as a result type.
    // Collection of results which coming from realm as a Category object.
    var categories : Results<Category>?
    
    // MARK: - Statements
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // View loaded but CategoryViewController is not in the stack yet.
        // View did load can call before navigationController created.
        // That's why navigationController? can give fatal error in viewDidLoad.
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist.")
        }
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
        
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        // Create alert
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        // Create action for alert.
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // Create new category as a new Category object and give random color.
            // Than pass newCategory to save function.
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            self.save(category: newCategory)
        }
        // Add textfield to alert controller.
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            // Get alert's textfield's text and make it's scope bigger for be able to reach it in action.
            textField = alertTextField
        }
        // Add action to alert.
        alert.addAction(action)
        // Present alert.
        present(alert, animated: true)
        
    }
    
    // MARK: - Functions
    
    /// Get new category from addButtonPressed and write (commit) it to realm.
    /// - Parameter category: Category dynamic object to save.
    func save (category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
            print("Success saving category")
        } catch {
            print("Error saving category: \(error)")
        }
        self.tableView.reloadData()
    }
   
    func loadData () {
        // Not be able to cast directly to the array even if it's like an array. It's different data type and not very easily converted.
        // That's why up global we made categories as type of result.
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    /// Works with superclass for be able to delete selected category.
    /// - Parameter indexPath: IndexPath of category for deletion.
    override func updateModel(at indexPath: IndexPath) {
         if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Realm returns number of categories as number of rows. If nil;
        // Nil Coalescing Operator. If not nil use, if nil return 1.
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        // Created superclass as a SwipeTableViewController. And override it's cellForRowAt.
        // Just modify necessary areas in cell which created in SwipeTableViewController.
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // Check is category nil.
        if let category = categories?[indexPath.row] {
            // Check categoryColor can be produced by hexString.
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.text = category.name
            cell.textLabel?.textColor =  ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        return cell
    }
    
    // MARK: - TableViewDelegate
#warning("5. step")
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
}
