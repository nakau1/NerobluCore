// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import Foundation

/// Intの拡張
public extension Int {
    
    /// 金額表示用の文字列
    ///
    ///	使用例
    ///	(12000).currency // "12,000"
    public var currency: String {
        get {
            let fmt = NSNumberFormatter()
            fmt.numberStyle       = .DecimalStyle
            fmt.groupingSeparator = ","
            fmt.groupingSize      = 3
            return fmt.stringFromNumber(self) ?? ""
        }
    }
}
