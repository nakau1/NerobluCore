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
    
    private var inKeyboardAnimation = false
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
        if self.inKeyboardAnimation { return }
        self.inKeyboardAnimation = true
        
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
        if endY > SCREEN_HEIGHT * 2 { return }
        
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
            completion: { finished in
                self.inKeyboardAnimation = false
            }
        )
    }
}

// MARK: - ビューコントローラ拡張 -
public extension NBViewController {
    
    /// キーボードイベント監視オブジェクト
    public var keyboardEvent: NBKeyboardEvent? {
        get {
            return self.externalComponents["NBKeyboardEvent"] as? NBKeyboardEvent
        }
        set(v) {
            self.externalComponents["NBKeyboardEvent"] = v
        }
    }
}

/*
public protocol UITextFieldDelegate : NSObjectProtocol {
	

	optional public func textFieldShouldBeginEditing(textField: UITextField) -> Bool // return NO to disallow editing.
	optional public func textViewShouldBeginEditing(textView: UITextView) -> Bool


	optional public func textFieldDidBeginEditing(textField: UITextField) // became first responder
	optional public func textViewDidBeginEditing(textView: UITextView)


	optional public func textFieldShouldEndEditing(textField: UITextField) -> Bool
	optional public func textViewShouldEndEditing(textView: UITextView) -> Bool

	optional public func textFieldDidEndEditing(textField: UITextField)
	optional public func textViewDidEndEditing(textView: UITextView)

	optional public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
	optional public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool

	optional public func textFieldShouldClear(textField: UITextField) -> Bool

	optional public func textFieldShouldReturn(textField: UITextField) -> Bool
}

public protocol UITextViewDelegate : NSObjectProtocol, UIScrollViewDelegate {
	
	

	optional public func textViewDidChange(textView: UITextView)
	

	optional public func textViewDidChangeSelection(textView: UITextView)
	

	optional public func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool

	optional public func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool
}
*/

/*
/// キーボードのフレームが変更される時
func willKeyboardChangeFrame(notify: NSNotification) {
	// アニメーション中は他の同名通知を無視
	if inKeyboardAnimation { return }
	inKeyboardAnimation = true
	
	guard
		let userInfo = notify.userInfo,
		let frameBegin = userInfo[UIKeyboardFrameBeginUserInfoKey]        as? NSValue,
		let frameEnd   = userInfo[UIKeyboardFrameEndUserInfoKey]          as? NSValue,
		let curve      = userInfo[UIKeyboardAnimationCurveUserInfoKey]    as? NSNumber,
		let duration   = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval
		else {
			return
	}
	
	let beginY   = frameBegin.CGRectValue().minY
	let endY     = frameEnd.CGRectValue().minY
	let options  = UIViewAnimationOptions(rawValue: UInt(curve))
	
	UIView.animateWithDuration(duration, delay: 0, options: options,
		animations: {
			let diff = endY - beginY
			self.tableView.frame.origin.y += diff
		},
		completion: { finished in
			self.inKeyboardAnimation = false
	})
}

/// テーブル内からのイベント通知の監視を開始または終了する
/// - parameters:
///   - start: true=開始 / false=終了
func observeEventsOfContents(start: Bool) {
	let nc = NSNotificationCenter.defaultCenter()
	let eventsOfContents = [
		"willKeyboardChangeFrame:" : UIKeyboardWillChangeFrameNotification,
	]
	
	for (selector, name) in eventsOfContents {
		if start {
			nc.addObserver(self, selector: Selector(selector), name: name, object: nil)
		} else {
			nc.removeObserver(self, name: name, object: nil)
		}
	}
}
*/