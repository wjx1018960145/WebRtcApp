//
//  Config.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/13.
//

import Foundation

// Set this to the machine's address which runs the signaling server. Do not use 'localhost' or '127.0.0.1'

//fileprivate let defaultSignalingServerUrl = "ws://192.168.1.13:8080/ws"
//fileprivate let defaultSignalingServerUrl = "ws://192.168.43.193:8080/ws"
//fileprivate let defaultSignalingServerUrl = "ws://172.20.10.3:8080/ws"
//fileprivate let defaultSignalingServerUrl = "ws://10.42.0.51:8080/ws"

// We use Google's public stun servers. For production apps you should deploy your own stun/turn servers.
//fileprivate let defaultIceServers = ["stun:192.168.1.35:3478",
//                                     "stun:192.168.1.35:3478",
//                                     "stun:192.168.1.35:3478",
//                                     "stun:192.168.1.35:3478",
//                                     "stun:192.168.1.35:3478"]
//fileprivate let defaultIceServers = ["stun:192.168.43.168:3478",
//                                     "stun:192.168.43.168:3478",
//                                     "stun:192.168.43.168:3478",
//                                     "stun:192.168.43.168:3478",
//                                     "stun:192.168.43.168:3478"]
#if Dev

fileprivate let defaultIceServers = ["stun:192.168.1.35:3478",
                                     "stun:192.168.1.35:3478",
                                     "stun:192.168.1.35:3478",
                                     "stun:192.168.1.35:3478",
                                     "turn:192.168.1.35:3478"]
fileprivate let defaultSignalingServerUrl = "ws://192.168.1.13:8080/ws"
fileprivate let baseUrl = "http://192.168.1.13:8080/"

#elseif Pro
fileprivate let defaultIceServers = ["stun:172.20.10.12:3478",
                                     "stun:172.20.10.12:3478",
                                     "stun:172.20.10.12:3478",
                                     "stun:172.20.10.12:3478",
                                     "stun:172.20.10.12:3478"]
fileprivate let defaultSignalingServerUrl = "ws://172.20.10.3:8080/ws"
fileprivate let baseUrl = "http://172.20.10.3:8080/"
#elseif Normal

fileprivate let defaultIceServers = ["stun:192.168.43.168:3478",
                                     "stun:192.168.43.168:3478",
                                     "stun:192.168.43.168:3478",
                                     "stun:192.168.43.168:3478",
                                     "stun:192.168.43.168:3478"]
fileprivate let defaultSignalingServerUrl = "ws://172.20.10.3:8080/ws"

fileprivate let baseUrl = "http://172.20.10.3:8080/"

#endif


//fileprivate let defaultIceServers = ["stun:10.42.0.1:3478",
//                                     "stun:10.42.0.1:3478",
//                                     "stun:10.42.0.1:3478",
//                                     "stun:10.42.0.1:3478",
//                                     "stun:10.42.0.1:3478"]

struct Config {
    let signalingServerUrl: String
    let webRTCIceServers: [String]
    let base:String
    static let `default` = Config(signalingServerUrl: defaultSignalingServerUrl, webRTCIceServers: defaultIceServers,base:baseUrl)
}
