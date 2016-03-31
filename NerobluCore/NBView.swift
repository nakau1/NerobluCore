// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK: - UIView拡張 -
public extension UIView {
    
    /// XIBからビューインスタンスを生成する
    ///
    /// 引数を省略した場合は、呼び出したクラス名からXIBファイル名を判定します
    ///
    ///     if let customView = CustmoView.loadFromNib() as? CustomView {
    ///         self.view.addSubview(customView)
    ///     }
    ///
    /// - parameter nibName: XIBファイル名
    /// - parameter bundle: バンドル
    /// - returns: 新しいビュー
    public class func loadFromNib(nibName: String? = nil, bundle: NSBundle? = nil) -> UIView? {
        var name = ""
        if let nibName = nibName {
            name = nibName
        } else {
            name = NBReflection(self).shortClassName
        }
        
        let nib = UINib(nibName: name, bundle: bundle)
        return nib.instantiateWithOwner(nil, options: nil).first as? UIView
    }
    
    /// 最上部のビューを返却する(自身が最上部ならば自身を返す)
    public var rootView : UIView {
        if let superview = self.superview {
            return superview.rootView
        }
        return self
    }
	
	/// 親ビュー(nilを渡すと親ビューから削除される)
	public var parent: UIView? {
		get {
			return self.superview
		}
		set(v) {
			if let view = v {
				view.addSubview(self)
			} else {
				self.removeFromSuperview()
			}
		}
	}
	
	/// すべてのサブビューを自身から削除する
	public func removeAllSubviews() {
		self.subviews.forEach { $0.removeFromSuperview() }
	}
    
    /// ビューのX座標
    public var x: CGFloat {
        get    { return CGRectGetMinX(self.frame) }
        set(v) { self.frame.origin.x = v }
    }
    
    /// ビューのY座標
    public var y: CGFloat {
        get    { return CGRectGetMinY(self.frame) }
        set(v) { self.frame.origin.y = v }
    }
    
    /// ビューの幅
    public var width: CGFloat {
        get    { return CGRectGetWidth(self.frame) }
        set(v) { self.frame.size.width = v }
    }
    
    /// ビューの高さ
    public var height: CGFloat {
        get    { return CGRectGetHeight(self.frame) }
        set(v) { self.frame.size.height = v }
    }
}
