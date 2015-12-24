// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

public extension String {
    
    /// 文字列長
    ///
    ///     "⏩".length // 1
    ///     "😻".length // 1
    ///     "123".length // 3
    ///     "ABC".length // 3
    ///     "あいう".length // 3
    public var length: Int {
        return self.characters.count
    }
    
    /// 自身をローカライズのキーとしてローカライズされた文字列を取得する
    ///
    ///     "Hoge".localize() // ローカライズ設定があれば、例えば "ほげ" と返す
    /// - parameter comment: コメント
    /// - returns: ローカライズされた文字列
    public func localize(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    /// 自身をフォーマットとしてフォーマット化された文字列を取得する
    ///
    ///     "Hello %@".format("World") // "Hello World"
    /// - parameter args: 引数
    /// - returns: フォーマット化された文字列
    public func format(args: CVarArgType...) -> String {
        let s = NSString(format: self, arguments: getVaList(args))
        return s as String
    }
    
    /// 文字列置換を行う
    ///
    ///     "Hello".replace("e", "o") // "Hollo"
    /// - parameter search: 検索する文字
    /// - parameter replacement: 置換する文字
    /// - returns: 置換された文字列
    public func replace(search: String, _ replacement: String) -> String {
        return self.stringByReplacingOccurrencesOfString(search, withString: replacement, options: NSStringCompareOptions(), range: nil)
    }
    
    /// 文字列分割を行う
    ///
    ///     "file/path/to/".split("/") // ["file", "path", "to"]
    /// - parameter separator: 分割に使用するセパレータ文字
    /// - parameter allowEmpty: 空文字を許可するかどうか。falseにすると分割された結果が空文字だった場合は配列に入りません
    /// - returns: 分割された結果の文字列配列
    public func split(separator: String, allowEmpty: Bool = true) -> [String] {
        let ret = self.componentsSeparatedByString(separator)
        if allowEmpty {
            return ret
        }
        return ret.filter { !$0.isEmpty }
    }
    
    /// 文字列のトリムを行う
    ///
    ///     " hello world  ".trim() // "hello world"
    ///     // 以下のようにすると改行コードもトリムできる
    ///     "hello world\n".trim(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    ///
    /// - parameter characterSet: トリムに使用するキャラクタセット(省略すると半角スペースのみがトリム対象となる)
    /// - returns: トリムされた文字列
    public func trim(characterSet: NSCharacterSet = NSCharacterSet.whitespaceCharacterSet()) -> String {
        return self.stringByTrimmingCharactersInSet(characterSet)
    }
    
    /// 文字列の部分取得を行う
    ///
    ///     "hello".substringWithRange(1, end: 3) // "el"
    /// - parameter start: 開始インデックス
    /// - parameter end: 終了インデックス
    /// - returns: 部分取得された文字列
    public func substringWithRange(start: Int, end: Int) -> String {
        if (start < 0 || start > self.characters.count) {
            return ""
        }
        else if end < 0 || end > self.characters.count {
            return ""
        }
        let range = Range(start: self.startIndex.advancedBy(start), end: self.startIndex.advancedBy(end))
        return self.substringWithRange(range)
    }
    
    /// 文字列の部分取得を行う
    ///
    ///     "hello".substringWithRange(1, length: 3) // "ell"
    /// - parameter start: 開始インデックス
    /// - parameter length: 文字列長
    /// - returns: 部分取得された文字列
    func substringWithRange(start: Int, length: Int) -> String {
        if (start < 0 || start > self.characters.count) {
            return ""
        }
        else if length < 0 || start + length > self.characters.count {
            return ""
        }
        let range = Range(start: self.startIndex.advancedBy(start), end: self.startIndex.advancedBy(start + length))
        return self.substringWithRange(range)
    }
}

/// 文字列分割を行う
///
///     split("file/path/to", "/") // ["file", "path", "to"]
/// - parameter string: 対象の文字列
/// - parameter separator: 分割に使用するセパレータ文字
/// - parameter allowEmpty: 空文字を許可するかどうか。falseにすると分割された結果が空文字だった場合は配列に入りません
/// - returns: 分割された結果の文字列配列
public func split(string: String, _ separator: String, allowEmpty: Bool = true) -> [String] {
    return string.split(separator, allowEmpty: allowEmpty)
}

/// 文字列結合を行う
///
///     join(["file", "path", "to"], "/") // "file/path/to"
/// - parameter strings: 対象の文字列
/// - parameter glue: 結合に使用する文字
/// - returns: 結合した結果の文字列
public func join(strings: [String], _ glue: String) -> String {
    return (strings as NSArray).componentsJoinedByString(glue)
}

