//
//  LoginVC.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/13.
//

import UIKit


class LoginVC: UIViewController {

    @IBOutlet weak var idTF: UITextField!
    private let config = Config.default
    
    // iOS 13 has native websocket support. For iOS 12 or lower we will use 3rd party library.
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func connection(_ sender: UIButton) {
      
        if idTF.text?.isEmpty == true{
            
            MBProgressHUD.tost("请输入用户 id")
            return
        }
        
        let user = UserMode()
        user.userId = self.idTF.text ?? ""
        LoginInfoManager.save_updata(info: user)
        ManagerTool.shared.connecSocket()
        
        AppDelegate.creatMainTabBar()
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
