//
//  SuperDBPickerCell.swift
//  SuperDB
//
//  Created by 星 鲁 on 2017/3/5.
//  Copyright © 2017年 xxing. All rights reserved.
//

import UIKit

class SuperDBPickerCell: SuperDBEditCell,UIPickerViewDelegate, UIPickerViewDataSource {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var pickerView:UIPickerView?
    var values:Array<String>?
    
    override var value:Any? {
        set (newValue) {
            if newValue != nil {
                let index = values?.index(of: newValue as! String)
                if index != nil {
                    textField?.text = newValue as! String?
                    pickerView?.selectRow(index!, inComponent: 0, animated: true)
                }
            } else {
                textField?.text = values?[0]// 至少一个选项
            }
        }
        get {
            return textField?.text
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField?.clearButtonMode = .never
        pickerView = UIPickerView(frame: CGRect.zero)
        pickerView?.dataSource = self
        pickerView?.delegate = self
        textField?.inputView = pickerView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK - UIPickerViewDataSource Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (values?.count)!
    }
    
    // MARK - UIPickerViewDelegate Methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.value = values?[row]
    }

}
