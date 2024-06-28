//
//  StarscreamProvider.swift
//  WebRTC-Demo
//
//  Created by stasel on 15/07/2019.
//  Copyright © 2019 stasel. All rights reserved.
//

import Foundation
//import Starscream

class StarscreamWebSocket {
    var delegate: (any WebSocketProviderDelegate)?
    
    func connect(chatCode: String) {
        
    }
    
    func send(data: Data) {
        
    }
    
    func unconnect() {
        
    }
    
//
//    var delegate: WebSocketProviderDelegate?
//    private var socket: WebSocket?
//    var url:String
//    init(url: String) {
//        self.url = url
//       
//    }
//    
//    func connect(chatCode:String) {
//        let URL = URL(string: url+"\(chatCode)/0")!
//        
//        let request = URLRequest(url: URL)
//        
//        self.socket = WebSocket(request: request)
//        self.socket!.delegate = self
//        self.socket!.connect()
//    }
//    func unconnect(){
//        self.socket!.disconnect()
//        
//    }
//    func send(data: Data) {
//        self.socket!.write(data: data)
//    }
}

//extension StarscreamWebSocket: Starscream.WebSocketDelegate {
    
//    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
//        switch event {
//        case .connected:
//            self.delegate?.webSocketDidConnect(self)
//        case .disconnected:
//            self.delegate?.webSocketDidDisconnect(self)
//        case .text:
//            debugPrint("Warning: Expected to receive data format but received a string. Check the websocket server config.")
//        case .binary(let data):
//            self.delegate?.webSocket(self, didReceiveData: data)
//        default:
//            break
//        }
//    }
//}
