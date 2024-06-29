//
//  AppDelegate.swift
//  JXRtc
//
//  Created by qicaiyuan on 2024/6/27.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
   
    var _launchOptions: [UIApplication.LaunchOptionsKey: Any]?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        CBFlashyTabBar.appearance().tintColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.431372549, alpha: 1)
//        CBFlashyTabBar.appearance().barTintColor = .white
        
        
        JXEngineKit.shared.initEng(event: IJXEvent())
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = .white
        
        
        
       let loginxib = LoginVC(nibName: "LoginVC", bundle: nil)
        
     
       let navi = UINavigationController(rootViewController: loginxib)
        
       window!.rootViewController = navi
       window!.makeKeyAndVisible()
     
        return true
    }


    // 创建tabbar
    static func creatMainTabBar() {
        
       
        
        if let delegate = UIApplication.shared.delegate {
            let delegate = delegate as! AppDelegate
            if ((delegate.window?.rootViewController) != nil){
                delegate.window?.rootViewController = nil
            }
           
            let tabBarController = TabbarVC()
            delegate.window?.rootViewController = tabBarController
            delegate.window?.makeKeyAndVisible()
        }

    }
    static func creatLogin() {
        
       
        
        if let delegate = UIApplication.shared.delegate {
            let delegate = delegate as! AppDelegate
            if ((delegate.window?.rootViewController) != nil){
                delegate.window?.rootViewController = nil
            }
           
            let loginxib = LoginVC(nibName: "LoginVC", bundle: nil)
            delegate.window?.rootViewController = loginxib
            delegate.window?.makeKeyAndVisible()
        }

    }


}

