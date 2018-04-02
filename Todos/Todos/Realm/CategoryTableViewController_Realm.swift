//
//  CategoryTableViewController.swift
//  Todos
//
//  Created by Chaofan Zhang on 29/03/2018.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController_Realm: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories : Results<RealmCategory>?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Realm file path", realm.configuration.fileURL)
        loadCategories()
    }
    
    // MARK: - Load/Persist Data
    func loadCategories() {
        categories = realm.objects(RealmCategory.self)
    }

    // MARK: - Table View Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            cell.selectionStyle = .default
        } else {
            cell.textLabel?.text = "No categories added"
            cell.selectionStyle = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categories != nil {
            performSegue(withIdentifier: "showItems", sender: self)
        }
    }
    
    // MARK: - New Category
    @IBAction func onAddCategory(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        
        var nameTextField = UITextField()
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Category name"
            nameTextField = textField
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            let category = RealmCategory()
            category.name = nameTextField.text!
            
            do {
                try self.realm.write {
                    self.realm.add(category)
                }
            } catch {
                print("Realm write failed \(error)")
            }
            
            self.tableView.reloadData()
        }
        
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "showItems", let categories = categories {
            let destinationVC = segue.destination as! TodoTableViewController_Realm
            destinationVC.category = categories[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    // MARK: - SwipeTableViewController methods to override
    override func cellIdentifier() -> String {
        return "categoryCell"
    }
    
    override func onDeleteCell(at indexPath: IndexPath) {
        if let categoryToDelete = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryToDelete)
                }
                // Don't call reloadData() when use the .Destructive expansiveStyle, because it will try the deletion itself.
//                tableView.reloadData()
            } catch {
                print("Delete category failed")
            }
        }
    }
}
