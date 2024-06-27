//
//  DBManger.swift
//  LanMaoVoice
//
//  Created by 王翔-iOS-蓝猫网络 on 2022/4/15.
//

import UIKit
import WCDBSwift
let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! + "/WCDBDataBase/WCDBSwift.db"

public class DBManger: NSObject {
    public static let shared = DBManger()

    public static let defaultDatabase: Database = {
        return Database.init(withFileURL: URL.init(fileURLWithPath: dbPath))
    }()

    var dataBase: Database?
    private override init() {
        super.init()
        dataBase = createDb()

    }

    /// 创建db
    private func createDb() -> Database {
        print("数据库路径\(dbPath)")
        return Database(withFileURL: URL.init(fileURLWithPath: dbPath))
    }

    /// 创建表
    public func createTable<T: TableDecodable>(table: String, of type: T.Type) {
        do {
            try dataBase?.create(table: table, of: type)
        } catch {
            print(error.localizedDescription)
        }
    }

    /// 插入
    public func insertToDb<T: TableEncodable>(objects: [T], table: String) {
        do {
            /// 如果主键存在的情况下，插入就会失败
            /// 执行事务
            try dataBase?.run(transaction: {
                try dataBase?.insert(objects: objects, intoTable: table)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    /// 插入或更新
    public func insertOrReplaceToDb<T: TableEncodable>(object: T, table: String) {
        do {
            /// 执行事务
            try dataBase?.run(transaction: {
                try dataBase?.insertOrReplace(objects: object, intoTable: table)
            })
        } catch {
            print(error.localizedDescription)
        }
    }

    /// 修改
    public func updateToDb<T: TableEncodable>(table: String, on propertys: [PropertyConvertible], with object: T, where condition: Condition? = nil) {
        do {
            try dataBase?.update(table: table, on: propertys, with: object, where: condition)
        } catch {
            print(error.localizedDescription)
        }
    }

    /// 删除
    public func deleteFromDb(fromTable: String, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: WCDBSwift.Offset? = nil) {
        do {
            try dataBase?.run(transaction: {
                try dataBase?.delete(fromTable: fromTable, where: condition, orderBy: orderList, limit: limit, offset: offset)
            })
        } catch {
            print(error.localizedDescription)
        }
    }

    /// 查询
    public func qureyObjectsFromDb<T: TableDecodable>(fromTable: String, cls cName: T.Type, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: ExpressionConvertible? = nil) -> [T]? {
        do {
            let allObjects: [T] = try (dataBase?.getObjects(fromTable: fromTable, where: condition, orderBy: orderList, limit: limit, offset: offset))!
            return allObjects
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    /// 查询单条数据
    public func qureySingleObjectFromDb<T: TableDecodable>(fromTable: String, cls cName: T.Type, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil) -> T? {
        do {
            let object: T? = try (dataBase?.getObject(fromTable: fromTable, where: condition, orderBy: orderList))
            return object
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

}
