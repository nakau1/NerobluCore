// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK: - String拡張: 文字列長 -
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
}

// MARK: - String拡張: ローカライズ -
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


// MARK: - String拡張: フォーマット -
public extension String {

    /// 自身をフォーマットとしてフォーマット化された文字列を取得する
    ///
    ///     "Hello %@".format("World") // "Hello World"
    /// - parameter args: 引数
    /// - returns: フォーマット化された文字列
    public func format(args: CVarArgType...) -> String {
        let s = NSString(format: self, arguments: getVaList(args))
        return s as String
    }
    
}

// MARK: - String拡張: オプショナル -
extension String {
    
    /// 空文字列であればnilを返す
    public var empty2nil: String? {
        return self.isEmpty ? nil : self
    }
}

// MARK: - String拡張: 文字列操作 -
public extension String {
    
    /// 文字列置換を行う
    ///
    ///     "Hello".replace("e", "o") // "Hollo"
    /// - parameter search: 検索する文字
    /// - parameter replacement: 置換する文字
    /// - returns: 置換された文字列
    public func replace(search: String, _ replacement: String) -> String {
        return self.stringByReplacingOccurrencesOfString(search, withString: replacement, options: NSStringCompareOptions(), range: nil)
    }
    
    /// 指定した範囲の文字列置換を行う
    ///
    /// - parameter range: 範囲
    /// - parameter replacement: 置換する文字
    /// - returns: 置換された文字列
    public func replace(range: NSRange, _ replacement: String) -> String {
        return self.ns.stringByReplacingCharactersInRange(range, withString: replacement)
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
    
    /// 改行コードで文字列分割を行う
    /// - returns: 分割された結果の文字列配列
    public func splitCarriageReturn() -> [String] {
        return self.split("\r\n")
    }
    
    /// カンマで文字列分割を行う
    /// - returns: 分割された結果の文字列配列
    public func splitComma() -> [String] {
        return self.split(",")
    }
    
    /// スラッシュで文字列分割を行う
    /// - returns: 分割された結果の文字列配列
    public func splitSlash() -> [String] {
        return self.split("/")
    }
    
    /// 空白文字で文字列分割を行う
    /// - returns: 分割された結果の文字列配列
    public func splitWhitespace() -> [String] {
        return self.split(" ")
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
}

// MARK: - String拡張: 部分取得 -
public extension String {
    
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
    public func substringWithRange(start: Int, length: Int) -> String {
        if (start < 0 || start > self.characters.count) {
            return ""
        }
        else if length < 0 || start + length > self.characters.count {
            return ""
        }
        let range = Range(start: self.startIndex.advancedBy(start), end: self.startIndex.advancedBy(start + length))
        return self.substringWithRange(range)
    }
    
    /// 文字列の部分取得を行う
    ///
    ///     "hello".substringWithRange(fromIndex: 1) // "ello"
    /// - parameter start: 開始インデックス
    /// - returns: 開始インデックスから文字列の最後までを部分取得した文字列
    public func substringWithRange(fromIndex start: Int) -> String {
        let length = self.length - start
        return length > 0 ? self.substringWithRange(start, length: length) : ""
    }
    
    /// 文字列の部分取得を行う
    ///
    /// - parameter range: NSRange構造体
    /// - returns: 部分取得した文字列
    public func substringWithRange(range range: NSRange) -> String {
        return self.substringWithRange(range.location, length: range.length)
    }
}

// MARK: - String拡張: 正規表現 -
public extension String {

    /// 文字列から正規表現パターンに合った文字列を配列で取り出す
    ///
    /// - parameter pattern: 正規表現パターン
    /// - parameter regularExpressionOptions: 正規表現オプション
    /// - parameter matchingOptions: 正規表現マッチングオプション
    /// - returns: 正規表現パターンに合った文字列の配列
    public func stringsMatchedRegularExpression(pattern: String, regularExpressionOptions: NSRegularExpressionOptions? = nil, matchingOptions: NSMatchingOptions? = nil) -> [String] {
        
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: regularExpressionOptions ?? NSRegularExpressionOptions()) else { return [] }
        
        let results = regExp.matchesInString(self, options: matchingOptions ?? NSMatchingOptions(), range: NSMakeRange(0, self.length))
        var ret = [String]()
        for result in results {
            ret.append(self.substringWithRange(range: result.rangeAtIndex(0)))
        }
        return ret
    }
    
    /// 文字列から正規表現パターンに合った文字列を配列で取り出す
    ///
    /// - parameter pattern: 正規表現パターン
    /// - parameter regularExpressionOptions: 正規表現オプション
    /// - parameter matchingOptions: 正規表現マッチングオプション
    /// - returns: 正規表現パターンに合った文字列の配列
    public func stringMatchedRegularExpression(pattern: String, regularExpressionOptions: NSRegularExpressionOptions? = nil, matchingOptions: NSMatchingOptions? = nil) -> String? {
        return self.stringsMatchedRegularExpression(pattern, regularExpressionOptions: regularExpressionOptions, matchingOptions: matchingOptions).first
    }
    
    /// 指定した正規表現パターンに合うかどうかを返す
    ///
    /// - parameter pattern: 正規表現パターン
    /// - returns: 文字列から正規表現パターンに合うかどうか
    public func isMatchedRegularExpression(pattern: String) -> Bool {
        let range = self.ns.rangeOfString(pattern, options: .RegularExpressionSearch)
        return range.location != NSNotFound
    }
    
    /// 文字列から正規表現パターンに合った箇所を置換した文字列を返す
    ///
    /// - parameter pattern: 正規表現パターン
    /// - parameter replacement: 置換する文字
    /// - parameter regularExpressionOptions: 正規表現オプション
    /// - parameter matchingOptions: 正規表現マッチングオプション
    /// - returns: 置換した文字列
    public func replaceMatchedRegularExpression(pattern: String, replacement: String, regularExpressionOptions: NSRegularExpressionOptions? = nil, matchingOptions: NSMatchingOptions? = nil) -> String {
        
        let mutableSelf = self.mutable
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: regularExpressionOptions ?? NSRegularExpressionOptions()) else {
            return "\(self)"
        }
        regExp.replaceMatchesInString(mutableSelf, options: matchingOptions ?? NSMatchingOptions(), range: NSMakeRange(0, self.length), withTemplate: replacement)
        
        return mutableSelf as String
    }
    
