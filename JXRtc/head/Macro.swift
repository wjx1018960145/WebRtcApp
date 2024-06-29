//
//  Macro.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/14.
//

import Foundation
let kScreenWidth = UIScreen.main.bounds.size.width
/// 屏幕高
let kScreenHeight = UIScreen.main.bounds.size.height

/// 状态栏高
let kStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
/// 导航栏高
let kNavBarHeight: CGFloat = 44.0
/// 状态栏+导航栏总高度
let kTopBarTotalHeight: CGFloat = kStatusBarHeight + kNavBarHeight
/// tabBar高度
let kTabBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height > 20 ? 83.0 : 49.0
/// 底部安全距离
let kSafeAreaBottom: CGFloat = UIApplication.shared.statusBarFrame.height > 20 ? 34 : 0

let kSafeBtnBottom: CGFloat = UIApplication.shared.statusBarFrame.height > 20 ? 34 : 10

