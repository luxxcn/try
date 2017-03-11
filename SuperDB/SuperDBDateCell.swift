//
//  SuperDBDateCell.swift
//  SuperDB
//
//  Created by 星 鲁 on 2017/3/5.
//  Copyright © 2017年 xxing. All rights reserved.
//

import UIKit

class SuperDBDateCell: SuperDBEditCell {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    static let __dateFormatter = DateFormatter()
    
    var datePicker:UIDatePicker?
    
    override var value: Any? {
        set (newValue) {
            
            if newValue != nil && newValue is NSDate {
                let date = newValue as! Date
                textField?.text = SuperDBDateCell.__dateFormatter.string(from: date)
                datePicker?.date = date
            } else {
                textField?.text = SuperDBDateCell.__dateFormatter.string(from: Date())
            }
        }
        get {
            if textField?.text == nil || textField?.text?.characters.count == 0 {
                return nil
            }
            return datePicker?.date
        }
    }
    
    override class func initialize() {
        
        __dateFormatter.dateStyle = .medium
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField?.clearButtonMode = .never
        datePicker = UIDatePicker(frame: CGRect.zero)
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        textField?.inputView = datePicker
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Instance Methods
    
    func datePickerChanged() {
        
        self.validate()
        self.value = datePicker?.date
    }
}
