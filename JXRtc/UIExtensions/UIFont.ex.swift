//
//  UIFont.ex.swift
//  LanMaoVoice
//
//  Created by 王翔-iOS-蓝猫网络 on 2022/4/18.
//

import UIKit
public enum FontAlias: String {
    case Regular  = "PingFangSC-Regular"
    case Medium   = "PingFangSC-Medium"
    case Light    = "PingFangSC-Light"
    case Semibold = "PingFangSC-Semibold"
    case BoldItalic = "IowanOldStyle-BoldItalic"
    case AaHouDiHei = "AaHouDiHei"
}

public extension UIFont {
    static func font(size: CGFloat, alias: FontAlias) -> UIFont {
        var diff = 0.0
        if UIScreen.main.bounds.size.width / 375.0 > 1 {
            diff = size * 1.1
        } else {
            diff = size
        }
        return UIFont(name: alias.rawValue, size: diff) ?? UIFont.systemFont(ofSize: diff)
    }
}


extension Float {
    /// 准确的小数尾截取 - 没有进位
    func decimalString(_ base: Self = 1) -> String {
        let tempCount: Self = pow(10, base)
        let temp = self*tempCount
        let target = Self(Int(temp))
        let stepone = target/tempCount
        return "\(stepone)"
    }
}

