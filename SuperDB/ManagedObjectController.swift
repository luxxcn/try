//
//  HeroDetailController.swift
//  SuperDB
//
//  Created by 星 鲁 on 2017/3/2.
//  Copyright © 2017年 xxing. All rights reserved.
//

import UIKit
import CoreData

class ManagedObjectController: UITableViewController {
    
    var config:ManagedObjectConfiguration?
    var managedObject:NSManagedObject?
    
    var saveButton:UIBarButtonItem?
    var backButton:UIBarButtonItem?
    var cancelButton:UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.backButton = self.navigationItem.leftBarButtonItem
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(save))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        self.tableView.beginUpdates()
        self.updateDynamicSections(editing)
        super.setEditing(editing, animated: animated)
        self.tableView.endUpdates()
        
        self.navigationItem.rightBarButtonItem = editing ? saveButton : self.editButtonItem
        self.navigationItem.leftBarButtonItem = editing ? cancelButton : backButton
    }
    
    func updateDynamicSections(_ editing: Bool) {
        
        for section in 0..<(self.config?.numberOfSections())! {
            
            if (self.config?.isDynamic(section: section))! {
                
                let row = self.tableView(self.tableView, numberOfRowsInSection: section)
                if editing {
                    let indexPath = IndexPath(row: row, section: section)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                } else {
                    let indexPath = IndexPath(row: row - 1, section: section)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                
            }
        }
    }
    
    // MARK: - (private) Instance Methods
    
    func save() {
        
        self.setEditing(false, animated: true)
        
        for cell in (self.tableView?.visibleCells)! {
            
            if (cell as! SuperDBCell).isEditable() {
            self.managedObject?.setValue((cell as! SuperDBCell).value,
                                forKey: (cell as! SuperDBCell).key!)
            }
        }
        
        self.saveManagedObjectContext()
    }
    
    func cancel() {
        
        self.setEditing(false, animated: true)
    }
    
    func saveManagedObjectContext() {
        
        do {
            try self.managedObject?.managedObjectContext?.save()
        } catch {
            
            let alert = UIAlertController(title: "Error saving entity",
                                          message: String(format: "Error was %@ quitting",
                                                          error.localizedDescription),
                                          preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Aw, Nuts", style: .cancel, handler: nil)
            alert.addAction(cancelButton)
            self.show(alert, sender: self)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (config?.numberOfSections())!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if (config?.isDynamic(section: section))! {
            
            let key = self.config?.dynamicAtrributeKey(forSection: section)
            let attributeSet = self.managedObject?.mutableSetValue(forKey: key!)
            return self.isEditing ? attributeSet!.count + 1 : attributeSet!.count
        }
        return (config?.numberOfRows(inSection: section))!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return config?.herder(forSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cellIdentifier = "HeroDetailCell"
        
        // Configure the cell...
        
        let cellClassName = self.config?.className(forIndexPath: indexPath)
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellClassName!) as! SuperDBCell?
        
        if cell == nil {
            
            let cellClass = NSClassFromString("SuperDB." + cellClassName!) as! SuperDBCell.Type
            //cell = cellClass
            cell = cellClass.init()
            cell?.hero = self.managedObject as! Hero?
        }
        
        if let values = self.config?.values(forIndexPath: indexPath) as! Array<String>? {
            (cell as! SuperDBPickerCell).values = values
        }
        
        cell?.label?.text = self.config?.label(forIndexPath: indexPath)
        //cell?.value = self.hero?.value(forKey: self.config.attributeKey(forIndexPath: indexPath))
        cell?.key = self.config?.attributeKey(forIndexPath: indexPath)
        
        if (self.config?.isDynamic(section: indexPath.section))! {
            
            let key = self.config?.attributeKey(forIndexPath: indexPath)
            let relationshipSet = self.managedObject?.mutableSetValue(forKey: key!)
            let relationshipArray = relationshipSet?.allObjects
            
            if indexPath.row != relationshipArray?.count {
                
                let relationshipObject = relationshipArray?[indexPath.row] as? NSManagedObject
                cell?.value = relationshipObject?.value(forKey: "name")
                cell?.accessoryType = .detailDisclosureButton
                cell?.editingAccessoryType = .detailDisclosureButton
            } else {
                cell?.label?.text = nil
                cell?.textField?.text = "Add New Power..."
            }
        } else {
            
            let value = self.config?.row(forIndexPath: indexPath)["value"]
            if value != nil {
                
                cell?.value = value
                cell?.accessoryType = .detailDisclosureButton
                cell?.editingAccessoryType = .detailDisclosureButton
            } else {
                cell?.value = self.managedObject?.value(forKey:
                    (self.config?.attributeKey(forIndexPath: indexPath))!)
            }
        }

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        
        var style:UITableViewCellEditingStyle = .none
        
        let section = indexPath.section
        if (self.config?.isDynamic(section: section))! {
            
            let rowCount = self.tableView(self.tableView, numberOfRowsInSection: section)
            if indexPath.row == rowCount - 1 {
                style = .insert
            } else {
                style = .delete
            }
        }
        
        return style
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            tableView.insertRows(at: [indexPath], with: .automatic)
        }    
    }
    
    func addRelationshipObject(forSection section: Int) -> NSManagedObject {
        
        let key = self.config?.dynamicAtrributeKey(forSection: section)
        let relationshipSet = self.managedObject?.mutableSetValue(forKey: key!)
        
        let entity = self.managedObject?.entity
        let relationships = entity?.relationshipsByName
        let destRelationship = relationships?[key!]
        let destEntity = destRelationship?.destinationEntity
        
        let relationshipObject =
            NSEntityDescription.insertNewObject(forEntityName: (destEntity?.name)!,
                                                into: (self.managedObject?.managedObjectContext)!)
        relationshipSet?.add(relationshipObject)
        
        self.saveManagedObjectContext()
        
        return relationshipObject
    }
    
    func removeRelationshipObject(inIndexPath indexPath: IndexPath) {
        
        let key = self.config?.dynamicAtrributeKey(forSection: indexPath.section)
        let relationshipSet = self.managedObject?.mutableSetValue(forKey: key!)
        let relationshipObject = relationshipSet?.allObjects[indexPath.row]
        relationshipSet?.remove(relationshipObject!)
        self.saveManagedObjectContext()
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
