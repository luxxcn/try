//
//  HeroDetailControllerViewController.swift
//  SuperDB
//
//  Created by 星 鲁 on 2017/3/16.
//  Copyright © 2017年 xxing. All rights reserved.
//

import UIKit
import CoreData

class HeroDetailController: ManagedObjectController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.config = ManagedObjectConfiguration(withResource: "HeroDetailConfiguration")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.removeRelationshipObject(inIndexPath: indexPath)
        } else if editingStyle == .insert {
            
            let newObject = self.addRelationshipObject(forSection: indexPath.section)
            self.performSegue(withIdentifier: "PowerViewSegue", sender: newObject)
        }
        
        super.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let key = self.config?.attributeKey(forIndexPath: indexPath)
        let entity = self.managedObject?.entity
        let property = entity?.propertiesByName[key!]
        
        if property is NSAttributeDescription {
            
            let relationshipSet = self.managedObject?.mutableSetValue(forKey: key!)
            let relationshipObject = relationshipSet?.allObjects[indexPath.row] as? NSManagedObject
            self.performSegue(withIdentifier: "PowerViewController", sender: relationshipObject)
        } else if property is NSFetchedPropertyDescription {
            
            let fetchedProperties = self.managedObject?.value(forKey: key!)
            self.performSegue(withIdentifier: "ReportViewSegue", sender: fetchedProperties)
        }
        
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "PowerViewController" {
            
            if sender is NSManagedObject {
                let powerController = segue.destination as? ManagedObjectController
                powerController?.managedObject = sender as! NSManagedObject?
            }
        } else if segue.identifier == "ReportViewSegue" {
            
            if sender is Array<Any?> {
                let reportController = segue.destination as? HeroReportController
                reportController?.heros = sender as? Array<Hero>
            }
        } else {
            
            let alert = UIAlertController(title: "Power Error",
                                          message: "Error trying to show power controller",
                                          preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Aw, Nuts", style: .cancel, handler: nil)
            alert.addAction(cancelButton)
            self.show(alert, sender: self)
        }
    }

}
