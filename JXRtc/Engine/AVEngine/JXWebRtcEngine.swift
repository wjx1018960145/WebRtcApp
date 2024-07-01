//
//  JXWebRtcEngine.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/18.
//

import UIKit
import WebRTC

protocol JXWebRtcEngineDelegate: AnyObject {
    
    func webRTCClient(_ client: JXWebRtcEngine, didDiscoverLocalCandidate candidate: RTCIceCandidate)
     func webRTCClient(_ client: JXWebRtcEngine, didChangeConnectionState state: RTCIceConnectionState)
     func webRTCClient(_ client: JXWebRtcEngine, didReceiveData data: Data)

}

class JXWebRtcEngine: NSObject {
   
   
    
    
    // 对话实例列表
    private final var peers =  ConcurrentHashMap<String, Any>()
       // 服务器实例列表
    private final var iceServers = [RTCPeerConnection]()
    private var peerConnection: RTCPeerConnection?
    private let rtcAudioSession =  RTCAudioSession.sharedInstance()
    private var mCallback:EngineCallback?
    public var mIsAudioOnly:Bool

    private let audioQueue = DispatchQueue(label: "audio")
    
    var isOffer = false
    var userId = ""
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private var videoCapturer: RTCVideoCapturer?
    private var localVideoTrack: RTCVideoTrack?
    private var remoteVideoTrack: RTCVideoTrack?
    private var localDataChannel: RTCDataChannel?
    private var remoteDataChannel: RTCDataChannel?
    
    private let mediaConstrains = [kRTCMediaConstraintsOfferToReceiveAudio: kRTCMediaConstraintsValueTrue,
                                   kRTCMediaConstraintsOfferToReceiveVideo: kRTCMediaConstraintsValueTrue]
    
    weak var delegate:EngineCallback?
    weak var rtcDelegate:JXWebRtcEngineDelegate?
    init(mIsAudioOnly:Bool) {
        self.mIsAudioOnly = mIsAudioOnly
        super.init()
        // 初始化ice地址
        self.initIceServer();
    }
    
    func initIceServer(){
        
        let config = RTCConfiguration()
        let server = RTCIceServer(urlStrings: Config.default.webRTCIceServers, username: "admin", credential: "123456")
        config.iceServers = [server]
        
        // Unified plan is more superior than planB
        config.sdpSemantics = .unifiedPlan
        
        // gatherContinually will let WebRTC to listen to any network changes and send any new candidates to the other client
        config.continualGatheringPolicy = .gatherContinually
        
        // Define media constraints. DtlsSrtpKeyAgreement is required to be true to be able to connect with web browsers.
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil,
                                              optionalConstraints: ["DtlsSrtpKeyAgreement":kRTCMediaConstraintsValueTrue])
        
        guard let peerConnection = JXWebRtcEngine.factory.peerConnection(with: config, constraints: constraints, delegate: nil) else {
            fatalError("Could not create new RTCPeerConnection")
        }
        self.peerConnection = peerConnection
        
        iceServers.append(peerConnection)
        self.createMediaSenders()
       
