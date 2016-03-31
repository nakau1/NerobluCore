// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// エラーオブジェクトを簡易的に作成する
/// - parameter message: エラーメッセージ
/// - parameter code: エラーコード
/// - parameter domain: エラードメイン
/// - returns: エラーオブジェクト
public func Error(message: String, _ code: Int = -1, _ domain: String = "") -> NSError {
    return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
}

// MARK: - NSError拡張 -
extension NSError {
    
    /// エラーメッセージ
    public var message: String {
        guard let ret = self.userInfo[NSLocalizedDescriptionKey] as? String else {
            return ""
        }
        return ret
    }
}
