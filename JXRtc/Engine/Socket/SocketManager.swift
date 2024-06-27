//
//  SocketManager.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/15.
//

import UIKit
import HandyJSON
import WebRTC
class SocketManager: NSObject {
   
    private var webSocket:NativeWebSocket?
    private var socket:URLSessionWebSocketTask?
    
    public static let shared = SocketManager()
    
    
    public func connect(url:String,userId:String, device:Int) {
        let URL = URL(string: url + "/\(userId)/0")!
        if webSocket != nil {
            let socket =  self.webSocket?.urlSession.webSocketTask(with: URL)
            socket?.resume()
           
//            self.readMessage()
            
        }
        
    }
    
    public func createRoom(room:String, roomSize:Int) {
            
//          if (webSocket != nil) {
//              webSocket?.createRoom(room: room, roomSize: roomSize, myId: LoginInfoManager.shared.userInfo.userId)
//          }
//        
//        ManagerTool.shared.signalClient?.createRoom(room: room, roomSize: roomSize, myId:  LoginInfoManager.shared.userInfo.userId)
        let seclket = ManagerTool.shared.signalClient?.webSocket as! NativeWebSocket
        seclket.createRoom(room: room, roomSize: roomSize, myId:  LoginInfoManager.shared.userInfo.userId)
//        socket.createRoom(room: room, roomSize: roomSize, myId:  LoginInfoManager.shared.userInfo.userId)
      }
    
    public func sendInvite(room:String, myId:String, users:[String],audioOnly:Bool) {
        
            let seclket = ManagerTool.shared.signalClient?.webSocket as! NativeWebSocket
        
        seclket.sendInvite(room: room, myId: myId, users: users, audioOnly: audioOnly)
       }
    public func sendRingBack(targetId:String,room:String) {
//           if (webSocket != nil) {
               let seclket = ManagerTool.shared.signalClient?.webSocket as! NativeWebSocket
                seclket.sendRing(myId: LoginInfoManager.shared.userInfo.userId, toId: targetId, room: room)
//           }
       }
    
    
    
    public func sendJoin(room:String){
        let seclket = ManagerTool.shared.signalClient?.webSocket as! NativeWebSocket
        seclket.sendJoin(room: room, myId:LoginInfoManager.shared.userInfo.userId)
    }
    // 拒接接听
    public func sendRefuse(room:String,inviteId:String,refuseType:Int) {
        let seclket = ManagerTool.shared.signalClient?.webSocket as! NativeWebSocket
        seclket.sendRefuse(room: room, inviteID: inviteId, myId: LoginInfoManager.shared.userInfo.userId, refuseType: refuseType)// sendRefuse(room, inviteId, myId, refuseType);
      }
    
    public func sendOffer(userId:String,sdp:String) {
        let seclket = ManagerTool.shared.signalClient?.webSocket as! NativeWebSocket
        seclket.sendOffer(myId: LoginInfoManager.shared.userInfo.userId, userId: userId, sdp: sdp)
           
       }
    public func sendAnswer(myId:String, userId:String,  sdp:String){
        let seclket = ManagerTool.shared.signalClient?.webSocket as! NativeWebSocket
        seclket.sendAnswer(myId: myId, userId: userId, sdp: sdp)
    }
    
    
    func sendIceCandidate(userId: String, id: String, label: Int, candidate: String){
        let seclket = ManagerTool.shared.signalClient?.webSocket as! NativeWebSocket

            seclket.sendIceCandidate(myId:  LoginInfoManager.shared.userInfo.userId, userId: userId, id: id, label: label, candidate: candidate)
      
    }
   
}



