//
//  JXRTCCallSession.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/14.
//

import UIKit
import WebRTC
class JXRTCCallSession: NSObject ,JXWebRtcEngineDelegate{
    
    
    func webRTCClient(_ client: JXWebRtcEngine, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        
        mEvent.sendIceCandidate(userId: mTargetId, id: candidate.sdpMid!, label: Int(candidate.sdpMLineIndex), candidate: candidate.sdp)
        
    }
    
    func webRTCClient(_ client: JXWebRtcEngine, didChangeConnectionState state: RTCIceConnectionState) {
        
    }
    
    func webRTCClient(_ client: JXWebRtcEngine, didReceiveData data: Data) {
        
    }
    
   
    
    private let encoder = JSONEncoder()
    
    private var  mIsAudioOnly:Bool
        // 房间人列表
    private var  mUserIDList = [String]()
        // 单聊对方Id/群聊邀请人
    public var  mTargetId = ""
        // 房间Id
    public var  mRoomId:String
        // myId
    public var  mMyId = ""
        // 房间大小
    public var  mRoomSize = 0
    
    var mIsComing = false
    
    private  var mEvent:IJXEventProtocol
     
    var callState:EnumType.CallState?
  
    weak var delegate:JXCallSessionCallback?
    var webRtc:JXWebRtcEngine?
    private var startTime = 0.0
    private var  iEngine:AVEngine
    init(roomId:String,  audioOnly:Bool,event:IJXEventProtocol) {
        self.mIsAudioOnly = audioOnly
        self.mRoomId = roomId
        self.mEvent = event
        
        webRtc = JXWebRtcEngine(mIsAudioOnly: audioOnly)
        
        iEngine = AVEngine.shared.createEngine(engine: webRtc!)
        super.init()
        webRtc!.rtcDelegate = self
        iEngine.initE(callback: self)
        
    }
    // ----------------------------------------各种控制--------------------------------------------

        // 创建房间
    public func createHome(room:String,roomSize:Int) {
//            executor.execute(() -> {
        
//            guard let e = mEvent else{return}
        
                mEvent.createRoom(room: room, roomSize: roomSize);
                
//            });
        }
    
    // 加入房间成功
    public func onJoinHome(myId:String,  users:String,  roomSize:Int) {
           // 开始计时
           mRoomSize = roomSize;
           startTime = 0;
//           handler.post(() -> executor.execute(() -> {
               mMyId = myId;
              
            if users.isEmpty == false {
//                   String[] split = users.split(",");
//                   strings = Arrays.asList(split);
                let array = users.components(separatedBy: ",")
                   mUserIDList = array;
               }

               // 发送邀请
               if (!mIsComing) {
                   if (roomSize == 2) {
                       var inviteList = [String]()
                       inviteList.append(mTargetId);
                       mEvent.sendInvite(room: mRoomId, userIds: inviteList, audioOnly: mIsAudioOnly);
                   }
               } else {
                   
                   iEngine.joinRoom(userIds: mUserIDList);
               }
        if (delegate != nil) {
            delegate!.didCreateLocalVideoTrack();
           
          }
       }
    
    //开始响铃
      public func shouldStartRing() {
          
              mEvent.shouldStartRing(isComing: true)//(true);
          
      }

      // 关闭响铃
      public func shouldStopRing() {
//          Log.d(TAG, "shouldStopRing mEvent != null is " + (mEvent != null));
        
              mEvent.shouldStopRing();
          
      }

