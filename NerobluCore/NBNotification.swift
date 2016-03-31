// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK: - App拡張 -

public extension App {
    
    /// 通知処理
    public class Notify {
        
        /// 通知の監視を開始する
        /// - parameter observer: 監視するオブジェクト
        /// - parameter selectorName: 通知受信時に動作するセレクタ
        /// - parameter name: 通知文字列
        /// - parameter object: 監視対象のオブジェクト
        public class func add(observer: AnyObject, _ selectorName: String, _ name: String, _ object: AnyObject? = nil) {
            NSNotificationCenter.defaultCenter().addObserver(observer, selector: Selector(selectorName), name: name, object: object)
        }
        
        /// 通知の監視を終了する
        /// - parameter observer: 監視解除するオブジェクト
        /// - parameter name: 通知文字列
        /// - parameter object: 監視対象のオブジェクト
        public class func remove(observer: AnyObject, _ name: String, _ object: AnyObject? = nil) {
            NSNotificationCenter.defaultCenter().removeObserver(observer, name: name, object: object)
        }
        
        /// 渡したNSNotificationオブジェクトに紐づく通知監視を終了する
        /// - parameter observer: 監視するオブジェクト
        /// - parameter notification: NSNotificationオブジェクト
        public class func remove(observer: NSObject, _ notification: NSNotification) {
            NSNotificationCenter.defaultCenter().removeObserver(observer, notification: notification)
        }
        
        /// 通知を行う
        /// - parameter name: 通知文字列
        /// - parameter object: 通知をするオブジェクト
        /// - parameter userInfo: 通知に含める情報
        public class func post(name: String, _ object: AnyObject? = nil, _ userInfo: [NSObject : AnyObject]? = nil) {
            NSNotificationCenter.defaultCenter().postNotificationName(name, object: object, userInfo: userInfo)
        }
    }
}

// MARK: - NSNotificationCenterの拡張 -

public extension NSNotificationCenter {
    
    /// 通知の監視開始/終了の設定を一括で行う
    /// - parameter selectorAndNotificationNames: 通知時に実行するセレクタ名と通知文字列をセットにした辞書
    /// - parameter observer: 監視するオブジェクト
    /// - parameter start: 監視の開始または終了
    public func observeNotifications(selectorAndNotificationNames: [String : String], observer: AnyObject, start: Bool) {
        for e in selectorAndNotificationNames {
            let name = e.1
            if start {
                let selector = Selector(e.0)
                self.addObserver(observer, selector: selector, name: name, object: nil)
            } else {
                self.removeObserver(observer, name: name, object: nil)
            }
        }
    }
    
    /// 渡したNSNotificationオブジェクトに紐づく通知監視を解除する
    /// - parameter observer: 監視するオブジェクト
    /// - parameter notification: NSNotificationオブジェクト
    public func removeObserver(observer: NSObject, notification: NSNotification) {
        self.removeObserver(observer, name: notification.name, object: notification.object)
    }
}

// MARK: - NBViewController拡張 -

public extension NBViewController {
    
    /// 監視する通知とそのセレクタの設定を返却する
    ///
    /// 例えば下記のように実装するとキーボードイベントがハンドルできます
    ///
    ///     func keyboardWillChangeFrame(n: NSNotification) {
    ///     // 何か処理
    ///     }
    ///
    ///     override func observingNotifications() -> [String : String] {
    ///         var ret = super.observingNotifications()
    ///         ret["keyboardWillChangeFrame:"] = UIKeyboardWillChangeFrameNotification
    ///         return ret
    ///     }
    ///
    /// - returns: 通知時に実行するセレクタ名と通知文字列をセットにした辞書
    public func observingNotifications() -> [String : String] { return [:] }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().observeNotifications(self.observingNotifications(), observer:self, start: true)
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().observeNotifications(self.observingNotifications(), observer:self, start: false)
    }
}
