//
//  EngineCallback.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/18.
//

import UIKit
import WebRTC
protocol EngineCallback: AnyObject {

    /**
     * 加入房间成功
     */
    func joinRoomSucc()

    /**
     * 退出房间成功
     */
    func exitRoom()

    /**
     * 拒绝连接
     * @param type type
     */
    func reject(type:Int)

    func disconnected(reason:EnumType.CallEndReason)

    func onSendIceCandidate(userId:String,candidate:IceCandidate)

    func onSendOffer(userId:String,description:RTCSessionDescription)

    func onSendAnswer(userId:String,description:RTCSessionDescription)

    func onRemoteStream(userId:String)

    func onDisconnected(userId:String)
}
