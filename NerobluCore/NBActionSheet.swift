// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// アクションシートの処理を行うクラス
///
///	NBActionSheet.show(self, options:[
///		NBActionSheet.Option(title: "1つめ", style: .Default),
///		NBActionSheet.Option(title: "2つめ", style: .Cancel),
///		NBActionSheet.Option(title: "3つめ", style: .Destructive),
///	]) { selectedOption in
///		print("選択されたのは \(selectedOption.title), インデックスは \(selectedOption.index)")
///	}
public class NBActionSheet {
    
    /// アクションシートのユーザ回答の選択肢
    public class Option {
        
        /// 選択肢の文言
        public var title: String
        
        /// 選択肢のスタイル
        public var style: UIAlertActionStyle
        
        /// イニシャライザ
        /// - parameter title: 選択肢の文言
        /// - parameter style: 選択肢のスタイル
        public init(title: String, style: UIAlertActionStyle) {
            self.title = title
            self.style = style
        }
        
        /// 選択肢のインデックス
        public var index: Int {
            get { return indexNumber ?? -1 }
        }
        
        private var indexNumber: Int?
    }
    
    /// アクションシートのボタン押下時のイベントハンドラ
    /// - parameter Option: 選択された回答
    public typealias DidTapHandler = ((Option)->Void)
    
    /// アクションシートを表示する
    /// - parameter controller: 表示を行うビューコントローラ
    /// - parameter message: メッセージ文言(省略可)
    /// - parameter title: タイトル文言(省略可)
    /// - parameter options: ユーザ回答の選択肢
    /// - parameter handler: アクションシートのボタン押下時のイベントハンドラ
    public class func show(controller: UIViewController, message: String? = nil, title: String? = nil, options: [Option], handler: DidTapHandler? = nil) {
        if options.isEmpty { return } // 選択肢がない時は無視
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        
        var indexNumber = 0
        for option in options {
            option.indexNumber = indexNumber++
            
            let action = NBActionSheetAction(title: option.title, style: option.style) { action in
                guard
                    let handler = handler,
                    let action  = action as? NBActionSheetAction,
                    let option   = action.option
                    else {
                        return
                }
                handler(option)
            }
            action.option = option
            alert.addAction(action)
        }
        
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    
    private class NBActionSheetAction : UIAlertAction {
        private var option: Option?
    }
}
