//
//  HeroDetailController.swift
//  SuperDB
//
//  Created by 星 鲁 on 2017/3/2.
//  Copyright © 2017年 xxing. All rights reserved.
//

import UIKit
import CoreData

class HeroDetailController: UITableViewController {
    
    var sections:Array<Any>?
    var hero:Hero?
    
    var saveButton:UIBarButtonItem?
    var backButton:UIBarButtonItem?
    var cancelButton:UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let plistURL = Bundle.main.url(forResource: "HeroDetailConfiguration", withExtension: "plist")
        let plist = NSDictionary(contentsOf: plistURL!)
        sections = plist?.value(forKey: "sections") as! Array<Any>?
        
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
        
        super.setEditing(editing, animated: animated)
        
        self.navigationItem.rightBarButtonItem = editing ? saveButton : self.editButtonItem
        self.navigationItem.leftBarButtonItem = editing ? cancelButton : backButton
    }
    
    // MARK: - (private) Instance Methods
    
    func save() {
        
        self.setEditing(false, animated: true)
        
        for cell in (self.tableView?.visibleCells)! {
            
            if (cell as! SuperDBCell).isEditable() {
            self.hero?.setValue((cell as! SuperDBCell).value,
                                forKey: (cell as! SuperDBCell).key!)
            }
        }
        
        do {
            try self.hero?.managedObjectContext?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func cancel() {
        
        self.setEditing(false, animated: true)
    }

    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cellIdentifier = "HeroDetailCell"
        
        // Configure the cell...
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        
        let section = self.sections?[sectionIndex] as! Dictionary<String, Any>
        let rows = section["rows"] as! Array<Any>
        let row = rows[rowIndex] as! Dictionary<String, Any>
        
        let cellClassName = row["class"] as! String
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellClassName) as! SuperDBCell?
        
        if cell == nil {
            
            let cellClass = NSClassFromString("SuperDB." + cellClassName) as! SuperDBCell.Type
            //cell = cellClass
            cell = cellClass.init()
            cell?.hero = self.hero
        }
        
        if let values = row["values"] as! Array<String>? {
            (cell as! SuperDBPickerCell).values = values
        }
        
        cell?.label?.text = row["label"] as! String?
        cell?.value = self.hero?.value(forKey: row["key"] as! String)
        cell?.key = row["key"] as! String?

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return .none
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
