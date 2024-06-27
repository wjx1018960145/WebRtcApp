//
//  Table.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/14.
//

import Foundation
import HandyJSON
import WCDBSwift
class BaseMode:HandyJSON {
    required init() {}

    func mapping(mapper: HelpingMapper) {}
    
   
}

class UserList:BaseMode{
    var list = [UserMode]()
}

class UserMode:BaseMode,TableCodable{
    
    static let tableName = "LoginInfo"
    enum CodingKeys:String,CodingTableKey {
        typealias Root = UserMode
        
        case userName
        case userId
        case phone
        case avatar
        case token
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .userId: ColumnConstraintBinding(isPrimary: true, isUnique: true)
            ]
        }
    }
    
    var userName = ""
    var userId = ""
    var phone = false
    var avatar = ""
    var token = ""
}


class SocketEvenMode:BaseMode{
    
    var  eventName = ""
    var data:EvenMode?
    
    
}

class EvenMode:BaseMode{
    var  userID = ""
    var  roomSize = 0
    var  room  = ""
    var avatar = ""
    var fromID = ""
    var label = 0
    var sdp = ""
    var you = ""
    var connections = ""
    var inviteID = ""
    var userList = ""
    var audioOnly = false
    var refuseType = 0
    var id = ""
    var candidate = ""
}
