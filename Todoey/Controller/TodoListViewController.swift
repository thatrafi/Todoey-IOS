//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    
    //let defaults = UserDefaults.standard // UserDefaults()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let items = defaults.array(forKey: "TodoeyAppItem") as? [Item] {
//            itemArray = items
//        }
        
        loadItems()
        
    }
    
    // tableview Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoitemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
        
    }
    
    // tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // to give checkmark when get touched
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
        // to animate when the item is touched
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add To Do
    
    @IBAction func addTodo(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        // show pop up
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when the user clicks add item button
            if let newItem = textField.text{
                let item = Item(context: <#T##NSManagedObjectContext#>)
                self.itemArray.append(item)
                self.saveItems()
            }
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new item..."
            textField = alertTextfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems()  {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(itemArray)
            do {
                try data.write(to: dataFilePath!)
                tableView.reloadData()
            } catch {
                print("Can't Write File \(error)")
            }
        } catch  {
            print("Error Encode Data \(error)")
        }
    }
    
    func loadItems()  {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                let items = try decoder.decode([Item].self, from: data)
                itemArray = items
            } catch  {
                print("Error while decoding data \(error)")
            }
        }
    }
    

}



