// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

public extension Dictionary {
    
    /// 渡された辞書を自身にマージする(自身を書き換えます)
    /// - parameter dictionary: マージする辞書
    mutating func merge(dictionary: Dictionary) {
        dictionary.forEach { self.updateValue($1, forKey: $0) }
    }
    
    /// 渡された辞書を自身にマージした新しい辞書を取得する(自身は書き換わりません)
    /// - parameter dictionary: マージする辞書
    /// - returns: 新しい辞書オブジェクト
    func mergedDirectory(dictionary: Dictionary) -> Dictionary {
        var ret = self
        dictionary.forEach { ret.updateValue($1, forKey: $0) }
        return ret
    }
}
