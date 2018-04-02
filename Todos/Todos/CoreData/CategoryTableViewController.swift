//
//  CategoryTableViewController.swift
//  Todos
//
//  Created by Chaofan Zhang on 29/03/2018.
//  Copyright © 2018 Chaofan Zhang. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [CDCategory]()
    var selectedCategory: CDCategory?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    // MARK: - Load/Persist Data
    func loadCategories(with request: NSFetchRequest<CDCategory> = CDCategory.fetchRequest()) {
        do {
            categoryArray = try gPersistentContainerContext.fetch(request)
        } catch {
            print("load categories failed \(error)")
        }
    }
    
    func persistCategories() {
        do {
            try gPersistentContainerContext.save()
        } catch {
            print("persist categories failed \(error)")
        }
    }

    // MARK: - Table View Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categoryArray[indexPath.row]
        performSegue(withIdentifier: "showItems", sender: self)
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
            let category = CDCategory(context: gPersistentContainerContext)
            category.name = nameTextField.text!
            self.categoryArray.append(category)
            self.tableView.reloadData()
            self.persistCategories()
        }
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "showItems" {
            let destinationVC = segue.destination as! TodoTableViewController_CoreData
            destinationVC.category = selectedCategory
        }
    }
}
