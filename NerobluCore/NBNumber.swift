// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK: - Intの拡張 -
public extension Int {
    
    /// 指定した範囲の中から乱数を取得する
    ///
    /// 最小値は0を下回ってはいけません。また、最小値は最大値を上回ってはいけません
    /// - parameter min: 最小値
    /// - parameter max: 最大値
    /// - returns: 乱数
    public static func random(min min: Int, max: Int) -> Int {
        let minn = min < 0 ? 0 : min
        let maxn = max + 1
        let x = UInt32(maxn < minn ? 0 : maxn - minn)
        let r = Int(arc4random_uniform(x))
        return minn + r
    }
    
    /// 金額表示用の文字列
    ///
    ///	使用例
    ///	(12000).currency // "12,000"
    public var currency: String {
        let fmt = NSNumberFormatter()
        fmt.numberStyle       = .DecimalStyle
        fmt.groupingSeparator = ","
        fmt.groupingSize      = 3
        return fmt.stringFromNumber(self) ?? ""
    }
    
    /// CGFloatにキャストした値
    public var f: CGFloat { return CGFloat(self) }
    
    /// 文字列にキャストした値
    public var string: String { return "\(self)" }
}

// MARK: - Floatの拡張 -
public extension Float {
    
    /// CGFloatにキャストした値
    public var f: CGFloat { return CGFloat(self) }
    
    /// 文字列にキャストした値
    public var string: String { return "\(self)" }
}

// MARK: - Doubleの拡張 -
public extension Double {
    
    /// CGFloatにキャストした値
    public var f: CGFloat { return CGFloat(self) }
    
    /// 文字列にキャストした値
    public var string: String { return "\(self)" }
}

// MARK: - CGFloat拡張 -
public extension CGFloat {
    
    /// Intにキャストした値
    public var int: Int { return Int(self) }
    
    /// Floatにキャストした値
    public var float: Float { return Float(self) }
    
    /// Doubleにキャストした値
    public var double: Double { return Double(self) }
    
    /// 文字列にキャストした値
    public var string: String { return "\(self)" }
}

