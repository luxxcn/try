//
//  SuperDBEditCell.swift
//  SuperDB
//
//  Created by 星 鲁 on 2017/3/2.
//  Copyright © 2017年 xxing. All rights reserved.
//

import UIKit

class SuperDBEditCell: SuperDBCell, UITextFieldDelegate {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.textField?.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.textField?.isEnabled = editing
    }
    
    override func isEditable() -> Bool {
        return true
    }
    
    // MARK -  UITextFieldDelegate methods
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.validate()
    }
}
