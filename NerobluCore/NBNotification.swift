// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// NSNotificationCenterの拡張
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

public extension NBViewController {
    
    /// 監視する通知とそのセレクタの設定を返却する
    ///
    /// 例えば下記のように実装するとキーボードイベントがハンドルできます
    ///
    ///	func keyboardWillChangeFrame(n: NSNotification) {
    ///	  // 何か処理
    ///	}
    ///
    ///	override func observingNotifications() -> [String : String] {
    ///	  var ret = super.observingNotifications()
    ///	  ret["keyboardWillChangeFrame:"] = UIKeyboardWillChangeFrameNotification
    ///	  return ret
    ///	}
    ///
    /// - returns: 通知時に実行するセレクタ名と通知文字列をセットにした辞書
    public func observingNotifications()->[String : String] { return [:] }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().observeNotifications(self.observingNotifications(), observer:self, start: true)
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().observeNotifications(self.observingNotifications(), observer:self, start: false)
    }
}
