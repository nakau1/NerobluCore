// =============================================================================
// PHOTTY
// Copyright (C) 2015 NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// NSLayoutConstraintに関するUIView拡張
public extension UIView {
    
    /// すべての制約を削除する
    public func removeAllConstraints() {
        self.removeConstraints(self.constraints)
    }
    
    // MARK: - 縦横サイズ
    
    /// 指定したサイズを制約として追加する
    /// - parameter size: サイズ
    /// - returns: 追加されたConstraint(制約)オブジェクトの配列
    public func addConstraintsSize(size: CGSize) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            self.constraintEqually(.Width,  constant: size.width),
            self.constraintEqually(.Height, constant: size.height),
        ]
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(constraints)
        return constraints
    }
    
    /// 指定した横幅を制約として追加する
    /// - parameter width: 横幅
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintWidth(width: CGFloat) -> NSLayoutConstraint? {
        let constraint = self.constraintEqually(.Width, constant: width)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(constraint)
        return constraint
    }
    
    /// 指定した縦幅を制約として追加する
    /// - parameter height: 縦幅
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintHeight(height: CGFloat) -> NSLayoutConstraint? {
        let constraint = self.constraintEqually(.Height, constant: height)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(constraint)
        return constraint
    }
    
    /// 自身に設定されているサイズを制約として追加する
    /// - returns: 追加されたConstraint(制約)オブジェクトの配列
    public func addConstraintsSelfSize() -> [NSLayoutConstraint] {
        return self.addConstraintsSize(self.bounds.size)
    }
    
    /// 自身に設定されている横幅を制約として追加する
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintSelfWidth() -> NSLayoutConstraint? {
        return self.addConstraintWidth(self.bounds.size.width)
    }
    
    /// 自身に設定されている縦幅を制約として追加する
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintSelfHeight() -> NSLayoutConstraint? {
        return self.addConstraintHeight(self.bounds.size.height)
    }
    
    // MARK: - サイズ揃え
    
    /// 指定したビューと自身との幅を揃える制約を追加する
    /// - parameter items: 自身と幅を揃えるビュー(またはオブジェクト)の配列
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクトの配列
    public func addConstraintEqualWidths(items: [AnyObject], toItem: AnyObject? = nil) -> [NSLayoutConstraint] {
        return self.addConstraintsEqualDimension(.Width, items: items, toItem: toItem)
    }
    
    /// 指定したビューと自身との高さを揃える制約を追加する
    /// - parameter items: 自身と高さを揃えるビュー(またはオブジェクト)の配列
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクトの配列
    public func addConstraintEqualHeights(items: [AnyObject], toItem: AnyObject? = nil) -> [NSLayoutConstraint] {
        return self.addConstraintsEqualDimension(.Height, items: items, toItem: toItem)
    }
    
    // MARK: - 比率サイズ
    
    /// 横幅を対象のビュー(親ビュー)との比率で設定した制約を追加する
    /// - parameter multiplier: 比率(0.5を与えると半分の幅になる)
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクトの配列
    public func addConstraintMultiplierWidth(multiplier: CGFloat, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintWithTargetItem(.Width, multiplier: multiplier, toItem: toItem)
    }
    
    /// 高さを対象のビュー(親ビュー)との比率で設定した制約を追加する
    /// - parameter multiplier: 比率(0.5を与えると半分の高さになる)
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクトの配列
    public func addConstraintMultiplierHeight(multiplier: CGFloat, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintWithTargetItem(.Height, multiplier: multiplier, toItem: toItem)
    }
    
    // MARK: - 隣接
    
    /// 指定したビューの上に位置する制約を追加する
    /// - parameter item: 指定のビューまたはオブジェクト
    /// - parameter space: 余白スペース(省略時は密接)
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintToAboveOf(item: AnyObject, space: CGFloat = 0, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintToNeighborhoodOf(item, space: space, selfAttribute: .Bottom, targetAttribute: .Top, toItem: toItem)
    }
    
    /// 指定したビューの下に位置する制約を追加する
    /// - parameter item: 指定のビューまたはオブジェクト
    /// - parameter space: 余白スペース(省略時は密接)
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintToBelowOf(item: AnyObject, space: CGFloat = 0, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintToNeighborhoodOf(item, space: -space, selfAttribute: .Top, targetAttribute: .Bottom, toItem: toItem)
    }
    
    /// 指定したビューの左に位置する制約を追加する
    /// - parameter item: 指定のビューまたはオブジェクト
    /// - parameter space: 余白スペース(省略時は密接)
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintToLeadOf(item: AnyObject, space: CGFloat = 0, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintToNeighborhoodOf(item, space: space, selfAttribute: .Trailing, targetAttribute: .Leading, toItem: toItem)
    }
    
    /// 指定したビューの右に位置する制約を追加する
    /// - parameter item: 指定のビューまたはオブジェクト
    /// - parameter space: 余白スペース(省略時は密接)
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintToTrailOf(item: AnyObject, space: CGFloat = 0, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintToNeighborhoodOf(item, space: -space, selfAttribute: .Leading, targetAttribute: .Trailing, toItem: toItem)
    }
    
    // MARK: - 隣接(エイリアス)
    
    /// 指定したビューの上に位置する制約を追加する
    /// - parameter item: 指定のビューまたはオブジェクト
    /// - parameter space: 余白スペース(省略時は密接)
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintToTopOf(item: AnyObject, space: CGFloat = 0, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintToAboveOf(item, space: space, toItem: toItem)
    }
    
    /// 指定したビューの下に位置する制約を追加する
    /// - parameter item: 指定のビューまたはオブジェクト
    /// - parameter space: 余白スペース(省略時は密接)
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintToBottomOf(item: AnyObject, space: CGFloat = 0, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintToBelowOf(item, space: space, toItem: toItem)
    }
    
    /// 指定したビューの左に位置する制約を追加する
    /// - parameter item: 指定のビューまたはオブジェクト
    /// - parameter space: 余白スペース(省略時は密接)
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintToLeftOf(item: AnyObject, space: CGFloat = 0, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintToLeadOf(item, space: space, toItem: toItem)
    }
    
    /// 指定したビューの右に位置する制約を追加する
    /// - parameter item: 指定のビューまたはオブジェクト
    /// - parameter space: 余白スペース(省略時は密接)
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintToRightOf(item: AnyObject, space: CGFloat = 0, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintToTrailOf(item, space: space, toItem: toItem)
    }
    
    /// 指定したビューの左に位置する制約を追加する
    /// - parameter item: 指定のビューまたはオブジェクト
    /// - parameter space: 余白スペース(省略時は密接)
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintToStartOf(item: AnyObject, space: CGFloat = 0, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintToLeadOf(item, space: space, toItem: toItem)
    }
    
    /// 指定したビューの右に位置する制約を追加する
    /// - parameter item: 指定のビューまたはオブジェクト
    /// - parameter space: 余白スペース(省略時は密接)
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintToEndOf(item: AnyObject, space: CGFloat = 0, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintToTrailOf(item, space: space, toItem: toItem)
    }
    
    // MARK: - スペース
    
    /// Topスペースの制約を追加する
    /// - parameter space: スペースの幅
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintTopSpace(space: CGFloat = 0, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintWithTargetItem(.Top, constant: space, toItem: toItem)
    }
    
    /// Leftスペースの制約を追加する
    /// - parameter space: スペースの幅
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintLeftSpace(space: CGFloat = 0, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintWithTargetItem(.Left, constant: space, toItem: toItem)
    }
    
    /// Bottomスペースの制約を追加する
    /// - parameter space: スペースの幅
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintBottomSpace(space: CGFloat = 0, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintWithTargetItem(.Bottom, constant: -space, toItem: toItem)
    }
    
    /// Rightスペースの制約を追加する
    /// - parameter space: スペースの幅
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintRightSpace(space: CGFloat = 0, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintWithTargetItem(.Right, constant: -space, toItem: toItem)
    }
    
    
    /// 指定した値をTopスペースの制約として追加する
    /// - parameter space: スペースの幅
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintsSpaces(top top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil, toItem: AnyObject? = nil) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        guard let targetToItem = self.targetToItem(toItem) else {
            return constraints
        }
        
        if let v = top {
            let constraint = self.addConstraintWithTargetItem(.Top, constant: v, toItem: targetToItem)!
            constraints.append(constraint)
        }
        if let v = left {
            let constraint = self.addConstraintWithTargetItem(.Left, constant: v, toItem: targetToItem)!
            constraints.append(constraint)
        }
        if let v = bottom {
            let constraint = self.addConstraintWithTargetItem(.Bottom, constant: -v, toItem: targetToItem)!
            constraints.append(constraint)
        }
        if let v = right {
            let constraint = self.addConstraintWithTargetItem(.Right, constant: -v, toItem: targetToItem)!
            constraints.append(constraint)
        }
        
        return constraints
    }
    
    /// ビューのすべての辺に接着する(あるいはマージンが加えられた)制約を追加する(UIEdgeInsetsによる設定)
    ///
    /// UIView#addConstraintsAllSpacesWithMargin()と比べ、
    /// UIEdgeInsetsを使用して4辺のマージン値を詳細に設定できます
    ///
    /// - parameter inset: マージン値のインセット
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    public func addConstraintsAllSpacesWithEdgeInsets(inset: UIEdgeInsets, toItem: AnyObject? = nil) -> [NSLayoutConstraint] {
        return self.addConstraintsSpaces(
            top:    inset.top,
            left:   inset.left,
            bottom: inset.bottom,
            right:  inset.right,
            toItem: toItem
        )
    }
    
    /// ビューのすべての辺に接着する(あるいはマージンが加えられた)制約を追加する
    /// - parameter margin: マージン値(省略時はマージンなし)
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    public func addConstraintsAllSpacesWithMargin(margin:CGFloat = 0, toItem: AnyObject? = nil) -> [NSLayoutConstraint] {
        return self.addConstraintsAllSpacesWithEdgeInsets(UIEdgeInsetsMake(margin, margin, margin, margin), toItem: toItem)
    }
    
    // MARK: - 端揃え
    
    /// 指定したビューと上辺位置を揃える制約を追加する
    /// - parameter items: 指定のビューまたはオブジェクトの配列
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクトの配列
    public func addConstraintsAlignTopEdge(items: [AnyObject], toItem: AnyObject? = nil) -> [NSLayoutConstraint] {
        return self.addConstraintsEqualDimension(.Top, items: items, toItem: toItem)
    }
    
    /// 指定したビューと先頭位置を揃える制約を追加する
    /// - parameter items: 指定のビューまたはオブジェクトの配列
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクトの配列
    public func addConstraintsAlignLeadingEdge(items: [AnyObject], toItem: AnyObject? = nil) -> [NSLayoutConstraint] {
        return self.addConstraintsEqualDimension(.Leading, items: items, toItem: toItem)
    }
    
    /// 指定したビューと下辺位置を揃える制約を追加する
    /// - parameter items: 指定のビューまたはオブジェクトの配列
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクトの配列
    public func addConstraintsAlignBottomEdge(items: [AnyObject], toItem: AnyObject? = nil) -> [NSLayoutConstraint] {
        return self.addConstraintsEqualDimension(.Bottom, items: items, toItem: toItem)
    }
    
    /// 指定したビューと末端位置を揃える制約を追加する
    /// - parameter items: 指定のビューまたはオブジェクトの配列
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクトの配列
    public func addConstraintsAlignTrailingEdge(items: [AnyObject], toItem: AnyObject? = nil) -> [NSLayoutConstraint] {
        return self.addConstraintsEqualDimension(.Trailing, items: items, toItem: toItem)
    }
    
    /// 指定したビューと先頭、末端位置を揃える制約を追加する
    /// - parameter items: 指定のビューまたはオブジェクトの配列
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクトの配列
    public func addConstraintsAlignWidthSideEdge(items: [AnyObject], toItem: AnyObject? = nil) -> [NSLayoutConstraint] {
        var ret = [NSLayoutConstraint]()
        ret.appendContentsOf(self.addConstraintsAlignLeadingEdge (items, toItem: toItem))
        ret.appendContentsOf(self.addConstraintsAlignTrailingEdge(items, toItem: toItem))
        return ret
    }
    
    /// 指定したビューと上辺、下辺位置を揃える制約を追加する
    /// - parameter items: 指定のビューまたはオブジェクトの配列
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクトの配列
    public func addConstraintsAlignHeightSideEdge(items: [AnyObject], toItem: AnyObject? = nil) -> [NSLayoutConstraint] {
        var ret = [NSLayoutConstraint]()
        ret.appendContentsOf(self.addConstraintsAlignTopEdge   (items, toItem: toItem))
        ret.appendContentsOf(self.addConstraintsAlignBottomEdge(items, toItem: toItem))
        return ret
    }
    
    // MARK: - センタリング
    
    /// 全方向の中央位置制約を追加する
    /// - parameter offset: オフセット位置
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintsCenter(offset: CGFloat = 0, toItem: AnyObject? = nil) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        if let constraint = self.addConstraintVerticalCenter(offset, toItem: toItem) {
            constraints.append(constraint)
        }
        if let constraint = self.addConstraintHorizontalCenter(offset, toItem: toItem) {
            constraints.append(constraint)
        }
        return constraints
    }
    
    /// 垂直方向の中央位置制約を追加する
    /// - parameter offset: オフセット位置
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintVerticalCenter(offset: CGFloat = 0, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintWithTargetItem(.CenterY, constant: offset, toItem: toItem)
    }
    
    /// 水平方向の中央位置制約を追加する
    /// - parameter offset: オフセット位置
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintHorizontalCenter(offset: CGFloat = 0, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        return self.addConstraintWithTargetItem(.CenterX, constant: offset, toItem: toItem)
    }
    
    // MARK: - アスペクト比率
    
    /// アスペクト比率を保つための制約を追加する
    /// - parameter width: 横幅または比率値
    /// - parameter height: 高さまたは比率値
    /// - returns: 追加されたConstraint(制約)オブジェクト
    public func addConstraintAspectRatio(width width: CGFloat? = nil, height: CGFloat? = nil) -> NSLayoutConstraint? {
        var w:CGFloat = 0, h:CGFloat = 0
        if let argW = width  { w = argW } else { w = self.bounds.size.width  }
        if let argH = height { h = argH } else { h = self.bounds.size.height }
        
        if h == 0 { return nil } // avoid zero divide crash
        
        let constraint = NSLayoutConstraint(
            item:       self,
            attribute:  .Width,
            relatedBy:  .Equal,
            toItem:     self,
            attribute:  .Height,
            multiplier: w / h,
            constant:   0.0
        )
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(constraint)
        return constraint
    }
    
    // MARK: - 汎用プライベートメソッド
    
    /// 対象のビューに指定した値と属性の制約を追加する
    /// - parameter attribute: レイアウト属性
    /// - parameter constant: 定数値
    /// - parameter multiplier: 乗算値
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    private func addConstraintWithTargetItem(attribute: NSLayoutAttribute, constant: CGFloat? = nil, multiplier: CGFloat? = nil, toItem: AnyObject?) -> NSLayoutConstraint? {
        guard let targetToItem = self.targetToItem(toItem) else {
            return nil
        }
        let constraint = self.constraintEqually(attribute, constant: constant, multiplier: multiplier, toItem: targetToItem)
        self.translatesAutoresizingMaskIntoConstraints = false
        targetToItem.addConstraint(constraint)
        return constraint
    }
    
    /// 複数のビューに自身と同じサイズ(または端揃え)に関する制約を追加する
    /// - parameter attribute: レイアウト属性
    /// - parameter items: 制約を追加するビューまたはオブジェクトの配列
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクトの配列
    private func addConstraintsEqualDimension(attribute: NSLayoutAttribute, items: [AnyObject], toItem: AnyObject?) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        guard let targetToItem = self.targetToItem(toItem) else {
            return constraints
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        for item in items {
            guard let view = item as? UIView else { continue }
            let constraint = view.constraintEqually(attribute, constant: 0, toItem: self)
            targetToItem.addConstraint(constraint)
            constraints.append(constraint)
        }
        
        return constraints
    }
    
    /// 指定したビューに隣接する制約を追加する
    /// - parameter target: 隣接したい対象のビューまたはオブジェクト
    /// - parameter space: 余白スペース
    /// - parameter selfAttribute: 自身にかかるレイアウト属性
    /// - parameter targetAttribute: 対象のビューにかかるレイアウト属性
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト(省略時は自身の親ビューを対象にする)
    /// - returns: 追加されたConstraint(制約)オブジェクト
    private func addConstraintToNeighborhoodOf(target: AnyObject, space: CGFloat, selfAttribute: NSLayoutAttribute, targetAttribute: NSLayoutAttribute, toItem: AnyObject? = nil) -> NSLayoutConstraint? {
        guard let targetToItem = self.targetToItem(toItem) else {
            return nil
        }
        let constraint = NSLayoutConstraint(
            item:       target,
            attribute:  targetAttribute,
            relatedBy:  .Equal,
            toItem:     self,
            attribute:  selfAttribute,
            multiplier: 1.0,
            constant:   space
        )
        
        self.translatesAutoresizingMaskIntoConstraints = false
        targetToItem.addConstraint(constraint)
        return constraint
    }
    
    /// 各メソッドの引数共通の制約の対象ビュー取得
    /// - parameter toItem: 制約の対象ビューまたはオブジェクト
    /// - returns: 制約の対象ビューまたはオブジェクト(引数がnilの時は自身の親ビューを返す。親ビューもnilの場合はnilを返す)
    private func targetToItem(toItem: AnyObject?) -> AnyObject? {
        var ret: AnyObject? = nil
        if let v = toItem {
            ret = v
        } else if let v = self.superview {
            ret = v
        }
        return ret
    }
    
    /// 新しいConstraint(制約)オブジェクトを作成する(関係性はEqual固定)
    /// - parameter attribute: レイアウト属性
    /// - parameter constant: 定数値(省略時は0.0)
    /// - parameter multiplier: 乗算値(省略時は1.0)
    /// - parameter toItem: 制約の対象ビュー
    /// - returns: 新しいConstraint(制約)オブジェクト
    private func constraintEqually(attribute: NSLayoutAttribute, constant: CGFloat? = nil, multiplier: CGFloat? = nil, toItem: AnyObject? = nil) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item:       self,
            attribute:  attribute,
            relatedBy:  .Equal,
            toItem:     toItem,
            attribute:  attribute,
            multiplier: multiplier ?? 1.0,
            constant:   constant ?? 0.0
        )
    }
}
