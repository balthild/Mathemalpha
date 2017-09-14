//
//  HotKey.swift
//  Magnet
//
//  Created by 古林俊佑 on 2016/03/09.
//  Copyright © 2016年 Shunsuke Furubayashi. All rights reserved.
//

import Cocoa
import Carbon

public final class HotKey: Equatable {

    // MARK: - Properties
    public let identifier: String
    public let keyCombo: KeyCombo
    public var target: AnyObject?
    public var action: Selector?
    public var hotKeyId: UInt32?
    public var hotKeyRef: EventHotKeyRef?

    // MARK: - Init
    public init(identifier: String, keyCombo: KeyCombo, target: AnyObject? = nil, action: Selector? = nil) {
        self.identifier = identifier
        self.keyCombo   = keyCombo
        self.target     = target
        self.action     = action
    }
    
}

// MARK: - Invoke
public extension HotKey {
    public func invoke() {
        if let target = target as? NSObject, let selector = action {
            if target.responds(to: selector) {
                target.perform(selector, with: self)
            }
        }
    }
}

// MARK: - Register & UnRegister
public extension HotKey {
    @discardableResult
    public func register() -> Bool {
        return HotKeyCenter.shared.register(with: self)
    }
    public func unregister() {
        return HotKeyCenter.shared.unregister(with: self)
    }
}

// MARK: - Equatable
public func ==(lhs: HotKey, rhs: HotKey) -> Bool {
    return lhs.identifier == rhs.identifier &&
            lhs.keyCombo == rhs.keyCombo &&
            lhs.hotKeyId == rhs.hotKeyId &&
            lhs.hotKeyRef == rhs.hotKeyRef
}
