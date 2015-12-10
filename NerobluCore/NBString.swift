// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

public extension String {
    
    /// 自身をローカライズのキーとしてローカライズされた文字列を取得する
    ///
    ///     "Hoge".localize() // ローカライズ設定があれば、例えば "ほげ" と返す
    /// - parameter comment: コメント
    /// - returns: ローカライズされた文字列
    public func localize(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
