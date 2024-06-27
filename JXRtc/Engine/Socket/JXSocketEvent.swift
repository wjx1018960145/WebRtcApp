//
//  JXSocketEvent.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/16.
//

import UIKit

class JXSocketEvent: JXSocketProtocol {
    func onOpen() {
        
    }
    
    func loginSuccess(userId: String, avatar: String) {
        
    }
    
    func onInvite(room: String, audioOnly: Bool, inviteId: String, userList: String) {
//        Intent intent = new Intent();
//            intent.putExtra("room", room);
//            intent.putExtra("audioOnly", audioOnly);
//            intent.putExtra("inviteId", inviteId);
//            intent.putExtra("userList", userList);
//            intent.setAction(Consts.ACTION_VOIP_RECEIVER);
//            intent.setComponent(new ComponentName(App.getInstance().getPackageName(), VoipReceiver.class.getName()));
//            // 发送广播
//            App.getInstance().sendBroadcast(intent);
        
        DispatchQueue.main.async {
            
            
            
            let vc =  CallPlayVC()
            vc.isOutgoing = false
            vc.modalPresentationStyle = .fullScreen
            vc.targetId = inviteId
            vc.inviteRoom = room
            
            Tools.topMostViewController().present(vc, animated: true, completion: nil)
        }
        
     
        
        
        
        
        
    }
    
    func onCancel(inviteId: String) {
        let currentSession = JXEngineKit.shared.mCurrentCallSession
          if (currentSession != nil) {
              currentSession?.onCancel(userId: inviteId)
          }
    }
    
    func onRing(userId: String) {
        
    }
    
    func onPeers(myId: String, userList: String, roomSize: Int) {
        //自己进入了房间，然后开始发送offer
        let currentSession = JXEngineKit.shared.mCurrentCallSession
                  if (currentSession != nil) {
                      currentSession?.onJoinHome(myId: myId, users: userList, roomSize: roomSize)
                  }
    }
    
    func onNewPeer(myId: String) {
        let currentSession = JXEngineKit.shared.mCurrentCallSession
                  if (currentSession != nil) {
                      currentSession?.newPeer(userId: myId)
                  }
    }
    
    func onReject(userId: String, type: Int) {
        let currentSession = JXEngineKit.shared.mCurrentCallSession
                  if (currentSession != nil) {
                      currentSession?.onRefuse(userId: userId, type: type)
                  }
    }
    
    func onOffer(userId: String, sdp: String) {
        let currentSession = JXEngineKit.shared.mCurrentCallSession
                   if (currentSession != nil) {
                       currentSession?.onReceiveOffer(userId: userId, description: sdp)// onReceiveOffer(userId, sdp);
                   }
    }
    
    
    func onAnswer(userId: String, sdp: String) {
        let currentSession = JXEngineKit.shared.mCurrentCallSession
           if (currentSession != nil) {
               currentSession?.onReceiverAnswer(userId: userId, sdp: sdp)
           }
    }
    
    func onIceCandidate(userId: String, id: String, label: Int, candidate: String) {
        let currentSession = JXEngineKit.shared.mCurrentCallSession
        if (currentSession != nil) {
            currentSession?.onRemoteIceCandidate(userId: userId, id: id, label: label, candidate: candidate)
        }
    }
    
    func onLeave(userId: String) {
        
    }
    
    func logout(str: String) {
        
    }
    
    func onTransAudio(userId: String) {
        
    }
    
    func onDisConnect(userId: String) {
        
    }
    
    func reConnect() {
        
    }
    

}
