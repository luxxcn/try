//
//  MapLocation.swift
//  MapMe
//
//  Created by 星 鲁 on 2017/5/2.
//  Copyright © 2017年 xxing. All rights reserved.
//

import UIKit
import MapKit

class MapLocation: NSObject, MKAnnotation, NSCoding {
    
    var street:String?
    var city:String?
    var state:String?
    var zip:String?
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    override init() {
        
        //super.init()
    }
    
    //MARK - MKAnnotation Protocol Methods
    var title: String? {
        
        return "You are Here!"
    }
    
    var subtitle: String? {
        
        var result = ""
        
        if self.street != nil {
            
            result.append(self.street!)
        }
        
        if self.street != nil &&
            (self.city != nil || self.state != nil || self.zip != nil) {
            result.append(", ")
        }
        
        if self.city != nil {
            
            result.append(self.city!)
        }
        
        if self.city != nil && self.state != nil {
            result.append(", ")
        }
        
        if self.state != nil {
            
            result.append(self.state!)
        }
        
        if self.zip != nil {
            
            result.append(String(format:" %@", self.zip!))
        }
        
        return result
    }
    
    //MARK - NSCoder Protocol Methods
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.street, forKey: "street")
        aCoder.encode(self.city, forKey: "city")
        aCoder.encode(self.state, forKey: "state")
        aCoder.encode(self.zip, forKey: "zip")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        self.street = aDecoder.decodeObject(forKey: "street") as? String
        self.city = aDecoder.decodeObject(forKey: "city") as? String
        self.state = aDecoder.decodeObject(forKey: "state") as? String
        self.zip = aDecoder.decodeObject(forKey: "zip") as? String
    }

}
