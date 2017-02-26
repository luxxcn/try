//
//  HeroListController.swift
//  SuperDB
//
//  Created by xxing on 2017/2/26.
//  Copyright © 2017年 xxing. All rights reserved.
//

import UIKit
import CoreData

class HeroListController:
UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, NSFetchedResultsControllerDelegate {
    
    enum TabType:Int {
        case kByName = 0
        case kBySecretIdentity = 1
    }
    
    let kSelectedTabDefaultsKey = "Selected Tab"
    
    var _fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>?
    var fetchedResultController:NSFetchedResultsController<NSFetchRequestResult>? {
        get {
            if _fetchedResultsController != nil {
                return _fetchedResultsController
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Hero", in: managedObjectContext)
            let request = NSFetchRequest<NSFetchRequestResult>()
            
            request.entity = entity
            request.fetchBatchSize = 20
            
            var tabIndex = heroTabBar.items?.index(of: heroTabBar.selectedItem!)
            if tabIndex == nil {
                let defaults = UserDefaults.standard
                tabIndex = defaults.integer(forKey: kSelectedTabDefaultsKey)
            }
            
            var sectionKey:String?
            let sortDescriptor1 = NSSortDescriptor(key: "name", ascending: true)
            let sortDescriptor2 = NSSortDescriptor(key: "secretIdentity", ascending: true)
            var sortDescriptors:Array<NSSortDescriptor>?
            switch TabType(rawValue: tabIndex!)! {
            case .kByName:
                sortDescriptors = [sortDescriptor1, sortDescriptor2]
                sectionKey = "name"
            case .kBySecretIdentity:
                sortDescriptors = [sortDescriptor2, sortDescriptor1]
                sectionKey = "secretIdentity"
            }
            request.sortDescriptors = sortDescriptors!
            
            
            _fetchedResultsController =
                NSFetchedResultsController(fetchRequest: request,
                                           managedObjectContext: managedObjectContext,
                                           sectionNameKeyPath: sectionKey,
                                           cacheName: "Hero")
            _fetchedResultsController?.delegate = self
            return _fetchedResultsController
        }
    }

    @IBOutlet weak var heroTableview: UITableView!
    @IBOutlet weak var heroTabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let defaults = UserDefaults.standard
        let selectedTab = defaults.integer(forKey: kSelectedTabDefaultsKey)
        heroTabBar.selectedItem = self.heroTabBar.items?[selectedTab]
        
        // cache hero
        do {
            try fetchedResultController?.performFetch()
        } catch {
            //TODO: alert
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - NSFetchedResultsControllerDelegate Methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.heroTableview.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.heroTableview.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            self.heroTableview.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.heroTableview.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.heroTableview.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.heroTableview.deleteRows(at: [indexPath!], with: .fade)
        default:
            break
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (fetchedResultController?.sections?.count)!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let sectionInfo = fetchedResultController?.sections?[section]
        
        return (sectionInfo?.numberOfObjects)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "HeroListCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let aHero = fetchedResultController?.object(at: indexPath) as! NSManagedObject
        let tab = heroTabBar.items?.index(of: heroTabBar.selectedItem!)
        
        switch TabType(rawValue: tab!)! {
        case .kByName:
            cell.textLabel?.text = aHero.value(forKey: "name") as! String?
            cell.detailTextLabel?.text = aHero.value(forKey: "secretIdentity") as! String?
        case .kBySecretIdentity:
            cell.textLabel?.text = aHero.value(forKey: "secretIdentity") as! String?
            cell.detailTextLabel?.text = aHero.value(forKey: "name") as! String?
        }

        return cell
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let defaults = UserDefaults.standard
        let tabIndex = tabBar.items?.index(of: item)
        defaults.set(tabIndex, forKey: kSelectedTabDefaultsKey)
        
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: "Hero")
        _fetchedResultsController?.delegate = nil
        _fetchedResultsController = nil
        
        do {
            try fetchedResultController?.performFetch()
            heroTableview.reloadData()
        } catch {
            //TODO: alert
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func addHero(_ sender: Any) {
        
        let context = self.fetchedResultController?.managedObjectContext
        let entity = self.fetchedResultController?.fetchRequest.entity
        NSEntityDescription.insertNewObject(forEntityName: (entity?.name)!,
                                            into: context!)
        
        do {
            try context?.save()
        } catch {
            // TODO: alert
            print(error.localizedDescription)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        self.navigationItem.rightBarButtonItem?.isEnabled = editing
        heroTableview.setEditing(editing, animated: animated)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let managedObjectContext = fetchedResultController?.managedObjectContext
        
        if editingStyle == .delete {
            
            managedObjectContext?.delete(fetchedResultController?.object(at: indexPath) as! NSManagedObject)
            
            do {
                try managedObjectContext?.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                //TODO: alert
                print(error.localizedDescription)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
