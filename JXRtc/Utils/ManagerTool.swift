//
//  ManagerTool.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/13.
//

import Foundation

import WebRTC
class ManagerTool :NSObject{
    private let config = Config.default
    
    public static let shared = ManagerTool()
     var  webRTCClient:JXWebRtcEngine?
    var webSocketProvider: WebSocketProvider?
    var signalClient:SignalingClient?
    var is_front = true

    private override init() {
        super.init()
         webRTCClient = JXWebRtcEngine(mIsAudioOnly: false)
        if #available(iOS 13.0, *) {
            
            webSocketProvider = NativeWebSocket(url: self.config.signalingServerUrl)
        } else {
//            webSocketProvider = StarscreamWebSocket(url: self.config.signalingServerUrl)
        }
        signalClient = SignalingClient(webSocket: self.webSocketProvider!,socketEvent: JXSocketEvent())
        
        signalClient?.delegate = self
    }
}

extension ManagerTool {
    
    func buildSignalingClient()->SignalingClient{
        signalClient = SignalingClient(webSocket: self.webSocketProvider!,socketEvent: JXSocketEvent())
        signalClient?.delegate = self
        return signalClient!
    }
    
    func closeSocket(){
        signalClient?.disconnect()
        signalClient = nil
    }
    
    func connecSocket(){
        if self.signalClient == nil{
            signalClient = SignalingClient(webSocket: self.webSocketProvider!,socketEvent: JXSocketEvent())
        }
        self.signalClient!.connect(chatCode: LoginInfoManager.shared.userInfo.userId)
       
    }
    
}

extension ManagerTool:SignalClientDelegate{
    
    func signalClientDidConnect(_ signalClient: SignalingClient) {
        
    }
    
    func signalClientDidDisconnect(_ signalClient: SignalingClient) {
        
    }
    
    func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription) {
        
    }
    
    func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate) {
        
    }
    
    
}