    /// 文字列から正規表現パターンに合った箇所を削除した文字列を返す
    ///
    /// - parameter pattern: 正規表現パターン
    /// - parameter regularExpressionOptions: 正規表現オプション
    /// - parameter matchingOptions: 正規表現マッチングオプション
    /// - returns: 削除した文字列
    public func removeMatchedRegularExpression(pattern: String, regularExpressionOptions: NSRegularExpressionOptions? = nil, matchingOptions: NSMatchingOptions? = nil) -> String {
        return self.replaceMatchedRegularExpression(pattern, replacement: "", regularExpressionOptions: regularExpressionOptions, matchingOptions: matchingOptions)
    }
}

// MARK: - String拡張: トランスフォーム -
public extension String {
    
    /// 指定した変換方法で変換した文字列を返す
    ///
    /// - parameter transform: 変換方法
    /// - parameter reverse: 変換順序
    /// - returns: 変換した文字列
    public func stringTransformWithTransform(transform: CFStringRef, reverse: Bool) -> String {
        let mutableSelf = self.mutable as CFMutableString
        CFStringTransform(mutableSelf, nil, transform, reverse)
        return mutableSelf as String
    }
    
    /// 半角文字を全角文字に変換した文字列を返す
    /// - returns: 変換した文字列
    public func stringToFullwidth() -> String {
        return self.stringTransformWithTransform(kCFStringTransformFullwidthHalfwidth, reverse: true)
    }
    
    /// 全角文字を半角文字に変換した文字列を返す
    /// - returns: 変換した文字列
    public func stringToHalfwidth() -> String {
        return self.stringTransformWithTransform(kCFStringTransformFullwidthHalfwidth, reverse: false)
    }
    
    /// カタカタをひらがなに変換した文字列を返す
    /// - returns: 変換した文字列
    public func stringKatakanaToHiragana() -> String {
        return self.stringTransformWithTransform(kCFStringTransformHiraganaKatakana, reverse: true)
    }
    
    /// ひらがなをカタカナに変換した文字列を返す
    /// - returns: 変換した文字列
    public func stringHiraganaToKatakana() -> String {
        return self.stringTransformWithTransform(kCFStringTransformHiraganaKatakana, reverse: false)
    }
    
    /// ローマ字をひらがなに変換した文字列を返す
    /// - returns: 変換した文字列
    public func stringHiraganaToLatin() -> String {
        return self.stringTransformWithTransform(kCFStringTransformLatinHiragana, reverse: true)
    }
    
    /// ひらがなをローマ字に変換した文字列を返す
    /// - returns: 変換した文字列
    public func stringLatinToHiragana() -> String {
        return self.stringTransformWithTransform(kCFStringTransformLatinHiragana, reverse: false)
    }
    
    /// ローマ字をカタカナに変換した文字列を返す
    /// - returns: 変換した文字列
    public func stringKatakanaToLatin() -> String {
        return self.stringTransformWithTransform(kCFStringTransformLatinKatakana, reverse: true)
    }
    
    /// カタカナをローマ字に変換した文字列を返す
    /// - returns: 変換した文字列
    public func stringLatinToKatakana() -> String {
        return self.stringTransformWithTransform(kCFStringTransformLatinKatakana, reverse: false)
    }
}

// MARK: - String拡張: URLエンコード -
public extension String {
    
    /// URLエンコードした文字列
    public var urlEncode: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet()) ?? ""
    }
    
    /// URLデコードした文字列
    public var urlDecode: String {
        return self.stringByRemovingPercentEncoding ?? ""
    }
}

// MARK: - String拡張: 記法変換 -
public extension String {
    
    /// スネーク記法をキャメル記法に変換した文字列
    public var snakeToCamel: String {
        if self.isEmpty { return "" }
        
        let r = NSMakeRange(0, 1)
        var ret = self.capitalizedString.stringByReplacingOccurrencesOfString("_", withString: "")
        ret = ret.ns.stringByReplacingCharactersInRange(r, withString: ret.ns.substringWithRange(r).lowercaseString)
        return ret
    }
    
    /// キャメル記法をスネーク記法に変換した文字列
    public var camelToSnake: String {
        if self.isEmpty { return "" }
        return self.replaceMatchedRegularExpression("(?<=\\w)([A-Z])", replacement: "_$1").lowercaseString
    }
}


// MARK: - String拡張: Objective-C連携 -
public extension String {
    
    /// NSStringにキャストした新しい文字列オブジェクト
    public var ns: NSString { return NSString(string: self) }
    
    /// NSMutableStringにキャストした新しい文字列オブジェクト
    public var mutable: NSMutableString { return NSMutableString(string: self) }
}

// MARK: - String汎用関数 -

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

