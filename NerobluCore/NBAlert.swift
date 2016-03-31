// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// アラートの処理を行うクラス
///
///     NBAlert.showOK(self, message: "メッセージです")
///
///     NBAlert.showYesNo(self, message: "メッセージです") { selectedAnswer in
///         if selectedAnswer.isPositive {
///             // some process
///         }
///     }
///
///     NBAlert.showOKCancel(self, message: "メッセージです", title: "タイトル") { selectedAnswer in
///         if selectedAnswer.isPositive {
///             // some process
///         }
///     }
public class NBAlert {
    
    /// NBAlertのオプション
    public struct NBAlertOptions {
        /// 「OK」選択肢の表示文字列
        public static var OKString = "OK"
        /// 「はい」選択肢の表示文字列
        public static var YesString = "はい"
        /// 「いいえ」選択肢の表示文字列
        public static var NoString = "いいえ"
        /// 「キャンセル」選択肢の表示文字列
        public static var CancelString = "キャンセル"
    }
    
    /// アラートに対するユーザの回答
    public enum Answer {
        case OK
        case YES
        case NO
        case CANCEL
        
        /// ユーザが肯定的な選択をしたかどうかを返却する
        public var isPositive: Bool {
            switch (self) {
            case .OK, .YES:
                return true
            default:
                return false
            }
        }
        
        /// ユーザが否定的な選択をしたかどうかを返却する
        public var isNegative: Bool {
            return !self.isPositive
        }
        
        /// 選択肢文字列
        public var text: String {
            switch (self) {
            case .OK:     return NBAlertOptions.OKString
            case .YES:    return NBAlertOptions.YesString
            case .NO:     return NBAlertOptions.NoString
            case .CANCEL: return NBAlertOptions.CancelString
            }
        }
    }
    
    /// アラートのボタン押下時のイベントハンドラ
    public typealias DidTapHandler = (Answer) -> Void
    
    /// 「OK」のみのアラートを表示する
    /// - parameter controller: 表示を行うビューコントローラ
    /// - parameter message: メッセージ文言
    /// - parameter title: タイトル文言(省略可)
    /// - parameter handler: アラートのボタン押下時のイベントハンドラ
    public class func showOK(controller: UIViewController, message: String, title: String? = nil, handler: DidTapHandler? = nil) {
        let actions = [
            makeAction(.OK, style: .Default, handler: handler),
        ]
        show(controller, message: message, title: title, handler: handler, actions: actions)
    }
    
    /// 「はい/いいえ」のアラートを表示する
    /// - parameter controller: 表示を行うビューコントローラ
    /// - parameter message: メッセージ文言
    /// - parameter title: タイトル文言(省略可)
    /// - parameter handler: アラートのボタン押下時のイベントハンドラ
    public class func showYesNo(controller: UIViewController, message: String, title: String? = nil, handler: DidTapHandler? = nil) {
        let actions = [
            makeAction(.YES, style: .Default, handler: handler),
            makeAction(.NO,  style: .Cancel,  handler: handler),
        ]
        show(controller, message: message, title: title, handler: handler, actions: actions)
    }
    
    /// 「OK/キャンセル」のアラートを表示する
    /// - parameter controller: 表示を行うビューコントローラ
    /// - parameter message: メッセージ文言
    /// - parameter title: タイトル文言(省略可)
    /// - parameter handler: アラートのボタン押下時のイベントハンドラ
    public class func showOKCancel(controller: UIViewController, message: String, title: String? = nil, handler: DidTapHandler? = nil) {
        let actions = [
            makeAction(.YES, style: .Default, handler: handler),
            makeAction(.NO,  style: .Cancel,  handler: handler),
        ]
        show(controller, message: message, title: title, handler: handler, actions: actions)
    }
    
    /// アラートを表示する
    /// - parameter controller: 表示を行うビューコントローラ
    /// - parameter message: メッセージ文言
    /// - parameter title: タイトル文言
    /// - parameter handler: アラートのボタン押下時のイベントハンドラ
    /// - parameter actions: 表示するUIAlertActionの配列
    private class func show(controller: UIViewController, message: String, title: String?, handler: DidTapHandler?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        for action in actions {
            alert.addAction(action)
        }
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    
    /// UIAlertActionオブジェクトを生成する
    /// - parameter answer: アラートに対するユーザの回答
    /// - parameter style: アクションスタイル(ボタンの種別)
    /// - parameter handler: アラートのボタン押下時のイベントハンドラ
    /// - returns: 新しいUIAlertActionオブジェクト
    private class func makeAction(answer: Answer, style: UIAlertActionStyle, handler: DidTapHandler?)->UIAlertAction {
        return UIAlertAction(title: answer.text, style: style) { action in
            if let handler = handler {
                handler(answer)
            }
        }
    }
}

