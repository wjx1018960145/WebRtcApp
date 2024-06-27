//
//  ConcurrentHashMap.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/18.
//

import UIKit

class ConcurrentHashMap<Key: Hashable, Value> {

    private var queue = DispatchQueue(label: "ConcurrentHashMapQueue", attributes: .concurrent)
       private var dictionary: [Key: Value] = [:]
    
       func setValue(_ value: Value, forKey key: Key) {
           queue.async(flags: .barrier) {
               self.dictionary[key] = value
           }
       }
    
       func value(forKey key: Key) -> Value? {
           var result: Value?
           queue.sync {
               result = self.dictionary[key]
           }
           return result
       }
    
       func removeValue(forKey key: Key) {
           queue.async(flags: .barrier) {
               self.dictionary.removeValue(forKey: key)
           }
       }
}
