//
//  SignalClient.swift
//  WebRTC
//
//  Created by Stasel on 20/05/2018.
//  Copyright © 2018 Stasel. All rights reserved.
//

import Foundation
import WebRTC
import HandyJSON
protocol SignalClientDelegate: AnyObject {
    func signalClientDidConnect(_ signalClient: SignalingClient)
    func signalClientDidDisconnect(_ signalClient: SignalingClient)
    func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription)
    func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate)
}

final class SignalingClient {
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
     let webSocket: WebSocketProvider
    weak var delegate: SignalClientDelegate?
     var chatCode = ""
    var socketEvent:JXSocketProtocol?
    init(webSocket: WebSocketProvider,socketEvent:JXSocketProtocol) {
        self.socketEvent = socketEvent
        self.webSocket = webSocket
    }
    
    func connect(chatCode:String) {
        self.webSocket.delegate = self
        self.chatCode = chatCode
        self.webSocket.connect(chatCode: chatCode)
    
    }
    func disconnect(){
        self.webSocket.unconnect()
    }
    func send(sdp rtcSdp: RTCSessionDescription) {
        let message = Message.sdp(SessionDescription(from: rtcSdp))
        do {
            let dataMessage = try self.encoder.encode(message)
            
            self.webSocket.send(data: dataMessage)
        }
        catch {
            debugPrint("Warning: Could not encode sdp: \(error)")
        }
    }
    
  
    
    func send(candidate rtcIceCandidate: RTCIceCandidate) {
        let message = Message.candidate(IceCandidate(from: rtcIceCandidate))
        do {
            let dataMessage = try self.encoder.encode(message)
            self.webSocket.send(data: dataMessage)
        }
        catch {
            debugPrint("Warning: Could not encode candidate: \(error)")
        }
    }
    
    
    
}


extension SignalingClient: WebSocketProviderDelegate {
    func webSocketDidConnect(_ webSocket: WebSocketProvider) {
        self.delegate?.signalClientDidConnect(self)
    }
    
    func webSocketDidDisconnect(_ webSocket: WebSocketProvider) {
        self.delegate?.signalClientDidDisconnect(self)
        
        // try to reconnect every two seconds
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            debugPrint("Trying to reconnect to signaling server...")
            self.webSocket.connect(chatCode: self.chatCode)
        }
    }
    
    func webSocket(_ webSocket: WebSocketProvider, didReceiveData data: Data) {
        let message: Message
        do {
            message = try self.decoder.decode(Message.self, from: data)
        }
        catch {
            debugPrint("Warning: Could not decode incoming message: \(error)")
            return
        }
        
        switch message {
        case .candidate(let iceCandidate):
            self.delegate?.signalClient(self, didReceiveCandidate: iceCandidate.rtcIceCandidate)
        case .sdp(let sessionDescription):
            self.delegate?.signalClient(self, didReceiveRemoteSdp: sessionDescription.rtcSessionDescription)
        }

    }
    
    func webSocket(_ webSocket: WebSocketProvider, didReceiveDString data: String) {
        
        guard let jsonData = data.data(using: .utf8) else { return }
         
        do {
            let mode = try SocketEvenMode.deserialize(from: data)!
            
            switch mode.eventName {
            case "__login_success":// 登录成功
                
                
                
                break
            case "__invite":// 被邀请
                handleInvite(mode: mode.data!);
                break
            case "__cancel": // 取消拨出
                handleCancel(mode: mode.data!);
                break
            case "__ring":// 响铃
                
                    break
            case "__new_peer": // 新人入房间
                handleNewPeer(mode: mode.data!);
                break
            case "__reject":// 拒绝接听
                handleReject(mode:mode.data!)
                break
            case "__offer": // offer
                handleOffer(mode:mode.data!);
                break
            case "__answer":// answer
                handleAnswer(mode:mode.data!);
                break
            case "__ice_candidate":// ice-candidate
                handleIceCandidate(mode:mode.data!);
                break
            case "__leave":// 离开房间
                break
            case "__audio":// 切换到语音
                break
            case "__disconnect":// 意外断开
                break
            case "__peers":// 进入房间
                handlePeers(mode: mode.data!)
                break
            default:
                break
            }
        }catch(let e){
            
        }
    }
    
    private func handlePeers(mode:EvenMode) {
        self.socketEvent?.onPeers(myId: mode.you, userList: mode.connections, roomSize: mode.roomSize)

        }
    //邀请
    private func handleInvite(mode:EvenMode){
        self.socketEvent?.onInvite(room: mode.room, audioOnly: mode.audioOnly, inviteId: mode.inviteID, userList: mode.userList)
    }
    //拨打取消
    private func handleCancel(mode:EvenMode) {
        self.socketEvent?.onCancel(inviteId: mode.inviteID)
     }
   //对方拒绝接听
    private func  handleReject(mode:EvenMode){
//        this.iEvent.onReject(fromID, rejectType);
        self.socketEvent?.onReject(userId: mode.fromID, type: mode.refuseType)
    }
    private func handleNewPeer(mode:EvenMode) {
         
        self.socketEvent?.onNewPeer(myId: mode.userID)
           
       }
    
    private func handleAnswer(mode:EvenMode) {
        self.socketEvent?.onAnswer(userId: mode.userID, sdp: mode.sdp)
           
       }

       private func handleOffer(mode:EvenMode) {
           self.socketEvent?.onOffer(userId: mode.userID, sdp: mode.sdp)
       }
    private func handleIceCandidate(mode:EvenMode) {
//         Map data = (Map) map.get("data");
//         if (data != null) {
//             String userID = (String) data.get("fromID");
//             String id = (String) data.get("id");
//             int label = (int) data.get("label");
//             String candidate = (String) data.get("candidate");
//             this.iEvent.onIceCandidate(userID, id, label, candidate);
//         }
        self.socketEvent?.onIceCandidate(userId: mode.userID, id: mode.id, label: mode.label, candidate: mode.candidate)
        
     }
   
}
