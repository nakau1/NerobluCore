// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// モデルの基底クラス
public class NBModel : NSObject {
    
    /// エラーオブジェクト
    private(set) var error: NSError?
    
    /// エラーオブジェクトを作成する
    /// - parameter message: エラーメッセージ
    /// - parameter code: エラーコード
    /// - returns: エラーオブジェクト
    public func createError(message: String, code: Int = -1) -> NSError {
        let domain = "\( NBReflection(self).fullClassName )ErrorDomain"
        return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    /// エラーオブジェクトを自身にセットする
    /// - parameter message: エラーメッセージ
    /// - parameter code: エラーコード
    /// - returns: エラーオブジェクト
    public func raiseError(message: String, code: Int = -1) {
        self.raiseError(self.createError(message, code: code))
    }
    
    /// エラーオブジェクトを自身にセットする
    /// - parameter error: エラーエラーオブジェクト
    /// - returns: エラーオブジェクト
    public func raiseError(error: NSError) {
        self.error = error
    }
    
    /// 今現在セットされているエラーオブジェクトを破棄する
    public func resetError() {
        self.error = nil
    }
}
