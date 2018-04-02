//
//  SwipeTableViewController.swift
//  Todos
//
//  Created by Chaofan Zhang on 2018/3/30.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Register in code, or specify SwipeCellKit/SwipeTableViewCell in Storyboard.
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: cellIdentifier())
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier(), for: indexPath) as! SwipeTableViewCell

        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.onDeleteCell(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = SwipeExpansionStyle.destructive
        options.transitionStyle = SwipeTransitionStyle.border
        return options
    }
    
    
    func cellIdentifier() -> String {
        preconditionFailure("This method must be overriden in a subclass")
    }
    
    func onDeleteCell(at indexPath: IndexPath) {
        preconditionFailure("This method must be overriden in a subclass")
    }

}
