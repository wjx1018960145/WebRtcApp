//
//  NativeSocketProvider.swift
//  WebRTC-Demo
//
//  Created by stasel on 15/07/2019.
//  Copyright © 2019 stasel. All rights reserved.
//

import Foundation


@available(iOS 13.0, *)
class NativeWebSocket: NSObject, WebSocketProvider {
    
    var delegate: WebSocketProviderDelegate?
    private let url: String
    private var socket: URLSessionWebSocketTask?
   
     lazy var urlSession: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

    init(url: String) {
        self.url = url

        super.init()
    }

    func connect(chatCode:String) {
        
        let URL = URL(string: url + "/\(chatCode)/0")!
        
        let socket = urlSession.webSocketTask(with: URL)
        socket.resume()
        self.socket = socket
        self.readMessage()
    }
    func unconnect(){
        self.socket?.cancel()
    }
    func send(data: Data) {
        self.socket?.send(.data(data)) { v in
            print(v as Any)
        }
    }
    
    func createRoom(room:String,roomSize:Int,myId:String){
        let data = ["eventName":"__create","data":["room":room,"roomSize":roomSize,"userID":myId]] as [String : Any]
        self.sendBefore(data: data)
    }
    func sendInvite(room:String, myId:String, users:[String],audioOnly:Bool) {
        
        let data = ["eventName":"__invite","data":["room":room,"audioOnly":audioOnly,"inviteID":myId,"userList":users.joined(separator: ",")]] as [String : Any]
        
        self.sendBefore(data: data)
    }
    //发送请求
    public func sendOffer( myId:String, userId:String,sdp:String) {
        let data = ["eventName":"__offer","data":["sdp":sdp,"userID":userId,"fromID":myId]] as [String : Any]
        self.sendBefore(data: data)
    }
    //发送应答
    public func sendAnswer( myId:String,  userId:String,  sdp:String){
        let data = ["eventName":"__answer","data":["sdp":sdp,"userID":userId,"fromID":myId]] as [String : Any]
        self.sendBefore(data: data)
    }
    // 拒接接听
    public func sendRefuse(room:String,inviteID:String, myId:String,refuseType:Int) {
        let data = ["eventName":"__reject","data":["toID":inviteID,"room":room,"fromID":myId,"refuseType":"\(refuseType)"]] as [String : Any]
        self.sendBefore(data: data)
    }

    // 发送响铃通知
    public func sendRing(myId:String,toId:String,room:String) {
          let data = ["eventName":"__ring","data":["fromID":myId,"toID":toId,"room":room]] as [String : Any]
          self.sendBefore(data: data)
      }
    //加入房间
    public func sendJoin( room:String,myId:String) {
        let data = ["eventName":"__join","data":["userID":myId,"room":room]] as [String : Any]
           self.sendBefore(data: data)
    }
    
    //发送 ice
    func sendIceCandidate(myId:String,userId:String,id:String, label:Int,candidate:String){
       let data = ["eventName":"__ice_candidate","data":["userID":userId,"fromID":myId,"id":id,"label":label,"candidate":candidate]] as [String : Any]
          self.sendBefore(data: data)
    }
    
    
    public func sendBefore(data:[String:Any]){
        if let json = Tools.dictionaryToJson(dictionary: data) {
            print(json)  // 输出转换后的JSON字符串
            self.send2(value: json)
        }
    }
  
    func send2(value:String){
        if self.socket!.state == .running {
            self.socket?.send(.string(value), completionHandler: { v in
                
            })
        }
    }
    
   
    
    
    private func readMessage() {
        self.socket?.receive { [weak self] message in
            guard let self = self else { return }
            
            switch message {
            case .success(.data(let data)):
                self.delegate?.webSocket(self, didReceiveData: data)
                self.readMessage()
                debugPrint("Warning: Expected to receive data format but received a string. Check the websocket server config.")
            case .success(.string(let str)):
                
              
                self.delegate?.webSocket(self, didReceiveDString: str)
                self.readMessage()
            
            case .failure:
                self.disconnect()
            case .success(_):
                break
            }
        }
    }
    
    
  
    private func disconnect() {
        self.socket?.cancel()
        self.socket = nil
        self.delegate?.webSocketDidDisconnect(self)
    }

    
}

@available(iOS 13.0, *)
extension NativeWebSocket: URLSessionWebSocketDelegate, URLSessionDelegate  {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        self.delegate?.webSocketDidConnect(self)
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.disconnect()
    }
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            // 忽略证书验证
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