        self.configureAudioSession()
        self.peerConnection!.delegate = self
    }
    
    private func createMediaSenders() {
        let streamId = "stream"
        
        // Audio
        let audioTrack = self.createAudioTrack()
        self.peerConnection?.add(audioTrack, streamIds: [streamId])
        
        // Video
        let videoTrack = self.createVideoTrack()
        
        self.localVideoTrack = videoTrack
        self.peerConnection?.add(videoTrack, streamIds: [streamId])
        
        self.remoteVideoTrack = self.peerConnection?.transceivers.first { $0.mediaType == .video }?.receiver.track as? RTCVideoTrack
        
        // Data
        if let dataChannel = createDataChannel() {
            dataChannel.delegate = self
            self.localDataChannel = dataChannel
        }
    }
    
    private func configureAudioSession() {
        self.rtcAudioSession.lockForConfiguration()
        do {
            try self.rtcAudioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try self.rtcAudioSession.setMode(AVAudioSession.Mode.voiceChat)
        } catch let error {
            debugPrint("Error changeing AVAudioSession category: \(error)")
        }
        self.rtcAudioSession.unlockForConfiguration()
    }
    
    private func createDataChannel() -> RTCDataChannel? {
        let config = RTCDataChannelConfiguration()
        guard let dataChannel = self.peerConnection?.dataChannel(forLabel: "WebRTCData", configuration: config) else {
            debugPrint("Warning: Couldn't create data channel.")
            return nil
        }
        return dataChannel
    }
    
    private func createAudioTrack() -> RTCAudioTrack {
        let audioConstrains = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        let audioSource = JXWebRtcEngine.factory.audioSource(with: audioConstrains)
        let audioTrack = JXWebRtcEngine.factory.audioTrack(with: audioSource, trackId: "audio0")
        return audioTrack
    }
    
    private func createVideoTrack() -> RTCVideoTrack {
        let videoSource = JXWebRtcEngine.factory.videoSource()
        
        #if targetEnvironment(simulator)
        self.videoCapturer = RTCFileVideoCapturer(delegate: videoSource)
        #else
        self.videoCapturer = RTCCameraVideoCapturer(delegate: videoSource)
        self.videoCapturer?.delegate = self
        #endif
        
        let videoTrack = JXWebRtcEngine.factory.videoTrack(with: videoSource, trackId: "video0")
        return videoTrack
    }
    
    private static let factory: RTCPeerConnectionFactory = {
        RTCInitializeSSL()
        let videoEncoderFactory = RTCDefaultVideoEncoderFactory()
        let videoDecoderFactory = RTCDefaultVideoDecoderFactory()
        return RTCPeerConnectionFactory(encoderFactory: videoEncoderFactory, decoderFactory: videoDecoderFactory)
    }()
    
    // MARK: Signaling
    func offer(completion: @escaping (_ sdp: RTCSessionDescription) -> Void) {
        let constrains = RTCMediaConstraints(mandatoryConstraints: self.mediaConstrains,
                                             optionalConstraints: nil)
        self.peerConnection!.offer(for: constrains) { (sdp, error) in
            guard let sdp = sdp else {
                return
            }
            
            self.peerConnection?.setLocalDescription(sdp, completionHandler: { (error) in
                completion(sdp)
            })
        }
    }
    
    func answer(completion: @escaping (_ sdp: RTCSessionDescription) -> Void)  {
        let constrains = RTCMediaConstraints(mandatoryConstraints: self.mediaConstrains,
                                             optionalConstraints: nil)
        self.peerConnection!.answer(for: constrains) { (sdp, error) in
            guard let sdp = sdp else {
                return
            }
            
            self.peerConnection?.setLocalDescription(sdp, completionHandler: { (error) in
                completion(sdp)
            })
        }
    }
    func set(remoteSdp: RTCSessionDescription, completion: @escaping (Error?) -> ()) {
        self.peerConnection!.setRemoteDescription(remoteSdp, completionHandler: completion)
    }
    
    func set(remoteCandidate: RTCIceCandidate, completion: @escaping (Error?) -> ()) {
        self.peerConnection!.add(remoteCandidate, completionHandler: completion)
        
        
        
    }
    
    // MARK: Media
    func startCaptureLocalVideo(renderer: RTCVideoRenderer) {
        guard let capturer = self.videoCapturer as? RTCCameraVideoCapturer else {
            return
        }

        guard
            let frontCamera = (RTCCameraVideoCapturer.captureDevices().first { $0.position == .front }),
        
            // choose highest res
            let format = (RTCCameraVideoCapturer.supportedFormats(for: frontCamera).sorted { (f1, f2) -> Bool in
                let width1 = CMVideoFormatDescriptionGetDimensions(f1.formatDescription).width
                let width2 = CMVideoFormatDescriptionGetDimensions(f2.formatDescription).width
                return width1 < width2
            }).last,
        
            // choose highest fps
            let fps = (format.videoSupportedFrameRateRanges.sorted { return $0.maxFrameRate < $1.maxFrameRate }.last) else {
            return
        }

        capturer.startCapture(with: frontCamera,
                              format: format,
                              fps: Int(fps.maxFrameRate))
        
        self.localVideoTrack?.add(renderer)
    }
    
    func speakerOn() {
        self.audioQueue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.rtcAudioSession.lockForConfiguration()
            do {
                try self.rtcAudioSession.setCategory(AVAudioSession.Category.playAndRecord)
                try self.rtcAudioSession.overrideOutputAudioPort(.speaker)
                try self.rtcAudioSession.setActive(true)
            } catch let error {
                debugPrint("Couldn't force audio to speaker: \(error)")
            }
            self.rtcAudioSession.unlockForConfiguration()
        }
    }
    
    // Fallback to the default playing device: headphones/bluetooth/ear speaker
    func speakerOff() {
        self.audioQueue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.rtcAudioSession.lockForConfiguration()
            do {
                try self.rtcAudioSession.setCategory(AVAudioSession.Category.playAndRecord)
                try self.rtcAudioSession.overrideOutputAudioPort(.none)
            } catch let error {
                debugPrint("Error setting AVAudioSession category: \(error)")
            }
            self.rtcAudioSession.unlockForConfiguration()
        }
    }
    
    
    func renderRemoteVideo(to renderer: RTCVideoRenderer) {
        self.remoteVideoTrack?.add(renderer)
    }
   
}

