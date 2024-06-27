//
//  MBProgressHUD.ex.swift
//  LanMaoVoice
//
//  Created by 王翔-iOS-蓝猫网络 on 2022/4/12.
//


import UIKit
import MBProgressHUD

public enum HUDPostion: Int {
    case top, center, bottom
}

public extension MBProgressHUD {

    class func tost(_ text: String) {
        show(text: text, postion: .center, to: UIApplication.shared.delegate!.window!)
    }

    class func show(text: String, postion: HUDPostion, to view: UIView?) {
        let hud = MBProgressHUD.showAdded(to: (view ?? UIApplication.shared.delegate!.window!)!, animated: true)
        hud.bezelView.style = .solidColor
        hud.bezelView.color = .init(white: 0, alpha: 0)
        hud.bezelView.layer.masksToBounds = false
        hud.isUserInteractionEnabled = false
        hud.mode = .customView

        let size = CGSize(width: UIScreen.main.bounds.width - 2*16 - 36, height: CGFloat(MAXFLOAT))
        let font = UIFont.font(size: 12, alias: .Regular)
        let rect = text.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], attributes: [.font: font], context: nil)
        hud.minSize = CGSize(width: rect.width + 36, height: 40)
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: rect.width + 36, height: rect.height > 40 ? rect.height + 20 : 40))
        textLabel.text = text
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.font = font
        textLabel.numberOfLines = 0
        textLabel.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.55)
        textLabel.layer.masksToBounds = true
        textLabel.layer.cornerRadius = textLabel.bounds.height*0.5
        hud.bezelView.addSubview(textLabel)

        hud.margin = 20
        hud.set(postion: postion)
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 1.2)
    }
    private func set(postion: HUDPostion) {
        switch postion {
        case .top: offset = CGPoint(x: 0, y: -MBProgressMaxOffset)
        case .center: offset = .zero
        case .bottom: offset = CGPoint(x: 0, y: MBProgressMaxOffset)
        }
    }
}
