// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit


// -------------------------------------------------------------------
// 関数実装
// -------------------------------------------------------------------

/// CGRectMakeのラッパ関数
public func cr(x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGRect { return CGRectMake(x, y, w, h) }
/// サイズのみを指定したCGRect構造体を取得(originはCGPointZero)
public func cr(w: CGFloat, _ h: CGFloat) -> CGRect { return cr(0, 0, w, h) }

/// CGPointMakeのラッパ関数
public func cp(x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPointMake(x, y) }
/// CGSizeMakeのラッパ関数
public func cs(w: CGFloat, _ h: CGFloat) -> CGSize { return CGSizeMake(w, h) }

/// CGRectGetWidthのラッパ関数
public func crW(r: CGRect) -> CGFloat { return CGRectGetWidth(r) }
/// CGRectGetHeightのラッパ関数
public func crH(r: CGRect) -> CGFloat { return CGRectGetHeight(r) }
/// CGRectGetMinXのラッパ関数
public func crX(r: CGRect) -> CGFloat { return CGRectGetMinX(r) }
/// CGRectGetMinYのラッパ関数
public func crY(r: CGRect) -> CGFloat { return CGRectGetMinY(r) }

/// CGRectGetMinYのラッパ関数
public func crT(r: CGRect) -> CGFloat { return CGRectGetMinY(r) }
/// CGRectGetMinXのラッパ関数
public func crL(r: CGRect) -> CGFloat { return CGRectGetMinX(r) }
/// CGRectGetMaxXのラッパ関数
public func crR(r: CGRect) -> CGFloat { return CGRectGetMaxX(r) }
/// CGRectGetMaxXのラッパ関数
public func crB(r: CGRect) -> CGFloat { return CGRectGetMaxY(r) }

/// CGRectGetMidXのラッパ関数
public func crMX(r: CGRect) -> CGFloat { return CGRectGetMidX(r) }
/// CGRectGetMidYのラッパ関数
public func crMY(r: CGRect) -> CGFloat { return CGRectGetMidY(r) }

/// サイズのみを指定したCGRect構造体を取得(originはCGPointZero)
public func crS(s: CGSize) -> CGRect {
    return cr(0, 0, s.width, s.height);
}

/// 座標のみを指定したCGRect構造体を取得(sizeはCGSizeZero)
public func crP(p: CGPoint) -> CGRect {
    return cr(p.x, p.y, 0, 0);
}

/// CGRect構造体のセンター位置を取得
public func crC(r: CGRect) -> CGPoint {
    let x: CGFloat = crL(r) + (crW(r) / 2.0)
    let y: CGFloat = crT(r) + (crH(r) / 2.0)
    return cp(x, y);
}

/// CGPoint構造体のY座標とY座標を入れ替えた座標を取得
public func cpYX(p: CGPoint) -> CGPoint {
    return cp(p.y, p.x);
}

/// CGSize構造体の幅と高さを入れ替えたサイズを取得
public func csHW(s: CGSize) -> CGSize {
    return cs(s.height, s.width);
}