extension JXWebRtcEngine: RTCDataChannelDelegate {
    func dataChannelDidChangeState(_ dataChannel: RTCDataChannel) {
        debugPrint("dataChannel did change state: \(dataChannel.readyState)")
    }
    
    func dataChannel(_ dataChannel: RTCDataChannel, didReceiveMessageWith buffer: RTCDataBuffer) {
//        self.RtcDelegate?.webRTCClient(self, didReceiveData: buffer.data)
    }
}

extension JXWebRtcEngine:RTCPeerConnectionDelegate{
    
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        debugPrint("peerConnection new signaling state: \(stateChanged)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        debugPrint("peerConnection did add stream")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        debugPrint("peerConnection did remove stream")
    }
    
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        debugPrint("peerConnection should negotiate")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        debugPrint("peerConnection new connection state: \(newState)")
//        self.delegate?.webRTCClient(self, didChangeConnectionState: newState)
        let textColor: UIColor
        switch newState {
        case .connected, .completed:
            textColor = .green
        case .disconnected:
            textColor = .orange
        case .failed, .closed:
            textColor = .red
        case .new, .checking, .count:
            textColor = .black
        @unknown default:
            textColor = .black
        }
        
        DispatchQueue.main.async {
            
            let localRenderer = RTCMTLVideoView(frame: JXEngineKit.shared.localView.frame)
            localRenderer.videoContentMode = .scaleAspectFill
            self.startCaptureLocalVideo(renderer: localRenderer)
//            if JXEngineKit.shared.localView != nil {
                self.embedView(localRenderer, into: JXEngineKit.shared.localView)
//            }
            ManagerTool.shared.webRTCClient?.speakerOn()
          
            
            let remoteRenderer = RTCMTLVideoView(frame: JXEngineKit.shared.remoteView.frame)
          
            remoteRenderer.videoContentMode = .scaleAspectFill
            
            self.embedView(remoteRenderer, into: JXEngineKit.shared.remoteView)
            
            JXEngineKit.shared.remoteView.sendSubviewToBack(remoteRenderer)
            
            self.renderRemoteVideo(to: remoteRenderer)
            
        }
        
    }
    private func embedView(_ view: UIView, into containerView: UIView) {
        containerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view":view]))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view":view]))
        containerView.layoutIfNeeded()
    }
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        debugPrint("peerConnection new gathering state: \(newState)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        
        self.rtcDelegate?.webRTCClient(self, didDiscoverLocalCandidate: candidate)
        
//        self.delegate?.webRTCClient(self, didDiscoverLocalCandidate: candidate)
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        debugPrint("peerConnection did remove candidate(s)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        debugPrint("peerConnection did open data channel")
        self.remoteDataChannel = dataChannel
    }
    
  
}

