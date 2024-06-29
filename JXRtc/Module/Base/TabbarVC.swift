//
//  TabbarVC.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/13.
//

import UIKit
import CBFlashyTabBarController
class TabbarVC: CBFlashyTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let eventsVC = UINavigationController(rootViewController: MainVC())
        eventsVC.tabBarItem = UITabBarItem(title: "User", image: #imageLiteral(resourceName: "Events"), tag: 0)
        let searchVC = UINavigationController(rootViewController: RoomVC())
        searchVC.tabBarItem = UITabBarItem(title: "Room", image: #imageLiteral(resourceName: "Search"), tag: 0)
        let settingsVC = UINavigationController(rootViewController: SetingVC())
        settingsVC.tabBarItem = UITabBarItem(title: "Setting", image: #imageLiteral(resourceName: "Settings"), tag: 0)
        
        let test = UINavigationController(rootViewController: TestVC())
        test.tabBarItem = UITabBarItem(title: "测试", image: #imageLiteral(resourceName:"Settings"), tag: 0)

        let tabBarController = CBFlashyTabBarController()
        self.viewControllers = [eventsVC, searchVC, settingsVC,test]
        
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
