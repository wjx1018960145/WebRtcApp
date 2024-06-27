//
//  JXSocketProtocol.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/15.
//

import UIKit

protocol JXSocketProtocol: AnyObject {
    
    
    func onOpen();

    func loginSuccess(userId:String,  avatar:String);


    func onInvite(room:String,audioOnly:Bool, inviteId:String, userList:String);


    func onCancel(inviteId:String);

    func onRing(userId:String);


    func onPeers(myId:String, userList:String, roomSize:Int);

    func onNewPeer(myId:String);

    func onReject(userId:String,type:Int);

    // onOffer
    func onOffer(userId:String, sdp:String);

    // onAnswer
    func onAnswer(userId:String, sdp:String);

    // ice-candidate
    func onIceCandidate(userId:String, id:String, label:Int, candidate:String)

    func onLeave(userId:String);

    func logout(str:String)

    func onTransAudio(userId:String)

    func onDisConnect(userId:String);

    func reConnect();


}
