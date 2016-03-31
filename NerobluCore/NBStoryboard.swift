// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK - App拡張 -
public extension App {
    
    /// ストーリーボード
    public class Storyboard {
        
        private var name: String
        private var bundle: NSBundle?
        
        /// イニシャライザ
        /// - parameter name: ストリーボード名
        /// - parameter bundle: バンドル
        public init(_ name: String, bundle: NSBundle? = nil) {
            self.name   = name
            self.bundle = bundle
        }
        
        /// ストーリーボードオブジェクトを取得する
        /// - returns: UIStoryboardオブジェクト
        public func get() -> UIStoryboard {
            return UIStoryboard(name: self.name, bundle: self.bundle)
        }
        
        /// ストーリーボードのルート(イニシャル)ビューコントローラ
        /// 
        /// 存在しない場合はfatalエラーになる
        public var rootViewController: UIViewController {
            guard let vc = self.get().instantiateInitialViewController() else {
                fatalError("not found root(initial) view controller in storyboard of '\(self.name)'")
            }
            return vc
        }
        
        /// ストーリーボードからビューコントローラを取得する
        ///
        /// 存在しない場合はfatalエラーになる
        /// - parameter type: 返却されるビューコントローラの型
        /// - parameter identifier: ストーリーボード上のID
        /// - returns: ビューコントローラ
        public func viewController<T: UIViewController>(type: T.Type, identifier: String) -> T {
            guard let vc = self.get().instantiateViewControllerWithIdentifier(identifier) as? T else {
                fatalError("not found view controller has identifier of '\(identifier)' in storyboard of '\(self.name)'")
            }
            return vc
        }
    }
}
