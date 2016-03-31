// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK: - NBViewController -

/// ビューコントローラの基底クラス
public class NBViewController : UIViewController {
    
    /// 外部コンポーネント(ライブラリ内)
    internal var externalComponents = [String : AnyObject?]()
}

// MARK: - UIViewController拡張 -

public extension UIViewController {
    
    /// 指定したビューコントローラをモーダル表示する
    public func present(vc: UIViewController) {
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    /// 自身のモーダル表示を閉じる
    public func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 指定したビューコントローラをナビゲーションにプッシュする
    public func push(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// ナビゲーションからポップする
    public func pop() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /// 自身のナビゲーションバーの左側に自身のモーダル表示を閉じるボタンを設置する
    ///
    /// より複雑な仕様を実装する場合は、各自実装すること
    public func setDismissButtonToLeftNavigationItem() {
        let bbi = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: Selector("dismiss"))
        self.navigationItem.leftBarButtonItem = bbi
    }
    
    /// 現在最も上層にいる(表示中の)ビューコントローラ
    public static var topViewController: UIViewController? {
        var vc: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController
        while vc?.presentedViewController != nil {
            vc = vc!.presentedViewController!
        }
        while vc as? UINavigationController != nil {
            let nvc = vc as! UINavigationController
            vc = nvc.topViewController
        }
        while vc as? UITabBarController != nil {
            let tvc = vc as! UITabBarController
            vc = tvc.selectedViewController
        }
        return vc
    }
}