extension JXWebRtcEngine:RTCVideoCapturerDelegate{
    func capturer(_ capturer: RTCVideoCapturer, didCapture frame: RTCVideoFrame) {
        
        guard let buffer: RTCCVPixelBuffer = frame.buffer as? RTCCVPixelBuffer else {
                   print("error - 1")
                   return
               }
//        guard _;: RTCCVPixelBuffer = frame.buffer as? RTCCVPixelBuffer else {
//                   print("error - 1")
//                   return
//               }
//               let input: FURenderInput = FURenderInput()
//               input.pixelBuffer = buffer.pixelBuffer
//               let output: FURenderOutput = FURenderKit.share().render(with: input)
//        let nrwbuffer: RTCCVPixelBuffer = RTCCVPixelBuffer.init(pixelBuffer: buffer )
               let newframe = RTCVideoFrame(buffer: buffer, rotation: frame.rotation, timeStampNs: frame.timeStampNs)
//               // 2、显示画面
//       //            self.renderView?.renderFrame(newframe)
//               // 3、重新把代理响应给videoSource
               self.localVideoTrack?.source.capturer(capturer, didCapture: newframe)
        
        
    }
    
}

extension JXWebRtcEngine:IEngine{
    func initE(callback: EngineCallback) {
        delegate = callback
//        createMediaSenders()
        
    }
    
    func joinRoom(userIds: [String]) {
        
        self.isOffer = false
        if (mCallback != nil) {
            mCallback!.joinRoomSucc();
        }
        
        self.userId = userIds[0]
        
      
    }
    
    func userIn(userId: String) {
        
        self.isOffer = true
        self.userId = userId
//        Log.d(TAG, "userIn: " + userId);
//              // create Peer
//              Peer peer = new Peer(_factory, iceServers, userId, this);
//              peer.setOffer(true);
//              // add localStream
//              List<String> mediaStreamLabels = Collections.singletonList("ARDAMS");
//              if (_localVideoTrack != null) {
//                  peer.addVideoTrack(_localVideoTrack, mediaStreamLabels);
//              }
//              if (_localAudioTrack != null) {
//                  peer.addAudioTrack(_localAudioTrack, mediaStreamLabels);
//              }
//              // 添加列表
//              peers.put(userId, peer);
//              // createOffer
//
//        self.sendDSP()
        
        self.offer { sdp in
            
            self.delegate?.onSendOffer(userId: userId, description: sdp)
            
            }
        
        
      
        
        
    }
    
    func sendDSP(){
        if (self.peerConnection == nil) {return;}
        if self.isOffer {
            if (self.peerConnection?.remoteDescription == nil) {
                if (!isOffer) {
                        //接收者，发送Answer
                    self.answer { sdp in
                        self.delegate?.onSendAnswer(userId: self.userId, description: sdp)
                    }
                   
                    } else {
                        //发送者,发送自己的offer
                        self.offer { sdp in
                            
                            let message = Message.sdp(SessionDescription(from: sdp))
                            do {
                                let dataMessage = try self.encoder.encode(message)
                                self.delegate?.onSendOffer(userId: "456", description: sdp)
                            }catch {
                                debugPrint("Warning: Could not encode sdp: \(error)")
                            }
                        }
                    }
            }else{
                debugPrint("Remote SDP set succesfully");
            }
            
        }else{
         
            if (self.peerConnection?.localDescription != nil) {
                debugPrint("Local SDP set succesfully");
                if (!isOffer) {
                    //接收者，发送Answer
                    self.answer { sdp in
                        self.delegate?.onSendAnswer(userId: self.userId, description: sdp)
                    }
                }else{
                    //发送者,发送自己的offer
                    self.offer { sdp in
                        
                        let message = Message.sdp(SessionDescription(from: sdp))
                        do {
                            let dataMessage = try self.encoder.encode(message)
                            self.delegate?.onSendOffer(userId: self.userId, description: sdp)
                        }catch {
                            debugPrint("Warning: Could not encode sdp: \(error)")
                        }
                    }
                }
            }else{
                debugPrint("Remote SDP set succesfully");
            }
            
        }
        
    }
        
        
    
