//
//  TodoTableViewController.swift
//  Todos
//
//  Created by Chaofan Zhang on 28/03/2018.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import UIKit

class TodoTableViewController_PropertyList: UITableViewController {
    
    let todoPlist = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent("todos.plist")
    var todoArray = [TodoItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        print("todoPlist: \(todoPlist)")
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? ".documentDirectory Not found")
        restoreTodos()
    }
    
    

    // MARK: - Persist/Restore todoPlist
    func persistTodos() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(todoArray)
            try data.write(to: todoPlist)
            print("persist todos")
        } catch {
            print("persist todos failed", error)
        }
    }
    
    func restoreTodos() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: todoPlist)
            todoArray = try decoder.decode([TodoItem].self, from: data)
            print("restore todos")
        } catch {
            print("restore todos failed", error)
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
            self.todoArray.append(TodoItem(title: todoTextField!.text!))
            self.tableView.reloadData()
            self.persistTodos()
            print("Add new todo")
        })
        
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }
}
