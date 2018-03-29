//
//  TodoTableViewController.swift
//  Todos
//
//  Created by Chaofan Zhang on 28/03/2018.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import UIKit
import CoreData

class TodoTableViewController_CoreData: UITableViewController {

    var category: CDCategory!
    var todoArray = [CDTodoItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        print(".documentDirectory:", NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? ".documentDirecotry not found")
        loadTodos()
    }


    // MARK: - Persist/Restore todoPlist
    func persistTodos() {
        do {
            try gPersistentContainerContext.save()
        } catch {
            print("Persist data failed \(error)")
        }
    }
    
    func loadTodos(with request: NSFetchRequest<CDTodoItem> = CDTodoItem.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category.name!)
        if let predicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            todoArray = try gPersistentContainerContext.fetch(request)
        } catch {
            print("load data failed \(error)")
        }
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell")!
        let todoItem = todoArray[indexPath.row]
        cell.textLabel!.text = todoItem.title
        cell.accessoryType = todoItem.done ? UITableViewCellAccessoryType.checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todoItem = todoArray[indexPath.row]
        todoItem.done = !todoItem.done
        tableView.cellForRow(at: indexPath)?.accessoryType = todoItem.done ? UITableViewCellAccessoryType.checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
        persistTodos()
    }

    // MARK: - New Todo
    @IBAction func onNewTodoItem(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Todo", message: nil, preferredStyle: .alert)
        
        var todoTextField: UITextField? = nil
        alertController.addTextField { (textField) in
            textField.placeholder = "Your new todo"
            todoTextField = textField
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { (_) in
            let item = CDTodoItem(context: gPersistentContainerContext)
            item.title = todoTextField!.text!
            item.parentCategory = self.category
            self.todoArray.append(item)
            self.tableView.reloadData()
            self.persistTodos()
            print("Add new todo")
        })
        
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension TodoTableViewController_CoreData: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Searching for \(searchBar.text!)")
        let request: NSFetchRequest<CDTodoItem> = CDTodoItem.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadTodos(with: request, predicate: predicate)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadTodos()
            tableView.reloadData()
            // MARK: Don't quite understand, but to close the keyboard here, must use DispatchQueue.main thread.
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
