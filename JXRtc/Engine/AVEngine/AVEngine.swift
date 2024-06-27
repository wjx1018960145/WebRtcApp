//
//  AVEngine.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/18.
//

import UIKit

class AVEngine: NSObject {

    
    public static let shared = AVEngine()
    private final var iEngine:IEngine?
    
  
    func createEngine(engine:IEngine)->AVEngine{
        self.iEngine = engine
        return .shared
    }
    
  
}
extension AVEngine:IEngine{
    
    func initE(callback: EngineCallback) {
        if (self.iEngine == nil) {
                    return;
                }
        self.iEngine?.initE(callback: callback)//(callback);
    }
    
    func joinRoom(userIds: [String]) {
        if iEngine == nil{
            return
        }
        iEngine?.joinRoom(userIds: userIds)
    }
    
    func userIn(userId: String) {
        if (iEngine == nil) {
                   return;
               }
        iEngine?.userIn(userId: userId)
    }
    
    func userReject(userId: String, type: Int) {
        
    }
    
    func disconnected(userId: String, reason: EnumType.CallEndReason) {
        
    }
    
    func receiveOffer(userId: String, description: String) {
        iEngine?.receiveOffer(userId: userId, description: description)
    }
    
    func receiveAnswer(userId: String, sdp: String) {
        iEngine?.receiveAnswer(userId: userId, sdp: sdp)
    }
    
    func receiveIceCandidate(userId: String, id: String, label: Int, candidate: String) {
        iEngine?.receiveIceCandidate(userId: userId, id: id, label: label, candidate: candidate)
    }
    
    func leaveRoom(userId: String) {
        
    }
    
    func setupLocalPreview(isOverlay: Bool) {
        
    }
    
    func stopPreview() {
        
    }
    
    func startStream() {
        
    }
    
    func stopStream() {
        
    }
    
    func setupRemoteVideo(userId: String, isO: Bool) -> UIView {
        if (iEngine == nil) {
                   return UIView();
               }
      return (iEngine?.setupRemoteVideo(userId: userId, isO: isO))!
    }
    
    func stopRemoteVideo() {
        
    }
    
    func switchCamera() {
        
    }
    
    func muteAudio(enable: Bool) -> Bool {
        if (iEngine == nil) {
                   return false;
               }
        return ((iEngine?.muteAudio(enable: enable)) != nil)
    }
    
    func toggleSpeaker(enable: Bool) -> Bool {
        if (iEngine == nil) {
                   return false;
               }
        return iEngine!.toggleSpeaker(enable: enable)
    }
    
    func toggleHeadset(isHeadset: Bool) -> Bool {
        if (iEngine == nil) {
                   return false;
               }
        return iEngine!.toggleHeadset(isHeadset: isHeadset)
    }
    
    
}
