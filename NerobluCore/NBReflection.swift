// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK: - NBReflection -

/// クラスについての処理を行うクラス
public class NBReflection {
    
    private let target: Any?
    
    /// イニシャライザ
    /// - parameter target: 対象
    public init(_ target: Any?) {
        self.target = target
    }
    
    /// パッケージ名を含めないクラス名を返却する
    public var shortClassName: String {
        return self.className(false)
    }
    
    /// パッケージ名を含めたクラス名を返却する
    public var fullClassName: String {
        return self.className(true)
    }
    
    /// パッケージ名を返却する
    public var packageName: String? {
        let full  = self.fullClassName
        let short = self.shortClassName
        
        if full == short {
            return nil
        }
        guard let range = full.rangeOfString(".\(short)") else {
            return nil
        }
        return full.substringToIndex(range.startIndex)
    }
    
    private func className(full: Bool) -> String {
        if let target = self.target {
            if let cls = target as? AnyClass {
                return self.classNameByClass(cls, full)
            } else if let obj = target as? AnyObject {
                return self.classNameByClass(obj.dynamicType, full)
            } else {
                return self.classNameByClass(nil, full)
            }
        }
        else {
            return "nil"
        }
    }
    
    private func classNameByClass(cls: AnyClass?, _ full: Bool) -> String {
        let unknown = "unknown"
        guard let cls = cls else {
            return unknown
        }
        let fullName = NSStringFromClass(cls)
        if full { return fullName }
        
        guard let name = fullName.componentsSeparatedByString(".").last else {
            return unknown
        }
        return name
    }
}

// MARK: - NSObject拡張 -

public extension NSObject {
    
    /// パッケージ名を含めないクラス名を返却する
    public var shortClassName: String { return NBReflection(self).shortClassName }
    
    /// パッケージ名を含めたクラス名を返却する
    public var fullClassName: String { return NBReflection(self).fullClassName }
    
    /// パッケージ名を返却する
    public var packageName: String? { return NBReflection(self).packageName }
}
