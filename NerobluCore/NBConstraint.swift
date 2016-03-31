// =============================================================================
// PHOTTY
// Copyright (C) 2015 NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK: - UIView拡張 -
public extension UIView {
    
    /// すべての制約を削除する
    public func removeAllConstraints() {
        self.removeConstraints(self.constraints)
    }
    
    /// 制約を設定するための準備を行う
    public func prepareConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - UIView拡張 -
public extension UIView {
    
    /// ビューのすべての辺に接着する(あるいはマージンが加えられた)制約を取得する
    /// - parameter margin: マージン値(省略時はマージンなし)
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 制約オブジェクトの配列
    public func constraintsAllSpaces(margin:CGFloat = 0, toItem: AnyObject? = nil) -> [NSLayoutConstraint] {
        let inset = UIEdgeInsetsMake(margin, margin, margin, margin)
        return self.constraintsAllSpaces(inset: inset, toItem: toItem)
    }
    
    /// ビューのすべての辺に接着する(あるいはマージンが加えられた)制約を取得する(UIEdgeInsetsによる指定)
    /// - parameter inset: マージン値のインセット
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 制約オブジェクトの配列
    public func constraintsAllSpaces(inset inset: UIEdgeInsets, toItem: AnyObject? = nil) -> [NSLayoutConstraint] {
        return self.constraintsSpaces(top: inset.top, left: inset.left, bottom: inset.bottom, right: inset.right, toItem: toItem)
    }
    
    /// ビューの指定した辺に接着する(あるいはマージンが加えられた)制約を取得する
    /// - parameter top: 上端のマージン値(省略時は戻り値に含まれない)
    /// - parameter left: 左端のマージン値(省略時は戻り値に含まれない)
    /// - parameter bottom: 下端のマージン値(省略時は戻り値に含まれない)
    /// - parameter right: 右端のマージン値(省略時は戻り値に含まれない)
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 制約オブジェクトの配列
    public func constraintsSpaces(top top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil, toItem: AnyObject? = nil) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        let to: AnyObject? = toItem ?? self.parent
        
        if let v = top {
            constraints.append(Constraint(self, .Top, to: to, .Top, v))
        }
        if let v = left {
            constraints.append(Constraint(self, .Leading, to: to, .Leading, v))
        }
        if let v = bottom {
            constraints.append(Constraint(self, .Bottom, to: to, .Bottom, -v))
        }
        if let v = right {
            constraints.append(Constraint(self, .Trailing, to: to, .Trailing, -v))
        }
        
        return constraints
    }
}

// MARK: - Functions -

/// 制約(NSLayoutConstraint)を生成する
/// - parameter item: 制約を追加するオブジェクト
/// - parameter attr: 制約を追加するオブジェクトに与える属性
/// - parameter to: 制約の相手
/// - parameter attrTo: 制約相手に使用する属性
/// - parameter constant: 定数値
/// - parameter multiplier: 乗数値
/// - parameter relate: 計算式の関係性
/// - parameter priority: 制約の優先度
/// - returns: 制約(NSLayoutConstraint)オブジェクト
public func Constraint(item: AnyObject, _ attr: NSLayoutAttribute, to: AnyObject?, _ attrTo: NSLayoutAttribute, _ constant: CGFloat, multiplier: CGFloat = 1.0, relate: NSLayoutRelation = .Equal, priority: UILayoutPriority = UILayoutPriorityRequired) -> NSLayoutConstraint {
    let ret = NSLayoutConstraint(
        item:       item,
        attribute:  attr,
        relatedBy:  relate,
        toItem:     to,
        attribute:  attrTo,
        multiplier: multiplier,
        constant:   constant
    )
    ret.priority = priority
    return ret
}
