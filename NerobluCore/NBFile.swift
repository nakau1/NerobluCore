// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK: - NBFile  -

/// ファイルオブジェクトクラス
public class NBFile {
    
    /// ファイルの絶対パス
    public private(set) var path = ""
    
    /// イニシャライザ
    /// - parameter path: ファイルパス
    public init(path: String) {
        //super.init()
        self.path = path
    }
    
    /// ファイル名
    public var name: String {
        return self.pathString.lastPathComponent
    }
    
    /// 拡張子
    public var extensions: String {
        return self.pathString.pathExtension
    }
    
    /// 拡張子抜きのファイル名
    public var nameWithoutExtension: String {
        return (self.name as NSString).stringByDeletingPathExtension
    }
    
    /// ディレクトリパス
    public var directoryPath: String {
        if self.path == "/" { return "" }
        return self.pathString.stringByDeletingLastPathComponent
    }
    
    /// ファイルURL
    public var url: NSURL {
        return NSURL(fileURLWithPath: self.path, isDirectory: self.isDirectory)
    }
}

// MARK: - ファイル確認関連  -
public extension NBFile {
    
    /// ファイルが存在するかどうか
    public var exists: Bool {
        return self.manager.fileExistsAtPath(self.path)
    }
    
    /// ファイルかどうか
    public var isFile: Bool {
        var isDirectory: ObjCBool = false
        if self.manager.fileExistsAtPath(self.path, isDirectory: &isDirectory) {
            if !isDirectory { return true }
        }
        return false
    }
    
    /// ディレクトリかどうか
    public var isDirectory: Bool {
        var isDirectory: ObjCBool = false
        if self.manager.fileExistsAtPath(self.path, isDirectory: &isDirectory) {
            if isDirectory { return true }
        }
        return false
    }
}

// MARK: - 属性確認関連  -
public extension NBFile {
    
    /// ファイルサイズ
    public var size: UInt64 {
        guard let n = self.fileAttributeForKey(NSFileSize) as? NSNumber else { return 0 }
        return n.unsignedLongLongValue
    }
    
    /// ファイルの作成日付
    public var createdDate: NSDate? {
        return self.fileAttributeForKey(NSFileCreationDate) as? NSDate
    }
    
    /// ファイルの更新日付
    public var modifiedDate: NSDate? {
        return self.fileAttributeForKey(NSFileModificationDate) as? NSDate
    }
    
    /// ファイル属性
    public var fileAttributes: [String : AnyObject] {
        var ret = [String : AnyObject]()
        if self.exists {
            if let attr = try? self.manager.attributesOfItemAtPath(self.path) {
                ret.merge(attr)
            }
            if let attr = try? self.manager.attributesOfFileSystemForPath(self.path) {
                ret.merge(attr)
            }
        }
        return ret
    }
    
    /// 指定したキーのファイル属性を返却する
    /// - parameter key: キー
    /// - returns: ファイル属性値
    private func fileAttributeForKey(key: String) -> AnyObject? {
        return self.fileAttributes[key]
    }
}

// MARK: - ディレクトリ親子関係  -
public extension NBFile {
    
    /// 親ディレクトリ(親ディレクトリが存在しない場合はnilを返す)
    public var parent: NBFile? {
        let ret = NBFile.init(path: self.directoryPath)
        return ret.exists ? ret : nil
    }
    
    /// ディレクトリ内のファイル(ディレクトリも含む)をすべて配列で返す(自身がディレクトリでない場合は空配列を返す)
    public var files: [NBFile] {
        var ret = [NBFile]()
        guard let names = try? self.manager.contentsOfDirectoryAtPath(self.path) where self.isDirectory else { return ret }
        for name in names {
            let path = self.pathString.stringByAppendingPathComponent(name)
            ret.append(NBFile(path: path))
        }
        return ret
    }
    
    /// ディレクトリ内のファイル(ディレクトリも含む)パス文字列をすべて配列で返す(自身がディレクトリでない場合は空配列を返す)
    public var filePaths: [String] {
        return self.files.map { $0.path }
    }
    
