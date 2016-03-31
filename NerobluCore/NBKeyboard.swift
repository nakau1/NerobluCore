// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// NBKeyboardEventのデリゲートプロトコル
@objc public protocol NBKeyboardEventDelegate {
    
    /// キーボードの座標変更が始まる時に呼ばれる
    ///
    /// このメソッド内でキーボードに隠れてしまう要素を退避させます
    /// NSLayoutConstraintによる位置変更は、self.view.layoutIfNeeded()を呼ぶことでアニメーションが綺麗に行われます
    ///
    /// - parameter event: NBKeyboardEventオブジェクトの参照
    /// - parameter y: 座標変更後のキーボードのY座標
    /// - parameter height: 座標変更後のキーボードの高さ
    /// - parameter diff: 座標変更後のY座標の変化量
    optional func keyboard(willChangeKeyboardFrame event: NBKeyboardEvent, y: CGFloat, height: CGFloat, diff: CGFloat)
}

/// キーボードイベントに関するイベントの汎用処理を行うクラス
public class NBKeyboardEvent : NSObject {
    
    /// デリゲート
    public weak var delegate: NBKeyboardEventDelegate?
    
    private var keyboardHeight: CGFloat = CGFloat.min
    private var keyboardY:      CGFloat = CGFloat.min
    
    /// キーボードイベントの監視を開始または終了する
    /// - parameter start: 開始/終了
    public func observeKeyboardEvents(start: Bool) {
        let nc = NSNotificationCenter.defaultCenter()
        let notifications = [
            UIKeyboardWillShowNotification,
            UIKeyboardWillChangeFrameNotification,
            UIKeyboardWillHideNotification,
        ]
        
        for notification in notifications {
            if start {
                self.keyboardHeight = CGFloat.min
                self.keyboardY      = CGFloat.min
                nc.addObserver(self, selector: Selector("willChangeKeyboardFrame:"), name: notification, object: nil)
            } else {
                nc.removeObserver(self, name: notification, object: nil)
            }
        }
    }
    
    // イベントハンドラ
    func willChangeKeyboardFrame(notify: NSNotification) {
        guard
            let userInfo   = notify.userInfo,
            let beginFrame = userInfo[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue,
            let endFrame   = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue,
            let curve      = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
            let duration   = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval
            else {
                return
        }
        
        // 初回のみ
        if self.keyboardHeight == CGFloat.min && self.keyboardY == CGFloat.min {
            self.keyboardHeight = crH(beginFrame)
            self.keyboardY      = crY(beginFrame)
        }
        
        let height = crH(endFrame)
        let beginY = crY(beginFrame)
        let endY   = crY(endFrame)
        
        // 別画面でキーボードを表示すると変数yに大きな整数が入ってしまうため
        if endY > App.Dimen.Screen.Height * 2 { return }
        
        // 高さもY座標も変化していない場合は処理抜け
        if self.keyboardHeight == height && self.keyboardY == endY { return }
        
        self.keyboardHeight = height
        self.keyboardY      = endY
        
        let options  = UIViewAnimationOptions(rawValue: UInt(curve))
        
        UIView.animateWithDuration(duration, delay: 0, options: options,
            animations: {
                let diff = endY - beginY
                self.delegate?.keyboard?(willChangeKeyboardFrame: self, y: endY, height: height, diff: diff)
            },
            completion: { finished in }
        )
    }
}

// MARK: - ビューコントローラ拡張 -
public extension NBViewController {
    
    /// キーボードイベント監視オブジェクト
    public var keyboardEvent: NBKeyboardEvent {
        let key = "NBKeyboardEvent"
        if self.externalComponents[key] == nil {
            self.externalComponents[key] = NBKeyboardEvent()
        }
        return self.externalComponents[key] as! NBKeyboardEvent
    }
}