    func userReject(userId: String, type: Int) {
        
    }
    
    func disconnected(userId: String, reason: EnumType.CallEndReason) {
        
    }
    
    func receiveOffer(userId: String, description: String) {
//        Peer peer = peers.get(userId);
//               if (peer != null) {
//                   SessionDescription sdp = new SessionDescription(SessionDescription.Type.OFFER, description);
//                   peer.setOffer(false);
//                   peer.setRemoteDescription(sdp);
//                   peer.createAnswer();
//               }
        
        let remot  = RTCSessionDescription(type: .offer, sdp: description)
        
        self.set(remoteSdp: remot) { error in
            if error == nil{
                self.isOffer = false
//                self.sendDSP()
                
                
                
              
                
                
                self.answer { sdp in
                    self.delegate?.onSendAnswer(userId: self.userId, description: sdp)
                    
                 
                
                    
                }
                
            }
            
        }
        
    }
    
    func receiveAnswer(userId: String, sdp: String) {
        debugPrint("receiveAnswer--" + userId);
//              Peer peer = peers.get(userId);
//              if (peer != null) {
//                  SessionDescription sessionDescription = new SessionDescription(SessionDescription.Type.ANSWER, sdp);
//                  peer.setRemoteDescription(sessionDescription);
//              }
        
        
        let remot  = RTCSessionDescription(type: .answer, sdp: sdp)
        self.set(remoteSdp: remot) { error in
            
        }
        
        
    }
    
    func receiveIceCandidate(userId: String, id: String, label: Int, candidate: String) {
        debugPrint( "receiveIceCandidate--" + userId);

        
        let candidate = RTCIceCandidate(sdp: candidate, sdpMLineIndex: Int32(label), sdpMid: id)
//        self.peerConnection?.add(candidate, completionHandler: { error in
//        
//        })
        
        self.set(remoteCandidate: candidate) { error in
            
        }
//        self.set(remoteCandidate: candidate) { error in
//            
//        }// erConnection?.add(<#T##candidate: RTCIceCandidate##RTCIceCandidate#>, completionHandler: <#T##(Error?) -> Void#>)
        
    }
    
    func leaveRoom(userId: String) {
        
    }
    
    func setupLocalPreview(isOverlay: Bool) {
        
    }
    
    func stopPreview() {
        self.videoCapturer = nil
      
//        JXWebRtcEngine.factory.stopAecDump()
        
        ManagerTool.shared.webRTCClient?.localVideoTrack?.isEnabled = false
        ManagerTool.shared.webRTCClient?.remoteVideoTrack?.isEnabled = false
        ManagerTool.shared.webRTCClient?.peerConnection?.close()
        ManagerTool.shared.webRTCClient?.peerConnection = nil
        
    }
    
    func startStream() {
        
    }
    
    func stopStream() {
        
    }
    
    func setupRemoteVideo(userId: String, isO: Bool) -> UIView {
        return UIView()
    }
    
    func stopRemoteVideo() {
        
    }
    
    func switchCamera() {
        
    }
    
    func muteAudio(enable: Bool) -> Bool {
        return true
    }
    
    func toggleSpeaker(enable: Bool) -> Bool {
        return true
    }
    
    func toggleHeadset(isHeadset: Bool) -> Bool {
        return true
    }
    
    
}
