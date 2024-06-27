//
//  IJXEvent.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/14.
//

import UIKit

protocol IJXEventProtocol :AnyObject{

    /**
        * create room
        * Every net call must create a room
        * @param room room tag
        * @param roomSize room size
        *                 single call size == 2
        *                 multi call size >= 2
        */
    func createRoom( room:String,  roomSize:Int);

       // 发送单人邀请
    func sendInvite(room:String, userIds:[String], audioOnly:Bool);

    func sendRefuse(room:String, inviteId:String,refuseType: Int);

    func sendTransAudio(toId:String);

    func sendDisConnect(room:String,toId:String,isCrashed:Bool);

    func sendCancel(mRoomId:String,toId:[String]);

    func sendJoin(room:String);

    func sendRingBack(targetId:String,room:String);

    func sendLeave(room:String,userId:String);

       // sendOffer
    func sendOffer(userId:String,sdp:String);

       // sendAnswer
    func sendAnswer(userId:String,sdp:String);

       // sendIceCandidate
    func sendIceCandidate(userId:String,id:String,label:Int,candidate:String);

    func onRemoteRing();

    func shouldStartRing(isComing:Bool);

    func shouldStopRing();

    
}