      // 发送响铃回复
    public func sendRingBack(targetId:String,room:String) {
//          executor.execute(() -> {
             
                  mEvent.sendRingBack(targetId: targetId, room: room) //sendRingBack(targetId, room);
              
//          });
      }
    // 加入房间
    public func joinHome(roomId:String) {
//           executor.execute(() -> {
//               _callState = EnumType.CallState.Connecting;
////               Log.d(TAG, "joinHome mEvent = " + mEvent);
               mIsComing = true// setIsComing(true);
//               if (mEvent != nil) {
                   mEvent.sendJoin(room: roomId)
//               }
//           });

       }
    // 对方取消拨出
    public func onCancel(userId:String) {
           
            shouldStopRing();
//            release(EnumType.CallEndReason.RemoteHangup);
        }
    // 发送忙时拒绝
    public func sendBusyRefuse(room:String,targetId:String) {
//          executor.execute(() -> {
             
                  // 取消拨出
                  mEvent.sendRefuse(room: room, inviteId: targetId, refuseType: 0)// sendRefuse(room, targetId, EnumType.RefuseType.Busy);
              
//          });
//          release(EnumType.CallEndReason.Hangup);

      }
    // 发送拒绝信令
    public func sendRefuse() {
//          executor.execute(() -> {
           
                  // 取消拨出
                  mEvent.sendRefuse(room: mRoomId, inviteId: mTargetId, refuseType: 1)// sendRefuse(mRoomId, mTargetId, EnumType.RefuseType.Hangup.ordinal());
              
//          });
//          release(EnumType.CallEndReason.Hangup);
      }
    // 对方已拒绝
    public func onRefuse(userId:String,type:Int) {
        
       
        DispatchQueue.main.async {
            
            let vc = Tools.topMostViewController() as! CallPlayVC
            vc.tipLab.text = "对方拒绝接听"
            vc.hangup.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                JXEngineKit.shared.setNil()
                Tools.topMostViewController().dismiss(animated: true)
            }
           
        }
       
        
//          iEngine.userReject(userId, type);
        
      }
    
    public func onReceiveOffer(userId:String ,  description:String) {
//            executor.execute(() -> {
            iEngine.receiveOffer(userId: userId, description: description)// receiveOffer(userId, description);
//            });

        }

    public func onReceiverAnswer(userId:String,sdp:String) {
//            executor.execute(() -> {
                iEngine.receiveAnswer(userId: userId, sdp: sdp)
//            });

        }
    
    public func onRemoteIceCandidate( userId:String,  id:String,  label:Int,  candidate:String) {
//           executor.execute(() -> {
        iEngine.receiveIceCandidate(userId: userId, id: id, label: label, candidate: candidate) //receiveIceCandidate(userId, id, label, candidate);
//           });

       }
    
    public func newPeer(userId:String) {
//           handler.post(() -> executor.execute(() -> {
               // 其他人加入房间
               iEngine.userIn(userId: userId)//(userId);

               // 关闭响铃
              
                   mEvent.shouldStopRing();
               
               // 更换界面
//               _callState = EnumType.CallState.Connected;
//
//               if (delegate != nil) {
//                   startTime = System.currentTimeMillis();
                   delegate?.didChangeState(var1: .Connected)
//                   sessionCallback.get().didChangeState(.c);

//               }
//           }));

       }
    
}
 
extension JXRTCCallSession:EngineCallback {
    
    
    func joinRoomSucc() {
        self.delegate?.didChangeState(var1: EnumType.CallState.Connected)
    }
    
    func exitRoom() {
    
    }
    
    func reject(type: Int) {
        
    }
    
    func disconnected(reason: EnumType.CallEndReason) {
        
    }
    
    func onSendIceCandidate(userId: String, candidate: IceCandidate) {
        
    }
    
    func onSendOffer(userId: String, description: RTCSessionDescription) {
        let message = Message.sdp(SessionDescription(from: description))
        do{
            try  mEvent.sendOffer(userId: userId, sdp: description.sdp)
        }catch{
            
        }
        
    }
    
    func onSendAnswer(userId: String, description: RTCSessionDescription) {
        mEvent.sendAnswer(userId: userId, sdp: description.sdp)
        delegate?.didReceiveRemoteVideoTrack(userId: mTargetId)
    }
    
    func onRemoteStream(userId: String) {
        
    }
    
    func onDisconnected(userId: String) {
        
    }
    

}



