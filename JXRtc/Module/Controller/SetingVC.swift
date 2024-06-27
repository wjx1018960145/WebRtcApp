//
//  SetingVC.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/13.
//

import UIKit

class SetingVC: UIViewController {
    
  

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logout(_ sender: UIButton) {
        
        ManagerTool.shared.closeSocket()
        
        AppDelegate.creatLogin()
        
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
