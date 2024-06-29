//
//  UIview.swift
//  JXRtc
//
//  Created by qicaiyuan on 2024/6/28.
//

import Foundation

protocol NibLoadable {
}
extension NibLoadable where Self : UIView {
    //在协议里面不允许定义class 只能定义static
    static func loadFromNib(_ nibname: String? = nil ) -> Self {
        //Self (大写) 当前类对象 //self(小写) 当前对象
        let loadName = nibname == nil ? "\(self)" : nibname!
//        Bundle.main.loadNibNamed("PrepareView", owner: self, options: nil)
        let view = Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
        view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        return view
    }
    static func viewFromNib(_ nibname: String? = nil ) -> Self {
        return loadFromNib(nibname)
    }
}
extension UIView :NibLoadable{}