    /// ディレクトリ内のファイル(ディレクトリも含む)名をすべて配列で返す(自身がディレクトリでない場合は空配列を返す)
    public var fileNames: [String] {
        return self.files.map { $0.name }
    }
}

// MARK: -   -
public extension NBFile {
    
    /// パスにディレクトリを追加した新しいファイルオブジェクトを取得する
    ///
    /// このメソッドを使用するには自身がディレクトリである必要があり、そうでない場合はエラーとしてnilを返します。
    /// また、ディレクトリ作成に失敗した場合にもnilを返します
    ///
    ///     // 下記例では、ドキュメントディレクトリに images/thumbnails というディレクトリを作成できます
    ///     let dir = NBFile.documentDirectory().appendDirectory("images/thumbnails")
    ///
    /// - parameter location: "/"で区切ったディレクトリドキュメント以下のパス
    /// - parameter make: ディレクトリが存在しない場合に作成するかどうか
    /// - returns: 新しいファイルオブジェクト
    public func appendDirectory(location: String?, shouldMakeDirectoryIfNotExists make: Bool = true) -> NBFile? {
        if !self.isDirectory {
            E("cannot append directory because argument is not directory. path ='\(self.path)'")
            return nil
        }
        if (location?.isEmpty ?? true) {
            return self
        }
        
        var path = self.path
        for locationElement in self.locationElements(location) {
            path = (path as NSString).stringByAppendingPathComponent(locationElement)
        }
        
        if make && !self.manager.fileExistsAtPath(path) {
            do {
                try self.manager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                E("failed make directory. path ='\(path)'")
                return nil
            }
        }
        return NBFile(path: path)
    }
    
    /// パスにファイル名を追加した新しいファイルオブジェクトを取得する
    ///
    /// このメソッドを使用するには自身がディレクトリである必要があり、そうでない場合はエラーとしてnilを返します
    /// - parameter fileName: ファイル名
    /// - returns: 新しいファイルオブジェクト
    public func appendFile(fileName: String) -> NBFile? {
        if !self.isDirectory {
            E("cannot append file-name because argument is not directory. path ='\(self.path)'")
            return nil
        }
        return NBFile(path: self.pathString.stringByAppendingPathComponent(fileName))
    }

    /// "/"で区切った文字列を分割して配列化する
    /// - parameter makeDirIfNotExists: ディレクトリが存在しない場合作成するかどうか
    /// - returns: ロケーションで指定したドキュメントディレクトリ内のディレクトリ絶対パス
    private func locationElements(location: String?) -> [String] {
        guard let location = location else { return [] }
        return location.componentsSeparatedByString("/").filter { !$0.isEmpty }
    }
}

// MARK: - ファイル内容取得 -
public extension NBFile {
    
    /// テキストファイルの内容を取得する
    /// - parameter encoding: 文字エンコーディング(デフォルトはUTF-8)
    /// - returns: テキストファイルの内容(取得できない場合はnil)
    public func textOfFileContents(encoding: NSStringEncoding = NSUTF8StringEncoding) -> String? {
        if let data = NSData(contentsOfFile: self.path) {
            return String(data: data, encoding: NSUTF8StringEncoding)
        }
        return nil
    }
    
    /// 画像ファイルから画像データを取得する
    /// - returns: 画像データ(取得できない場合はnil)
    public func imageOfFileContents() -> UIImage? {
        if let data = NSData(contentsOfFile: self.path) {
            return UIImage(data: data)
        }
        return nil
    }
}

// MARK: - ファイル書き込み -
public extension NBFile {
    
    /// 文字列をファイルに書き込む
    /// - parameter text: 書き込む文字列
    /// - parameter encoding: 文字エンコーディング(デフォルトはUTF-8)
    /// - returns: 例外が発生した場合はfalseを返す
    public func writeText(text: String, encoding: NSStringEncoding = NSUTF8StringEncoding) -> Bool {
        do {
            try text.writeToFile(self.path, atomically: true, encoding: encoding)
            return true
        } catch {
            return false
        }
    }
}

// MARK: - 汎用ディレクトリ取得 -
public extension NBFile {
    
