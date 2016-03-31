// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// 処理完了時のハンドラクロージャ
public typealias CompletionHandler = (Void) -> Void

/// 処理完了時のハンドラクロージャ(オプショナルのエラー付き)
public typealias CompletionHandlerWithError = (NSError?) -> Void

/// 処理完了時のハンドラクロージャ(結果ステータス付き)
public typealias CompletionHandlerWithResultState = (ResultState) -> Void

/// 汎用的な結果ステータス
public enum ResultState {
    /// 未実行状態(初期状態)
    case None
    /// 成功
    case Succeed
    /// 失敗
    case Failed(NSError)
    
    /// エラーオブジェクト(Failedの場合だけ取得できる)
    public var error: NSError? { switch self { case let .Failed(err): return err default: return nil } }
    
    /// 成功/失敗(Succeedの場合だけtrueになる)
    public var succeed: Bool { switch self { case .Succeed: return true default: return false } }
}

/// デバックかどうか
public var IS_DEBUG: Bool {
    #if DEBUG
        return true
    #else
        return false
    #endif
}

/// iPadかどうか
public var IS_IPAD: Bool {
    return UIDevice.currentDevice().model.hasPrefix("iPad")
}

/// シミュレータかどうか
public var IS_SIMULATOR: Bool {
    return TARGET_OS_SIMULATOR != 0
}

// MARK: 非同期処理

/// 非同期処理を行う
/// - parameter asynchronousProcess: 非同期処理(別スレッドで実行する処理)
/// - parameter completionHandler: 非同期処理完了時に行う処理
public func async(async asynchronousProcess: ()->(), completed completionHandler: CompletionHandler) {
    onNewThread {
        asynchronousProcess()
        onMainThread {
            completionHandler()
        }
    }
}

/// 秒を指定して非同期処理でスリープを行う
/// - parameter sec: スリープ秒数
/// - parameter completionHandler: スリープ完了時に行う処理
public func asyncSleep(seconds sec: UInt32, completionHandler: CompletionHandler) {
    async(async: { sleep(sec) }, completed: completionHandler)
}

/// ミリ秒を指定して非同期処理でスリープを行う
/// - parameter milliseconds: スリープのミリ秒数
/// - parameter completionHandler: スリープ完了時に行う処理
public func asyncSleep(milliseconds: useconds_t, completionHandler: CompletionHandler) {
    async(async: { usleep(milliseconds) }, completed: completionHandler)
}

/// スリープ間隔を指定して非同期処理でスリープを行う
/// - parameter duration: スリープ間隔
/// - parameter completionHandler: スリープ完了時に行う処理
public func asyncSleep(duration: NSTimeInterval, completionHandler: CompletionHandler) {
    async(async: { usleep(useconds_t(duration * 1000000)) }, completed: completionHandler)
}

/// メインスレッド(キュー)との同期をとって処理を実行する
/// - parameter block: メインスレッドで行う処理
public func onMainThread(block: ()->()) {
    dispatch_async(dispatch_get_main_queue(), block)
}

/// 新しいスレッド(キュー)との同期をとって処理を実行する
/// - parameter block: 新しいスレッドで行う処理
public func onNewThread(block: ()->()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
}

