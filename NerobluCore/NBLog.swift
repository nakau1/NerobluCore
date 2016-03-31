// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK: - 関数 -

/// ログ出力を行う
/// - parameter target: 対象の値
/// - parameter title: タイトル
/// - parameter level: ログ出力レベル
/// - parameter functionName: (常に省略することを推奨)関数(メソッド)名
/// - parameter fileName: (常に省略することを推奨)ファイル名
/// - parameter lineNumber: (常に省略することを推奨)行番号
public func NBLog(target: Any?, _ title: String? = nil, level: NBLogLevel = .Debug, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
    
    let option = NBLoggerOption(
        title:        title,
        level:        level,
        functionName: functionName,
        fileName:     fileName,
        lineNumber:   lineNumber
    )
    
    NBLogger(target, option).execute()
}

/// デバッグ用ログ出力を行う
/// - parameter target: 対象の値
/// - parameter title: タイトル
/// - parameter functionName: (常に省略することを推奨)関数(メソッド)名
/// - parameter fileName: (常に省略することを推奨)ファイル名
/// - parameter lineNumber: (常に省略することを推奨)行番号
public func D(target: Any?, _ title: String? = nil, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
    NBLog(target, title, level: .Debug, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

/// エラーログ出力を行う
/// - parameter target: 対象の値
/// - parameter title: タイトル
/// - parameter functionName: (常に省略することを推奨)関数(メソッド)名
/// - parameter fileName: (常に省略することを推奨)ファイル名
/// - parameter lineNumber: (常に省略することを推奨)行番号
public func E(target: Any?, _ title: String? = nil, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
    NBLog(target, title, level: .Error, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

/// 情報ログ出力を行う
/// - parameter target: 対象の値
/// - parameter title: タイトル
/// - parameter functionName: (常に省略することを推奨)関数(メソッド)名
/// - parameter fileName: (常に省略することを推奨)ファイル名
/// - parameter lineNumber: (常に省略することを推奨)行番号
public func I(target: Any?, _ title: String? = nil, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
    NBLog(target, title, level: .Information, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

/// 警告ログ出力を行う
/// - parameter target: 対象の値
/// - parameter title: タイトル
/// - parameter functionName: (常に省略することを推奨)関数(メソッド)名
/// - parameter fileName: (常に省略することを推奨)ファイル名
/// - parameter lineNumber: (常に省略することを推奨)行番号
public func W(target: Any?, _ title: String? = nil, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
    NBLog(target, title, level: .Warning, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

/// イベントログ出力を行う
/// - parameter target: 対象の値
/// - parameter title: タイトル
/// - parameter functionName: (常に省略することを推奨)関数(メソッド)名
/// - parameter fileName: (常に省略することを推奨)ファイル名
/// - parameter lineNumber: (常に省略することを推奨)行番号
public func ev(target: Any?, _ title: String? = nil, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
    NBLog(target, title, level: .Event, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

// MARK: - 出力レベル -

/// 出力レベルをビット定義する構造体
public struct NBLogLevel : OptionSetType {
    
    public let  rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    
    public static let Debug       = NBLogLevel(rawValue: 1 << 0)
    public static let Information = NBLogLevel(rawValue: 1 << 1)
    public static let Warning     = NBLogLevel(rawValue: 1 << 2)
    public static let Error       = NBLogLevel(rawValue: 1 << 3)
    public static let Fetal       = NBLogLevel(rawValue: 1 << 4)
    public static let Query       = NBLogLevel(rawValue: 1 << 5)
    public static let QueryResult = NBLogLevel(rawValue: 1 << 6)
    public static let Request     = NBLogLevel(rawValue: 1 << 7)
    public static let Response    = NBLogLevel(rawValue: 1 << 8)
    public static let Event       = NBLogLevel(rawValue: 1 << 9)
    
    public static let None     = NBLogLevel([])
    public static let Problems = NBLogLevel([.Warning, .Error, .Fetal])
    public static let DB       = NBLogLevel([.Query, .QueryResult])
    public static let API      = NBLogLevel([.Request, .Response])
    public static let Verbose  = NBLogLevel([.Debug, .Information, .Event])
    public static let All      = NBLogLevel([.Problems, .DB, .API, .Verbose])
    
    internal var shortName: String {
        switch self.rawValue {
        case NBLogLevel.Debug       .rawValue: return "D"
        case NBLogLevel.Information .rawValue: return "I"
        case NBLogLevel.Warning     .rawValue: return "W"
        case NBLogLevel.Error       .rawValue: return "E"
        case NBLogLevel.Fetal       .rawValue: return "F"
        case NBLogLevel.Query       .rawValue: return "Q"
        case NBLogLevel.QueryResult .rawValue: return "R"
        case NBLogLevel.Request     .rawValue: return "q"
        case NBLogLevel.Response    .rawValue: return "r"
        case NBLogLevel.Event       .rawValue: return "e"
        default: return " "
        }
    }
}

/// ログ出力の日付フォーマット
public enum NBLogDateFormat : String {
    case Default    = "HH:mm:ss.SSS"
    case Time       = "HH:mm:ss"
    case DateTime   = "yyyy-MM-dd HH:mm:ss"
    case Punctual   = "yyyy-MM-dd HH:mm:ss.SSS"
    case Continuous = "mm.ss.SSS"
}

// MARK: - 出力設定 -

/// ログ出力の設定を行うための静的なクラス
public class NBLogConfig {
    
    /// 出力そのものの有効/無効
    public static var enabled = true
    
    /// フィルタする出力レベル
    ///
    /// 下例のように設定するとDebugのみが出力される
    ///
    ///	NBLogConfig.filterLevel = NBLogLevel([.Debug])
    ///
    /// 下例のように設定するとすべて出力される(初期値)
    ///
    ///	NBLogConfig.filterLevel = nil
    ///
    public static var filterLevel: NBLogLevel? = nil
    
    /// フィルタするタイトル
    ///
    /// 下例のように設定すると"ok"とタイトル設定したログのみが出力される
    ///
    ///	NBLogConfig.filterTitles = ["ok"]
    ///	D("出力される", 　"ok")
    ///	D("出力されない", "ng")
    ///
    public static var filterTitles: [String]? = nil
    
    /// 出力時にタイトルを出力するかどうか
    public static var showTitle = true
    
    /// 出力時にログ詳細情報を出力するかどうか
    ///
    /// ログ詳細情報とはタイトルと出力対象以外の情報を指します
    public static var showLogInformation = true
    
    /// 出力時にログ出力レベル(アルファベット1文字)を出力するかどうか
    public static var showLevel = false
    
    /// 出力時に関数名(メソッド名)を出力するかどうか
    public static var showFunctionName = false
    
    /// 出力時にファイル名を出力するかどうか
    public static var showFileName = true
    
    /// 出力時に行番号を出力するかどうか
    public static var showLineNumber = true
    
    /// 出力時にスレッド名を出力するかどうか
    public static var showThread = false
    
    /// 出力時に出力日時を出力するかどうか
    public static var showDateTime = true
    
    /// ファイル名を出力する場合、ファイル名だけを出力するかどうか
    ///
    /// true:ファイル名のみ、false:フルパス
    public static var isShortFileName = true
    
    /// 出力日時を出力する際の日付フォーマット
    public static var dateFormat: NBLogDateFormat = .Default
    
    /// すべて出力する設定に変更する
    public class func configureShowAll() {
        NBLogConfig.filterLevel        = nil
        NBLogConfig.filterTitles       = nil
        NBLogConfig.showTitle          = true
        NBLogConfig.showLogInformation = true
        NBLogConfig.showLevel          = true
        NBLogConfig.showFunctionName   = true
        NBLogConfig.showFileName       = true
        NBLogConfig.showLineNumber     = true
        NBLogConfig.showThread         = true
        NBLogConfig.showDateTime       = true
        NBLogConfig.isShortFileName    = false
        NBLogConfig.dateFormat         = .Punctual
    }
    
    /// シンプルな出力をする設定に変更する
    public class func configureSimply() {
        NBLogConfig.filterLevel        = nil
        NBLogConfig.filterTitles       = nil
        NBLogConfig.showTitle          = true
        NBLogConfig.showLogInformation = true
        NBLogConfig.showLevel          = false
        NBLogConfig.showFunctionName   = false
        NBLogConfig.showFileName       = true
        NBLogConfig.showLineNumber     = true
        NBLogConfig.showThread         = false
        NBLogConfig.showDateTime       = true
        NBLogConfig.isShortFileName    = true
        NBLogConfig.dateFormat         = .Time
    }
    
    /// 連続したイベント出力に適した設定に変更する
    public class func configureContinuous() {
        NBLogConfig.filterLevel        = NBLogLevel([.Event])
        NBLogConfig.filterTitles       = nil
        NBLogConfig.showTitle          = true
        NBLogConfig.showLogInformation = true
        NBLogConfig.showLevel          = false
        NBLogConfig.showFunctionName   = false
        NBLogConfig.showFileName       = false
        NBLogConfig.showLineNumber     = false
        NBLogConfig.showThread         = false
        NBLogConfig.showDateTime       = true
        NBLogConfig.isShortFileName    = true
        NBLogConfig.dateFormat         = .Continuous
    }
}

// MARK: - ログ出力実行 -

/// NBLogger用のオプション用構造体
internal struct NBLoggerOption {
    var title:        String?
    var level:        NBLogLevel
    var functionName: String
    var fileName:     String
    var lineNumber:   Int
}

/// ログ出力を実際に行うクラス
internal class NBLogger {
    
    let target: Any?
    let option: NBLoggerOption
    
    init(_ target: Any?, _ option: NBLoggerOption) {
        self.target = target
        self.option = option
    }
    
    internal func execute() {
        if !NBLogConfig.enabled || !self.isFilteredTitle() || !self.isFilteredLevel() {
            return
        }
        
        var logInformation = ""
        if let v = self.logInformationsText() {
            logInformation = "[\(v)] "
        }
        
        var title = ""
        if let t = self.titleText() {
            title = "'\(t)' > "
        }
        
        print("\(logInformation)\(title)\(self.fixedTarget())")
    }
    
    private func isFilteredTitle() -> Bool {
        guard
            let filterTitles = NBLogConfig.filterTitles,
            let title = self.option.title
            else {
                return true
        }
        return filterTitles.contains(title)
    }
    
    private func isFilteredLevel() -> Bool {
        guard let filterLevel = NBLogConfig.filterLevel else {
            return true
        }
        return filterLevel.contains(self.option.level)
    }
    
    private func logInformationsText() -> String? {
        if !NBLogConfig.showLogInformation { return nil }
        
        let logInformationTextClosures: [()->String?] = [
            { return self.logLevelLogInformationText()     },
            { return self.dateTimeLogInformationText()     },
            { return self.threadNameLogInformationText()   },
            { return self.fileNameLogInformationText()     },
            { return self.lineNumberLogInformationText()   },
            { return self.functionNameLogInformationText() },
        ]
        
        var texts = [String]()
        for logInformationTextClosure in logInformationTextClosures {
            if let logInformationText = logInformationTextClosure() {
                texts.append(logInformationText)
            }
        }
        if texts.isEmpty { return nil }
        
        return (texts as NSArray).componentsJoinedByString(" ")
    }
    
    private func fixedTarget() -> Any {
        if let value = self.target {
            if let text = value as? String {
                return "\"\(text)\""
            } else {
                return value
            }
        } else {
            return "(nil)"
        }
    }
    
    private func titleText() ->String? {
        if !NBLogConfig.showTitle { return nil }
        return self.option.title
    }
    
    private func dateTimeLogInformationText() -> String? {
        if !NBLogConfig.showDateTime { return nil }
        
        let dtf = NSDateFormatter()
        dtf.locale     = NSLocale.currentLocale()
        dtf.dateFormat = NBLogConfig.dateFormat.rawValue
        
        return dtf.stringFromDate(NSDate())
    }
    
    private func logLevelLogInformationText() -> String? {
        if !NBLogConfig.showLevel { return nil }
        return "\(self.option.level.shortName):"
    }
    
    private func fileNameLogInformationText() -> String? {
        if !NBLogConfig.showFileName { return nil }
        
        if NBLogConfig.isShortFileName {
            return (self.option.fileName as NSString).lastPathComponent
        } else {
            return self.option.fileName			
        }
    }
    
    private func lineNumberLogInformationText() -> String? {
        if !NBLogConfig.showLineNumber { return nil }
        return "(\(self.option.lineNumber))"
    }
    
    private func functionNameLogInformationText() -> String? {
        if !NBLogConfig.showFunctionName { return nil }
        return self.option.functionName
    }
    
    private func threadNameLogInformationText() -> String? {
        if !NBLogConfig.showThread { return nil }
        
        var name = "main"
        if !NSThread.isMainThread() {
            if let threadName = NSThread.currentThread().name where threadName != "" {
                name = threadName
            } else {
                name = String(format: "%p", NSThread.currentThread())
            }
        }
        return "[\(name)]"
    }
}

// MARK: - 簡易出力用拡張 -
private func _wrapped_print(items: Any...) { items.forEach { print($0) } }

extension String       { public func print() { _wrapped_print(self.isEmpty ? "(empty)" : self) } }
extension NSString     { public func print() { (self as String).print() } }
extension Int          { public func print() { _wrapped_print(self) } }
extension Float        { public func print() { _wrapped_print(self) } }
extension Double       { public func print() { _wrapped_print(self) } }
extension CGFloat      { public func print() { _wrapped_print(self) } }
extension Bool         { public func print() { _wrapped_print(self) } }
extension Array        { public func print() { _wrapped_print(self) } }
extension NSArray      { public func print() { (self as Array).print() } }
extension Dictionary   { public func print() { _wrapped_print(self) } }
extension NSDictionary { public func print() { (self as Dictionary).print() } }

