//
//  TodoTableViewController.swift
//  Todos
//
//  Created by Chaofan Zhang on 28/03/2018.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import UIKit
import RealmSwift

class TodoTableViewController_Realm: UITableViewController {

    let realm = try! Realm()
    var category: RealmCategory!
    var todoItems: Results<RealmItem>?

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
    func loadTodos() {
        todoItems = category.todoItems.sorted(byKeyPath: "title", ascending: true)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell")!
        if let todoItem = todoItems?[indexPath.row] {
            cell.textLabel!.text = todoItem.title
            cell.accessoryType = todoItem.done ? UITableViewCellAccessoryType.checkmark : .none
        } else {
            cell.textLabel!.text = "No items added"
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let todoItem = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    todoItem.done = !todoItem.done
                }
            } catch {
                print("Save item failed \(error)")
            }
            
            tableView.cellForRow(at: indexPath)?.accessoryType = todoItem.done ? UITableViewCellAccessoryType.checkmark : .none
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
            let item = RealmItem()
            item.title = todoTextField!.text!
            do {
                try self.realm.write {
                    self.category.todoItems.append(item)
                }
            } catch {
                print("Save item failed \(error)")
            }
            
            self.tableView.reloadData()
            print("Add new todo")
        })
        
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension TodoTableViewController_Realm: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Searching for \(searchBar.text!)")
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
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
