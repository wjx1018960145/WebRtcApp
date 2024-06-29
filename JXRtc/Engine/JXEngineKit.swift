//
//  JXEngineKit.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/14.
//

import UIKit

public class EnumType {

  
    enum CallState {
        case Idle
        case Outgoing
        case Incoming
        case Connecting
        case Connected
        
        func CallState() {
        }
    }


    public enum CallEndReason {
        case Busy
        case SignalError
        case RemoteSignalError
        case Hangup
        case MediaError
        case RemoteHangup
        case OpenCameraFailure
        case  Timeout
        case AcceptByOtherClient

      
    }

    public enum RefuseType:Int {
        case  Busy = 0
        case Hangup = 1
    }


}

class JXEngineKit: NSObject {
    
    public static let shared = JXEngineKit()
    
   
    var signalClient:SignalingClient?
    var mCurrentCallSession:JXRTCCallSession?
    var mEvent:IJXEventProtocol?
    var localView = UIView()
    var remoteView = UIView()
    var  isAudioOnly = false
     func initEng(event:IJXEventProtocol){
        self.mEvent = event
        
         
    }

    //拨打
    func startOutCall(view:UIView, _room room:String, _targetId  targetId:String, _audioOnly audioOnly:Bool){
        
        mCurrentCallSession = JXRTCCallSession(roomId: room, audioOnly: audioOnly, event: mEvent!)
        
        if mCurrentCallSession == nil {
            return
        }
        mCurrentCallSession?.mTargetId = targetId
        mCurrentCallSession?.mIsComing = false
        mCurrentCallSession?.callState = EnumType.CallState.Outgoing
        // 创建房间
        mCurrentCallSession?.createHome(room: room, roomSize: 2)//(room, 2);
        
        
    }
    //接听
    public func startInCall(view:UIView,  room:String, targetId:String ,
                            audioOnly:Bool) {
        
//        if (JXEngineKit.shared == nil) {
////              Log.e(TAG, "startInCall error,init is not set");
//              return
//          }
          // 忙线中
          if (mCurrentCallSession != nil && mCurrentCallSession?.callState != EnumType.CallState.Idle) {
//              // 发送->忙线中...
              mCurrentCallSession?.sendBusyRefuse(room: room, targetId: targetId)
              return ;
          }
          self.isAudioOnly = audioOnly;
          // 初始化会话0x0000000283898900
          mCurrentCallSession = JXRTCCallSession(roomId: room, audioOnly: audioOnly, event: mEvent!)// new CallSession(context, room, audioOnly, mEvent);
          mCurrentCallSession?.mTargetId = targetId
          mCurrentCallSession?.mIsComing = true
          mCurrentCallSession?.callState = EnumType.CallState.Incoming
          // 开始响铃并回复
//          mCurrentCallSession.shouldStartRing();
        mCurrentCallSession?.sendRingBack(targetId: targetId, room: room)
      }
    
  
 

    func  setNil(){
        mCurrentCallSession = nil
        mCurrentCallSession?.webRtc?.stopStream()
        mCurrentCallSession?.webRtc?.stopPreview()
        mCurrentCallSession?.webRtc?.stopRemoteVideo()
        
        
    }
    
    func startRemoteView(view:UIView){
        self.remoteView = view
    }
    
    func startLocalPreview(view:UIView){
        self.localView = view
    }
    
}
