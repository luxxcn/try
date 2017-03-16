//
//  HeroDetailConfiguration.swift
//  SuperDB
//
//  Created by 星 鲁 on 2017/3/13.
//  Copyright © 2017年 xxing. All rights reserved.
//

import UIKit

class ManagedObjectConfiguration: NSObject {
    
    var sections:Array<Any>?
    
    init(withResource resource: String) {
        super.init()
        
        let plistURL = Bundle.main.url(forResource: resource, withExtension: "plist")
        let plist = NSDictionary(contentsOf: plistURL!)
        self.sections = plist?.value(forKey: "sections") as? Array<Any>
    }
    
    func isDynamic(section: Int) -> Bool {
        
        let sectionDict = self.sections?[section] as? Dictionary<String, Any>
        if let dynamicNumber = sectionDict?["dynamic"] {
            return dynamicNumber as! Bool
        }
        return false
    }
    
    func numberOfSections() -> Int {
        
        return (self.sections?.count)!
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        
        let section = self.sections?[section] as? Dictionary<String, Any>
        let rows = section?["rows"] as? Array<Any>
        return rows != nil ? rows!.count : 0
    }
    
    func herder(forSection section: Int) -> String? {
        
        let section = self.sections?[section] as? Dictionary<String, Any>
        return section?["header"] as? String
    }
    
    func row(forIndexPath indexPath: IndexPath) -> Dictionary<String, Any> {
        
        let sectionIndex = indexPath.section
        let rowIndex = self.isDynamic(section: indexPath.section) ? 0 : indexPath.row
        
        let section = self.sections?[sectionIndex] as! Dictionary<String, Any>
        let rows = section["rows"] as! Array<Any>
        let row = rows[rowIndex] as! Dictionary<String, Any>
        
        return row
    }
    
    func className(forIndexPath indexPath: IndexPath) -> String {
        
        let row = self.row(forIndexPath: indexPath)
        return row["class"] as! String
    }
    
    func values(forIndexPath indexPath: IndexPath) -> Array<Any>? {
        
        let row = self.row(forIndexPath: indexPath)
        return row["values"] as? Array<Any>
    }
    
    func dynamicAtrributeKey(forSection section: Int) -> String? {
        
        if self.isDynamic(section: section) == false {
            return nil
        }
        
        let indexPath = IndexPath(row: 0, section: section)
        return self.attributeKey(forIndexPath: indexPath)
    }
    
    func attributeKey(forIndexPath indexPath: IndexPath) -> String {
        
        let row = self.row(forIndexPath: indexPath)
        return row["key"] as! String
    }
    
    func label(forIndexPath indexPath: IndexPath) -> String {
        
        let row = self.row(forIndexPath: indexPath)
        return row["label"] as! String
    }

}
