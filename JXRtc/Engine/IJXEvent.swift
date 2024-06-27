//
//  IJXEvent.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/14.
//

import UIKit

class IJXEvent: NSObject,IJXEventProtocol {
    
    
    
    func createRoom(room: String, roomSize: Int) {
        SocketManager.shared.createRoom(room: room, roomSize: roomSize)
    }
    
    func sendInvite(room: String, userIds: [String], audioOnly: Bool) {
        SocketManager.shared.sendInvite(room: room, myId:LoginInfoManager.shared.userInfo.userId , users: userIds, audioOnly: audioOnly)//(room, userIds, audioOnly);
    }
    
    func sendRefuse(room: String, inviteId: String, refuseType:Int) {
        SocketManager.shared.sendRefuse(room: room, inviteId: inviteId, refuseType: refuseType)
    }
    
    func sendTransAudio(toId: String) {
        
    }
    
    func sendDisConnect(room: String, toId: String, isCrashed: Bool) {
        
    }
    
    func sendCancel(mRoomId: String, toId: [String]) {
        
    }
    
    func sendJoin(room: String) {
        SocketManager.shared.sendJoin(room: room)
    }
    
    func sendRingBack(targetId: String, room: String) {
        SocketManager.shared.sendRingBack(targetId: targetId, room: room)
    }
    
    func sendLeave(room: String, userId: String) {
        
    }
    
    func sendOffer(userId: String, sdp: String) {
        SocketManager.shared.sendOffer(userId: userId, sdp: sdp)
    }
    
    func sendAnswer(userId: String, sdp: String) {
        SocketManager.shared.sendAnswer(myId: LoginInfoManager.shared.userInfo.userId, userId: userId, sdp: sdp)
    }
    
    func sendIceCandidate(userId: String, id: String, label: Int, candidate: String) {
        SocketManager.shared.sendIceCandidate(userId: userId, id: id, label: label, candidate: candidate)
    }
    
    func onRemoteRing() {
        
    }
    
    func shouldStartRing(isComing: Bool) {
        
    }
    
    func shouldStopRing() {
        
        
        
    }
    

}
