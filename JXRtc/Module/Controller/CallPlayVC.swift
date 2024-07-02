//
//  CallPlayVC.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/14.
//

import UIKit
import RxSwift
import WebRTC
class CallPlayVC: UIViewController {

    @IBOutlet weak var hangup: UIButton!
    @IBOutlet weak var timeLab: UILabel!
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var localSdpStatusLabel: UILabel!
    @IBOutlet weak var remoteSdpStatusLabel: UILabel!
    @IBOutlet weak var answerSucView: UIView!
    @IBOutlet weak var tipLab: UILabel!
    @IBOutlet weak var answerView: UIView!
    
    var video:CallVideoView?
    var voice:CallVoiceView?
    
    var targetId = ""
    var isOutgoing = false
    var inviteRoom = ""
    var isAudioOnly = false
    
    var mode:EvenMode?{
        didSet{
            guard let md = mode else{return}
            
        }
    }
    private let vertical: CGFloat = 15.0
    private let ylean = 20.0 / kScreenWidth
//    private let webRTCClient: WebRTCClient
    public lazy var viewBag: DisposeBag = DisposeBag()
    @IBOutlet weak var localVideoView: UIView!
    
   
    
 
    override func viewWillDisappear(_ animated: Bool) {
        JXEngineKit.shared.setNil()
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hasLocalSdp = false
        
        self.view.backgroundColor = .clear
        self.bgView.backgroundColor = .clear
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(pan:)))
        self.localVideoView.addGestureRecognizer(pan)
        initLive(targetId: targetId, false, isAudioOnly, isReplace: false)
        self.answerView.backgroundColor = .clear
        self.answerSucView.backgroundColor = .clear
        self.answerSucView.isHidden = true
        
        JXEngineKit.shared.startLocalPreview(view: self.localVideoView)
        JXEngineKit.shared.startRemoteView(view: self.bgView)
        
        
   

    }
    
    
    
    private var hasLocalSdp: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.localSdpStatusLabel?.text = self.hasLocalSdp ? "✅" : "❌"
            }
        }
    }
    
    func initLive(targetId:String,_ outgoing:Bool,_ audioOnly:Bool,isReplace:Bool){
        let now = NSDate()
        let nowTimeStamp = Tools.getCurrentTimeStampWOMiliseconds(dateToConvert: now)
        let room = UUID().uuidString + nowTimeStamp
        if isAudioOnly {
            //语音通话视频
            if isOutgoing { //拨打电话
                answerView.isHidden = true
                hangup.isHidden = false
                tipLab.text = "等待对方接听"
                JXEngineKit.shared.startOutCall(view:self.localVideoView, _room: room, _targetId: targetId, _audioOnly: audioOnly)// startOutCall(getApplicationContext(), room, targetId, audioOnly);
            }else{
                //接听电话
                answerView.isHidden = false
                hangup.isHidden = true
                tipLab.text = "\(targetId)邀请语音通话"
                JXEngineKit.shared.startInCall(view: self.localVideoView, room: inviteRoom, targetId: self.targetId, audioOnly: audioOnly)
            }
        }else{
            //视频通话页面
            if isOutgoing { //拨打电话
                answerView.isHidden = true
                hangup.isHidden = false
                tipLab.text = "等待对方接听"
                JXEngineKit.shared.startOutCall(view:self.localVideoView, _room: room, _targetId: targetId, _audioOnly: audioOnly)// startOutCall(getApplicationContext(), room, targetId, audioOnly);
                
            }else{
                //接听电话
                answerView.isHidden = false
                hangup.isHidden = true
                tipLab.text = "\(targetId)邀请视频通话"
                JXEngineKit.shared.startInCall(view: self.localVideoView, room: inviteRoom, targetId: self.targetId, audioOnly: audioOnly)
            }
        }
        let session = JXEngineKit.shared.mCurrentCallSession
        session?.delegate = self
        
        
        
        
    }
    
    private func embedView(_ view: UIView, into containerView: UIView) {
        containerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view":view]))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view":view]))
        containerView.layoutIfNeeded()
    }
    @IBAction func jietongHangup(_ sender: Any) {
        
        let session = JXEngineKit.shared.mCurrentCallSession
        session!.sendRefuse()
        
        JXEngineKit.shared.setNil()
        self.dismiss(animated: true)
        
    }
    
    @IBAction func hangupAction(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    @IBAction func jietingHangup(_ sender: Any) {
        let session = JXEngineKit.shared.mCurrentCallSession
        session!.sendRefuse()
        
        JXEngineKit.shared.setNil()
        self.dismiss(animated: true)
        
       
        
    }
    
    
    @IBAction func answerAction(_ sender: Any) {
        
        let session = JXEngineKit.shared.mCurrentCallSession
        
        session?.joinHome(roomId: session!.mRoomId)
        
        answerView.isHidden = true
        answerSucView.isHidden = false
        tipLab.isHidden = true
    }
    @objc func panAction(pan: UIPanGestureRecognizer) {
        // 获取视图
        let appWindow = UIApplication.shared.keyWindow
        let panPoint = pan.location(in: appWindow)
        appWindow?.bringSubviewToFront(self.localVideoView)
        if pan.state == .began {
            self.localVideoView.alpha = 1
        } else if pan.state == .changed {
            self.localVideoView.center = CGPoint(x: panPoint.x, y: panPoint.y)
        } else if pan.state == .ended || pan.state == .cancelled {
            let ballWidth = self.localVideoView.frame.size.width
            let ballHeight = self.localVideoView.frame.size.height
            let left = abs(panPoint.x)
            let right = abs(kScreenWidth - left)
            let top = abs(panPoint.y)
            let bottom = abs(kScreenHeight - top)

            let minSpace = min(min(min(top, left), bottom), right)
            var newCenter = CGPoint.zero
            var targetY: CGFloat = 0

            if panPoint.y < self.vertical + ballHeight / 2 {
                targetY = self.vertical + ballHeight / 2
            } else if panPoint.y > (kScreenHeight - ballHeight / 2 - self.vertical) {
                targetY = kScreenHeight - ballHeight / 2 - self.vertical
            } else {
                targetY = panPoint.y
            }

            let cenerYSpace = (0.5 - self.ylean) * ballHeight

            if minSpace == left {
                newCenter = CGPoint(x: kScreenWidth/2, y: targetY)
            } else if minSpace == right {
                newCenter = CGPoint(x: kScreenWidth/2, y: targetY)
            } else if minSpace == top {
                newCenter = CGPoint(x: kScreenWidth/2, y: cenerYSpace + 88.point)
            } else {
                newCenter = CGPoint(x: kScreenWidth/2, y: kScreenHeight - 74.point)
            }

            UIView.animate(withDuration: 0.25) {
                self.localVideoView.center = newCenter
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

extension CallPlayVC:JXCallSessionCallback {
    
    func didCallEndWithReason(var1: EnumType.CallEndReason) {
        
    }
    
    func didChangeState(var1: EnumType.CallState) {
        if var1 == .Connected {
            DispatchQueue.main.async { [self] in
                hangup.isHidden = true
                answerView.isHidden = true
                answerSucView.isHidden = false
                
            }
           
        }
        
        
    }
    
    func didChangeMode(isAudioOnly: Bool) {
        
    }
    
    func didCreateLocalVideoTrack() {
    
    }
    
    func didReceiveRemoteVideoTrack(userId: String) {
        DispatchQueue.main.async {
          
        }
       
        
    }
    
    func didUserLeave(userId: String) {
        
    }
    
    func didError(error: String) {
        
    }
    
    func didDisconnected(userId: String) {
        
    }
    
    
}
