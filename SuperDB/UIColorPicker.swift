//
//  UIColorPicker.swift
//  SuperDB
//
//  Created by 星 鲁 on 2017/3/12.
//  Copyright © 2017年 xxing. All rights reserved.
//

import UIKit
import QuartzCore.CAGradientLayer

class UIColorPicker: UIControl {
    
    let kTopBackgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
    let kBottomBackgroundColor = UIColor(red: 0.79, green: 0.79, blue: 0.79, alpha: 1.0)
    
    
    private var redSlider:UISlider?
    
    private var greenSlider:UISlider?
    private var blueSlider:UISlider?
    private var alphaSlider:UISlider?
    
    private var _color:UIColor?
    var color:UIColor? {
        set {
            _color = newValue
            let components = newValue?.cgColor.components
            redSlider?.setValue(Float(components![0]), animated: true)
            greenSlider?.setValue(Float(components![1]), animated: true)
            blueSlider?.setValue(Float(components![2]), animated: true)
            alphaSlider?.setValue(Float(components![3]), animated: true)
        }
        
        get {
            return _color
        }
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [kTopBackgroundColor.cgColor, kBottomBackgroundColor.cgColor]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.autoresizingMask = .flexibleHeight// | .flexibleWidth
        
        self.addSubview(
            self.labelWithFrame(CGRect(x: 20.0, y: 40, width: 60, height: 24),
                                text: "Red"))
        self.addSubview(
            self.labelWithFrame(CGRect(x: 20.0, y: 80, width: 60, height: 24),
                                text: "Green"))
        self.addSubview(
            self.labelWithFrame(CGRect(x: 20.0, y: 120, width: 60, height: 24),
                                text: "Blue"))
        self.addSubview(
            self.labelWithFrame(CGRect(x: 20.0, y: 160, width: 60, height: 24),
                                text: "Alpha"))
        
        redSlider = UISlider(frame: CGRect(x: 100, y: 40, width: 190, height: 24))
        greenSlider = UISlider(frame: CGRect(x: 100, y: 80, width: 190, height: 24))
        blueSlider = UISlider(frame: CGRect(x: 100, y: 120, width: 190, height: 24))
        alphaSlider = UISlider(frame: CGRect(x: 100, y: 160, width: 190, height: 24))
        
        redSlider?.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        greenSlider?.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        blueSlider?.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        alphaSlider?.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        
        self.addSubview(redSlider!)
        self.addSubview(greenSlider!)
        self.addSubview(blueSlider!)
        self.addSubview(alphaSlider!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        //self.frame = (newSuperview?.bounds)!
    }
    
    // MARK - (Private) Instance Methods
    
    func sliderChanged(_ sender: Any?) {
        
        _color = UIColor(red: CGFloat((redSlider?.value)!),
                         green: CGFloat((greenSlider?.value)!),
                         blue: CGFloat((blueSlider?.value)!),
                         alpha: CGFloat((alphaSlider?.value)!))
        
        self.sendActions(for: .valueChanged)
    }
    
    func labelWithFrame(_ frame: CGRect, text: String?) -> UILabel {
        
        let label = UILabel(frame: frame)
        label.isUserInteractionEnabled = false
        label.backgroundColor = UIColor.clear
        label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        label.textAlignment = .right
        label.textColor = UIColor.darkText
        label.text = text
        return label
    }

}
