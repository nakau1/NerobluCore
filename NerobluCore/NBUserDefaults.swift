// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// UserDefaultsの機能をラップした永続的データを取り扱うクラス
public class NBUserDefaults {
    
    private static let Prefix = "NBUserDefaults_"
    
    /// 現在の設定情報
    public class var currentConfigs: [String : AnyObject?] {
        var ret = [String : AnyObject?]()
        self.ud.dictionaryRepresentation().forEach {
            let key = $0.0, val = $0.1
            if key.hasPrefix(self.Prefix) {
                ret[key] = val
            }
        }
        return ret
    }
    
    /// 辞書からデフォルト値を設定する
    /// - parameter dictionary: デフォルト値情報の入った辞書
    public class func setDefaults(dictionary: [String : AnyObject?]) {
        let currentConfigs = self.currentConfigs
        var defaultConfigs = [String : AnyObject?]()
        
        dictionary.forEach {
            let key = $0.0, val = $0.1
            if currentConfigs[self.configKey(key)] == nil {
                defaultConfigs[key] = val
            }
        }
        self.setObjects(defaultConfigs)
    }
    
    /// 指定したキーの設定を削除する
    /// - parameter key: キー
    public class func removeKey(key: String) {
        self.ud.removeObjectForKey(key)
        self.ud.synchronize()
    }
    
    /// 辞書から一括で設定値を設定する
    /// - parameter dictionary: 設定値情報の入った辞書
    public class func setObjects(dictionary: [String : AnyObject?]) {
        dictionary.forEach {
            let key = $0.0, val = $0.1
            self.setObject(val, key: key)
        }
    }
    
    /// 設定値をセットする
    /// - parameter value: 値
    /// - parameter key: キー
    public class func setObject(value: AnyObject?, key: String) {
        if let url = value as? NSURL {
            self.ud.setURL(url, forKey: self.configKey(key))
        }
        else {
            self.ud.setObject(value, forKey: self.configKey(key))
        }
        self.ud.synchronize()
    }
    
    /// 指定したキーの値を取得する
    /// - parameter key: キー
    /// - returns: 値
    public class func objectForKey(key: String) -> AnyObject? { return self.ud.objectForKey(self.configKey(key)) }
    
    /// 指定したキーの値を取得する
    /// - parameter key: キー
    /// - returns: 値
    public class func stringForKey(key: String) -> String? { return self.ud.stringForKey(self.configKey(key)) }
    
    /// 指定したキーの値を取得する
    /// - parameter key: キー
    /// - returns: 値
    public class func arrayForKey(key: String) -> [AnyObject]? { return self.ud.arrayForKey(self.configKey(key)) }
    
    /// 指定したキーの値を取得する
    /// - parameter key: キー
    /// - returns: 値
    public class func dictionaryForKey(key: String) -> [String : AnyObject]? { return self.ud.dictionaryForKey(self.configKey(key)) }
    
    /// 指定したキーの値を取得する
    /// - parameter key: キー
    /// - returns: 値
    public class func dataForKey(key: String) -> NSData? { return self.ud.dataForKey(self.configKey(key)) }
    
    /// 指定したキーの値を取得する
    /// - parameter key: キー
    /// - returns: 値
    public class func stringArrayForKey(key: String) -> [String]? { return self.ud.stringArrayForKey(self.configKey(key)) }
    
    /// 指定したキーの値を取得する
    /// - parameter key: キー
    /// - returns: 値
    public class func integerForKey(key: String) -> Int { return self.ud.integerForKey(self.configKey(key)) }
    
    /// 指定したキーの値を取得する
    /// - parameter key: キー
    /// - returns: 値
    public class func floatForKey(key: String) -> Float { return self.ud.floatForKey(self.configKey(key)) }
    
    /// 指定したキーの値を取得する
    /// - parameter key: キー
    /// - returns: 値
    public class func doubleForKey(key: String) -> Double { return self.ud.doubleForKey(self.configKey(key)) }
    
    /// 指定したキーの値を取得する
    /// - parameter key: キー
    /// - returns: 値
    public class func boolForKey(key: String) -> Bool { return self.ud.boolForKey(self.configKey(key)) }
    
    /// 指定したキーの値を取得する
    /// - parameter key: キー
    /// - returns: 値
    public class func URLForKey(key: String) -> NSURL? { return self.ud.URLForKey(self.configKey(key)) }
    
    
    private class func configKey(name: String) -> String {
        return "\( self.Prefix )\( name )"
    }
    
    private class var ud: NSUserDefaults { return NSUserDefaults.standardUserDefaults() }
}
