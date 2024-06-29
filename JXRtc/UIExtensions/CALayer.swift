//
//  CALayer.swift
//  JXRtc
//
//  Created by qicaiyuan on 2024/6/28.
//

import Foundation
import UIKit

extension CALayer {
    
    var borderColorWithUIColor : UIColor {
        
        set {
            
            self.borderColor = newValue.cgColor
            
        }
        
        get {
            
            return self.borderColorWithUIColor
        }
    }
    
}
@IBDesignable extension CALayer {
    @IBInspectable var borderUIColor: UIColor {
        get {
            return UIColor(cgColor: self.borderColor!)
        }
        set {
            self.borderColor = newValue.cgColor
        }
    }
}

