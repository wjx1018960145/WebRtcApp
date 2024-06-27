//
//  CallSessionCallback.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/18.
//

import UIKit

protocol JXCallSessionCallback: AnyObject {

    func didCallEndWithReason(var1:EnumType.CallEndReason );

    func didChangeState( var1:EnumType.CallState);

    func didChangeMode(isAudioOnly:Bool);

    func didCreateLocalVideoTrack();

    func didReceiveRemoteVideoTrack(userId:String);

    func didUserLeave(userId:String);

    func didError( error:String);

    func didDisconnected( userId:String);
}
