//
//  SuperDBColorCell.swift
//  SuperDB
//
//  Created by 星 鲁 on 2017/3/12.
//  Copyright © 2017年 xxing. All rights reserved.
//

import UIKit

class SuperDBColorCell: SuperDBEditCell {
    
    var colorPicker:UIColorPicker?
    var attributedColorString:NSAttributedString? {
        
        let block = String(utf8String:
            "\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}")
        let color = self.colorPicker?.color
        let attrs = [NSForegroundColorAttributeName:color,
                     NSFontAttributeName:UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)]
        let attributedString = NSAttributedString(string: block!, attributes: attrs)
        return attributedString
    }
    
    override var value:Any? {
        get {
            return colorPicker?.color
        }
        set {
            
            if newValue != nil && newValue is UIColor {
                
                super.value = newValue
                self.colorPicker?.color = newValue as? UIColor
            } else {
                self.colorPicker?.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            self.textField?.attributedText = self.attributedColorString
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.colorPicker = UIColorPicker(
            frame: CGRect(x: 0, y: 0, width: 320, height: 216))
        self.colorPicker?.addTarget(
            self, action: #selector(colorPickerChanged(_:)), for: .valueChanged)
        self.textField?.inputView = self.colorPicker
        self.textField?.clearButtonMode = .never
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK - (Private) Instance Methods
    
    func colorPickerChanged(_ sender: Any?) {
        self.textField?.attributedText = self.attributedColorString
    }

}
