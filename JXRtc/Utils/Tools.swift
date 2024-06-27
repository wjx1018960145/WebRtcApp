//
//  Tools.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/14.
//

import UIKit

class Tools: NSObject {
    /**当前控制器**/
    public class func currentVC() -> UIViewController? {
        let rootController = keyWindow().rootViewController
        if let tabController = rootController as? UITabBarController {
            if let navController = tabController.selectedViewController as? UINavigationController {
                return navController.children.last
            } else {
                return tabController
            }
        } else if let navController = rootController as? UINavigationController {
            return navController.children.last
        } else {
            return rootController
        }
    }
    
   

    /**keywindow**/
    public class func keyWindow() -> UIWindow {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .filter {$0.activationState == .foregroundActive}
                .compactMap {$0 as? UIWindowScene}
                .first?.windows.filter {$0.isKeyWindow}.first ?? UIApplication.shared.keyWindow!
        } else {
            return UIApplication.shared.keyWindow!
        }
    }
    /**获取最顶端控制器**/
    public class  func topMostViewController() -> UIViewController {
        guard let rootController = keyWindow().rootViewController else {
            return UIViewController()
        }
        return topMostViewController(for: rootController)
    }

    /**获取某个控制器最上层控制器**/
    public class func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }
    
   public class  func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        let objDateformat: DateFormatter = DateFormatter()
        objDateformat.dateFormat = "yyyy-MM-dd"
        let strTime: String = objDateformat.string(from: dateToConvert as Date)
        let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
        let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
    public class func currentTimeStamp() -> String {

        let timestamp = Date().timeIntervalSince1970
        let timestampString = String(timestamp)
        return timestampString
    }

    
    public class  func dictionaryToJson(dictionary: [String: Any]) -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
}
// 公用的扩展
public extension Int {
    var point: CGFloat {
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            return CGFloat(self) * UIScreen.main.bounds.size.height / 375.0
        } else {
            return CGFloat(self) * UIScreen.main.bounds.size.width / 375.0
        }
    }

    var pointY: CGFloat {
        return CGFloat(self) * UIScreen.main.bounds.size.height / 812.0
    }
}