    /// ドキュメントディレクトリオブジェクトを生成する
    /// - returns: ドキュメントディレクトリにパス指定されたNBFileオブジェクト
    public class func documentDirectory() -> NBFile {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        return NBFile(path: path)
    }
    
    /// メインバンドルオブジェクトを生成する
    /// - returns: メインバンドルにパス指定されたNBFileオブジェクト
    public class func mainBundle() -> NBFile {
        let path = NSBundle.mainBundle().bundlePath
        return NBFile(path: path)
    }
}

// MARK: - ファイルコピー -
public extension NBFile {
    
    /// ファイルをコピーする
    /// - parameter to: 実行先のパス
    /// - parameter forcibly: 実行先にファイルがある場合は事前に削除を試みるかどうか
    /// - returns: エラーがあった場合にNSErrorを返す
    public func copyFile(to: String, forcibly: Bool = true) -> NSError? {
        return self.copyFile(NBFile(path: to), forcibly: forcibly)
    }
    
    /// ファイルをコピーする
    /// - parameter to: 実行先
    /// - parameter forcibly: 実行先にファイルがある場合は事前に削除を試みるかどうか
    /// - returns: エラーがあった場合にNSErrorを返す
    public func copyFile(to: NBFile, forcibly: Bool = true) -> NSError?  {
        if !self.exists {
            return self.createIOError(.NotExists)
        }
        
        if to.exists && forcibly {
            if let error = to.deleteFile() {
                return error
            }
        }
        
        do {
            try self.manager.copyItemAtPath(self.path, toPath: to.path)
        } catch {
            return self.createIOError(.FailedCopy)
        }
        
        return nil
    }
}
// MARK: - ファイル移動 -
public extension NBFile {

    /// ファイルを移動する
    /// - parameter to: 実行先のパス
    /// - parameter forcibly: 実行先にファイルがある場合は事前に削除を試みるかどうか
    /// - returns: エラーがあった場合にNSErrorを返す
    public func moveFile(to: String, forcibly: Bool = true) -> NSError? {
        return self.moveFile(NBFile(path: to), forcibly: forcibly)
    }
    
    /// ファイルを移動する
    /// - parameter to: 実行先
    /// - parameter forcibly: 実行先にファイルがある場合は事前に削除を試みるかどうか
    /// - returns: エラーがあった場合にNSErrorを返す
    public func moveFile(to: NBFile, forcibly: Bool = true) -> NSError?  {
        if !self.exists {
            return self.createIOError(.NotExists)
        }
        
        if to.exists && forcibly {
            if let error = to.deleteFile() {
                return error
            }
        }
        
        do {
            try self.manager.moveItemAtPath(self.path, toPath: to.path)
        } catch {
            return self.createIOError(.FailedCopy)
        }
        
        return nil
    }
}

// MARK: - ファイル削除 -
public extension NBFile {
    
    /// ファイルを削除する
    /// - returns: エラーがあった場合にNSErrorを返す
    public func deleteFile() -> NSError?  {
        if !self.exists {
            return self.createIOError(.NotExists)
        }
        
        do {
            try self.manager.removeItemAtPath(self.path)
        } catch {
            return self.createIOError(.FailedDelete)
        }
        
        return nil
    }
}

// MARK: - 汎用プライベート処理 -
private extension NBFile {
    
    /// ファイルマネージャ
    private var manager: NSFileManager { return NSFileManager.defaultManager() }
    
    /// NSStringにキャストしたパス文字列
    private var pathString: NSString { return self.path as NSString }
}

// MARK: - I/Oエラー関連 -
private extension NBFile {
    
    /// I/Oエラー種別
    private enum IOError: Int {
        case NotExists    = 404
        case FailedCopy   = 501
        case FailedDelete = 502
        
        private var message: String {
            switch self {
            case .NotExists:    return "file is not exitsts"
            case .FailedCopy:   return "failed copy file"
            case .FailedDelete: return "failed delete file"
            }
        }
    }
    
    /// I/Oエラーを生成する
    /// - parameter ioerror: I/Oエラー種別
    /// - returns: エラーオブジェクト
    private func createIOError(ioerror: IOError) -> NSError {
        return Error(ioerror.message, ioerror.rawValue, "NBFileErrorDomain")
    }
}
