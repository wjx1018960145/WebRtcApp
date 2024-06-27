//
//  MainVC.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/13.
//

import UIKit
import Moya

import AVFoundation
import WebRTC
class MainVC: UIViewController {
    //刷新
    var refreshControl : UIRefreshControl?
    var listUser = [UserMode]()
    @IBOutlet weak var userListView: UITableView!
    
    
   
    
    
    override func viewWillAppear(_ animated: Bool) {
        GASuspendManager.updateSuspendViewShow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userListView.register(UINib(nibName: "MainCell", bundle: nil).self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        refreshControl = UIRefreshControl()
        self.userListView?.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(getData), for: .valueChanged)
        
//        self.webRTCClient.delegate = self
        
        // 模拟数据延时
               DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                   self.getData()
               }
    }
    

    @objc func getData(){
        let request =  MoyaProvider<ApiService>()
        request.request(.getUser) { result in
            switch result {
                
            case .success(let response):
                self.listUser.removeAll()
              
                let data=response.data
                if response.statusCode != 200{
                    
                    return
                }
                //data就是请求得到的字节数据
                let responseBody = String(data: data, encoding: .utf8)
                do {
                    let base = try [UserMode].deserialize(from: responseBody) as! [UserMode]
                    self.listUser = base
                     print(base as Any)
                 } catch(let error) {
                     print("Error decoding JSON: \(error)")
                 }
            
                
                
                self.userListView.reloadData()
                self.refreshControl?.endRefreshing()
                break
                
            case .failure(let error):
                break
            }
        }
        
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

extension MainVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainCell
        cell.mode = self.listUser[indexPath.row]
        cell.even = { v in
            let vc =  CallPlayVC()
            vc.isOutgoing = true
            vc.modalPresentationStyle = .fullScreen
            vc.targetId = v.userId
        self.present(vc, animated: true, completion: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
    }
}







