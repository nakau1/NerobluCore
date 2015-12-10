// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// ビューコントローラの基底クラス
public class NBViewController : UIViewController {
    
    /// 外部コンポーネント(ライブラリ内)
    internal var externalComponents = [String : AnyObject?]()
}

// MARK: - Dismiss Simply -
public extension UIViewController {
    
    /// 自身がモーダルで表示されている場合にシンプルに閉じる
    /// 
    /// このメソッドはdismissViewControllerAnimated(_:)のラッピングです
    public func dismissSimply() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 自身のナビゲーションバーの左側に自身のモーダル表示を閉じるボタンを設置する
    ///
    /// より複雑な仕様を実装する場合は、各自実装すること
    public func setDismissSimplyButtonToLeftNavigationItem() {
        let bbi = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: Selector("dismissSimply"))
        self.navigationItem.leftBarButtonItem = bbi
    }
}
