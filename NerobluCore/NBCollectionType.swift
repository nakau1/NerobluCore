// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK: - Array拡張 -

extension Array {
    
    /// 最初の要素のインデックス
    ///
    /// indices.firstのラッピング
    public var firstIndex: Int? {
        return self.indices.first
    }
    
    /// 最後の要素のインデックス
    ///
    /// indices.lastのラッピング
    public var lastIndex: Int? {
        return self.indices.last
    }
    
    /// 配列内からランダムに要素を取り出す
    ///
    /// 要素が空の場合はnilを返す
    public var random: Element? {
        guard let min = self.firstIndex, let max = self.lastIndex else { return nil }
        let r = Int.random(min: min, max: max)
        return self[r]
    }
}