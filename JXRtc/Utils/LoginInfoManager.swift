//
//  LoginInfoManager.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/14.
//

import UIKit

class LoginInfoManager: NSObject {
    static let shared = LoginInfoManager.init()

    private (set) var userInfo: UserMode {
        set {

        }
        get {
            guard let model = DBManger.shared.qureySingleObjectFromDb(fromTable: UserMode.tableName, cls: UserMode.self) else { return UserMode.init() }
            return model
        }
    }

    /**更新或者存储信息**/
    static func save_updata(info: UserMode) {
        LoginInfoManager.shared.saveUpdate(info: info)
    }

    static func loginOut() {
        DBManger.shared.deleteFromDb(fromTable: UserMode.tableName)
       
       
    }

    private override init() {
        DBManger.shared.createTable(table: UserMode.tableName, of: UserMode.self)
    }

}
extension LoginInfoManager {

    private func saveUpdate(info: UserMode) {
        DBManger.shared.deleteFromDb(fromTable: UserMode.tableName)
        DBManger.shared.insertOrReplaceToDb(object: info, table: UserMode.tableName)
    }

}

extension LoginInfoManager {
    static func uid() -> String {
        LoginInfoManager.shared.userInfo.userId
    }

    static func token() -> String {
        LoginInfoManager.shared.userInfo.token
    }

    static func chatCode() -> String {
        LoginInfoManager.shared.userInfo.userId
    }
}
