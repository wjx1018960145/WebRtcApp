//
//  IEngine.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/18.
//

import UIKit

protocol IEngine: AnyObject {

    /**
       * 初始化
       */
    func initE(callback:EngineCallback)

      /**
       * 加入房間
       */
    func joinRoom(userIds:[String]);

      /**
       * 有人进入房间
       */
    func userIn(userId:String);

      /**
       * 用户拒绝
       * @param userId userId
       * @param type type
       */
    func userReject(userId:String,type:Int);

      /**
       * 用户网络断开
       * @param userId userId
       * @param reason
       */
    func disconnected(userId:String,reason: EnumType.CallEndReason);

      /**
       * receive Offer
       */
    func receiveOffer(userId:String,description:String);

      /**
       * receive Answer
       */
    func receiveAnswer(userId:String,sdp:String);

      /**
       * receive IceCandidate
       */
    func receiveIceCandidate(userId:String,id:String,label:Int,candidate:String);

      /**
       * 离开房间
       *
       * @param userId userId
       */
    func leaveRoom(userId:String);

      /**
       * 开启本地预览
       */
    func setupLocalPreview(isOverlay:Bool);

      /**
       * 关闭本地预览
       */
    func stopPreview();

      /**
       * 开始远端推流
       */
    func startStream();

      /**
       * 停止远端推流
       */
    func stopStream();

      /**
       * 开始远端预览
       */
    func setupRemoteVideo(userId:String,isO:Bool) -> UIView;

      /**
       * 关闭远端预览
       */
    func stopRemoteVideo();

      /**
       * 切换摄像头
       */
    func switchCamera();

      /**
       * 设置静音
       */
    func muteAudio(enable:Bool)->Bool;

      /**
       * 开启扬声器
       */
    func toggleSpeaker(enable:Bool)->Bool;

      /**
       * 切换外放和耳机
       */
    func toggleHeadset(isHeadset:Bool)->Bool;

      /**
       * 释放所有内容
       */
//    func release();

}
