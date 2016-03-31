// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK: - App拡張 -

public extension App {
    
    /// モデルインスタンス定義
    public class Model {
        // add use extension
    }
}

// MARK: - NBModel -

/// モデルの基底クラス
public class NBModel : NSObject {
    
    /// エラーオブジェクト
    public private(set) var error: NSError?
    
    /// エラーオブジェクトを作成する
    /// - parameter message: エラーメッセージ
    /// - parameter code: エラーコード
    /// - returns: エラーオブジェクト
    public func createError(message: String, code: Int = -1) -> NSError {
        return Error(message, code, "\( self.shortClassName )ErrorDomain")
    }
    
    /// エラーオブジェクトを自身にセットする
    /// - parameter message: エラーメッセージ
    /// - parameter code: エラーコード
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
