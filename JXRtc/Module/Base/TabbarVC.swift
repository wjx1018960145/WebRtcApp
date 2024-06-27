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
        eventsVC.tabBarItem = UITabBarItem(title: "Events", image: #imageLiteral(resourceName: "Events"), tag: 0)
        let searchVC = UINavigationController(rootViewController: RoomVC())
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: #imageLiteral(resourceName: "Search"), tag: 0)
        let settingsVC = UINavigationController(rootViewController: SetingVC())
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "Settings"), tag: 0)
        

        let tabBarController = CBFlashyTabBarController()
        self.viewControllers = [eventsVC, searchVC, settingsVC]
        
        
        
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
