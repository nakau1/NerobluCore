// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// CGRectZeroの省略形
public let cr0 = CGRectZero

/// CGPointZeroの省略形
public let cp0 = CGPointZero

/// CGSizeZeroの省略形
public let cs0 = CGSizeZero

/// CGRectMakeのラッパ関数
/// - parameter x: X座標
/// - parameter y: Y座標
/// - parameter w: 幅
/// - parameter h: 高さ
/// - returns: CGRect構造体
public func cr(x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGRect { return CGRectMake(x, y, w, h) }

/// サイズのみを指定したCGRect構造体を取得(originはCGPointZero)
/// - parameter w: 幅
/// - parameter h: 高さ
/// - returns: CGRect構造体
public func cr(w: CGFloat, _ h: CGFloat) -> CGRect { return cr(0, 0, w, h) }

/// CGPointMakeのラッパ関数
/// - parameter x: X座標
/// - parameter y: Y座標
/// - returns: CGPoint構造体
public func cp(x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPointMake(x, y) }

/// CGSizeMakeのラッパ関数
/// - parameter w: 幅
/// - parameter h: 高さ
/// - returns: CGSize構造体
public func cs(w: CGFloat, _ h: CGFloat) -> CGSize { return CGSizeMake(w, h) }

/// CGRectGetWidthのラッパ関数
/// - parameter r: CGRect構造体
/// - returns: 幅
public func crW(r: CGRect) -> CGFloat { return CGRectGetWidth(r) }

/// CGRectGetHeightのラッパ関数
/// - parameter r: CGRect構造体
/// - returns: 高さ
public func crH(r: CGRect) -> CGFloat { return CGRectGetHeight(r) }

/// CGRectGetMinXのラッパ関数
/// - parameter r: CGRect構造体
/// - returns: X座標
public func crX(r: CGRect) -> CGFloat { return CGRectGetMinX(r) }

/// CGRectGetMinYのラッパ関数
/// - parameter r: CGRect構造体
/// - returns: Y座標
public func crY(r: CGRect) -> CGFloat { return CGRectGetMinY(r) }

/// CGRectGetMinYのラッパ関数
/// - parameter r: CGRect構造体
/// - returns: 上端のY座標
public func crT(r: CGRect) -> CGFloat { return CGRectGetMinY(r) }

/// CGRectGetMinXのラッパ関数
/// - parameter r: CGRect構造体
/// - returns: 左端のX座標
public func crL(r: CGRect) -> CGFloat { return CGRectGetMinX(r) }

/// CGRectGetMaxXのラッパ関数
/// - parameter r: CGRect構造体
/// - returns: 右端のX座標
public func crR(r: CGRect) -> CGFloat { return CGRectGetMaxX(r) }

/// CGRectGetMaxXのラッパ関数
/// - parameter r: CGRect構造体
/// - returns: 下端のY座標
public func crB(r: CGRect) -> CGFloat { return CGRectGetMaxY(r) }

/// CGRectGetMidXのラッパ関数
/// - parameter r: CGRect構造体
/// - returns: 水平方向の中央X座標
public func crMX(r: CGRect) -> CGFloat { return CGRectGetMidX(r) }

/// CGRectGetMidYのラッパ関数
/// - parameter r: CGRect構造体
/// - returns: 垂直方向の中央Y座標
public func crMY(r: CGRect) -> CGFloat { return CGRectGetMidY(r) }

/// CGRectZeroを取得する
/// - returns: CGRect構造体
public func crZ() -> CGRect { return CGRectZero }

/// CGPointZeroを取得する
/// - returns: CGPoint構造体
public func cpZ() -> CGPoint { return CGPointZero }

/// CGSizeZeroを取得する
/// - returns: CGSize構造体
public func csZ() -> CGSize { return CGSizeZero }

/// サイズのみを指定したCGRect構造体を取得(originはCGPointZero)
/// - parameter s: CGSize構造体
/// - returns: CGRect構造体
public func crS(s: CGSize) -> CGRect {
    return cr(0, 0, s.width, s.height);
}

/// 座標のみを指定したCGRect構造体を取得(sizeはCGSizeZero)
/// - parameter p: CGPoint構造体
/// - returns: CGRect構造体
public func crP(p: CGPoint) -> CGRect {
    return cr(p.x, p.y, 0, 0);
}

/// CGRect構造体のセンター位置を取得
/// - parameter r: CGRect構造体
/// - returns: CGPoint構造体
public func crC(r: CGRect) -> CGPoint {
    let x: CGFloat = crL(r) + (crW(r) / 2.0)
    let y: CGFloat = crT(r) + (crH(r) / 2.0)
    return cp(x, y);
}

/// CGPoint構造体のY座標とY座標を入れ替えた座標を取得
/// - parameter p: CGPoint構造体
/// - returns: CGPoint構造体
public func cpYX(p: CGPoint) -> CGPoint {
    return cp(p.y, p.x);
}

/// CGSize構造体の幅と高さを入れ替えたサイズを取得
/// - parameter s: CGSize構造体
/// - returns: CGSize構造体
public func csHW(s: CGSize) -> CGSize {
    return cs(s.height, s.width);
}
