//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Eyüp Mert on 28.12.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Change row height for be able to see delete icon.
        tableView.rowHeight = 80

    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Make cell in superclass and inherit it in necessary places. Use generic identifier.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // Get necessary indexPath from subclass and show deletion.
            self.updateModel(at: indexPath)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    // This function is used for communication to subclasses.
    func updateModel (at indexPath: IndexPath) {
        // Update model
     }

  

}
