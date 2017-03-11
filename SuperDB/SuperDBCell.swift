//
//  SuperDBCell.swift
//  SuperDB
//
//  Created by 星 鲁 on 2017/3/11.
//  Copyright © 2017年 xxing. All rights reserved.
//

import UIKit

class SuperDBCell: UITableViewCell {

    let kLabelTextColor = UIColor(red: 0.321569, green: 0.4, blue: 0.568627, alpha: 1.0)
    var label:UILabel?
    var textField:UITextField?
    var hero:Hero?
    
    var key:String?
    var value:Any? {
        get {
            return textField?.text
        }
        set (newValue) {
            
            if newValue is String {
                textField?.text = newValue as! String?
            } else {
                if newValue == nil {
                    textField?.text = ""
                } else {
                    textField?.text = String(describing: newValue!)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.label = UILabel(frame: CGRect(x: 12.0, y: 15.0, width: 67.0, height: 15.0))
        self.label?.backgroundColor = UIColor.clear
        self.label?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        self.label?.textAlignment = .right
        self.label?.textColor = kLabelTextColor
        self.label?.text = "label"
        self.contentView.addSubview(self.label!)
        
        self.textField = UITextField(frame: CGRect(x: 93.0, y: 13.0, width: 170.0, height: 19.0))
        self.textField?.backgroundColor = UIColor.clear
        self.textField?.clearButtonMode = .whileEditing
        self.textField?.isEnabled = false
        self.textField?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        self.textField?.text = "Title"
        self.contentView.addSubview(self.textField!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    func validate() {
        
        var val = self.value as AnyObject?
        do {
            try self.hero?.validateValue(AutoreleasingUnsafeMutablePointer<AnyObject?>(&val), forKey: self.key!)
        } catch {
            
            var message:String?
            let error = error as NSError
            if error.domain.compare("NSCocoaErrorDomain") == .orderedSame {
                
                let userInfo = error.userInfo
                message = String(format: NSLocalizedString("Validation error on: %@\rFailure Reason: %@",
                                                           comment: "Validation error on: %@\rFailure Reason: %@"),
                                 userInfo["NSValidationErrorKey"] as! CVarArg,
                                 error.localizedFailureReason!)
            } else {
                message = error.localizedDescription
            }
            
            let alert = UIAlertController(title: NSLocalizedString("Validation Error", comment: "Validation Error"), message: message, preferredStyle: .alert)
            let fix = UIAlertAction(title: "Fix", style: .default, handler: {
                (action) in
                self.textField?.becomeFirstResponder()
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action) in
                self.value = self.hero?.value(forKey: self.key!)
            })
            alert.addAction(fix)
            alert.addAction(cancel)
            alert.show((self.window?.rootViewController)!, sender: self)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
    }
    
    func isEditable() -> Bool {
        return false
    }


}
