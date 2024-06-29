//
//  Api.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/13.
//

import Foundation
import Moya
enum ApiService{
    case login(login:String)
    case getUser
}

extension ApiService:TargetType{
    //服务器跟地址
    var baseURL: URL {
//        let url="http://10.42.0.51:8080/"
//        let url="http://192.168.1.13:8080/"
//        let url="http://192.168.43.193:8080/"
        return URL(string: Config.default.base)!
    }
    //路径
    var path: String {
        switch self{
        case .login:
            return "login/loginUser"
            
        case .getUser:
            return "userList"
        }
    }
    //请求方法
    var method: Moya.Method {
        return .post
    }
    //task参数设置
    var task: Moya.Task {
        switch self{
        case .login(let login):
            //参数是body实体类型的就这样
            return .requestPlain
               //参数是query类型的，就这样
        case .getUser:
//            let params:[String:Int] = ["page":page]
            return .requestPlain
        }
    }
    //头信息
    var headers: [String : String]? {
        var headers:Dictionary<String,String> = [:]
        headers["Content-Type"]="application/json"
//        headers["token"]="41aaf0d73b7d4e739f50c9c92924378d"
        return headers
    }
}


@_exported import MBProgressHUD
@_exported import RxCocoa
@_exported import HandyJSON
@_exported import SnapKit
