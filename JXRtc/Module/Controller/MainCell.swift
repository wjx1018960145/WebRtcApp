//
//  MainCell.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/13.
//

import UIKit

class MainCell: UITableViewCell {
   
   
    @IBOutlet weak var useridLab: UILabel!
    
    @IBOutlet weak var voiceBut: UIButton!
    @IBOutlet weak var videoBut: UIButton!
    
    var even:((_ mode:UserMode)->Void)?
    var mode:UserMode?{
        didSet{
            guard let md = mode else {return}
            useridLab.text = md.userId
            if md.userId == LoginInfoManager.shared.userInfo.userId {
                voiceBut.isHidden = true
                videoBut.isHidden = true
                
            }else{
                voiceBut.isHidden = false
                videoBut.isHidden = false
            }
        }
    }
    
    @IBAction func voiceAction(_ sender: UIButton) {
        let socket =  ManagerTool.shared.signalClient?.webSocket as! NativeWebSocket
        socket.createRoom(room: "123", roomSize: 2, myId: "123")
        
    }
    @IBAction func videoAction(_ sender: UIButton) {
        
//        let vc =  CallPlayVC()
//        vc.modalPresentationStyle = .fullScreen
//        Tools.topMostViewController().present(vc, animated: true, completion: nil)
      //(videoViewController, animated: true, completion: nil)
        
        self.even?(self.mode!)
    }
    
    //创建房间
    func creatHomeJoin(){
        
//        let now = NSDate()
//        let nowTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: now)
//        let room = UUID().uuidString + nowTimeStamp
//         
//        
//        let data = ["room":room]
//        ManagerTool.shared.startOutCall(_room: room, _targetId: mode?.userId!, _audioOnly: false)
        
        
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
