// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// -------------------------------------------------------------------
// このファイルでは全体で使用する汎用・共通の定義を行います
// -------------------------------------------------------------------

/// 処理完了時のハンドラクロージャ
public typealias CompletionHandler = (Void)->Void

/// 処理完了時のハンドラクロージャ(エラー付き)
public typealias CompletionHandlerWithError = (NSError?)->Void

// MARK: - 汎用定数 -

/// 画面の幅
public let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
/// 画面の高さ
public let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height

// MARK: - 汎用関数 -

/// メインスレッド(キュー)との同期をとって処理を実行する
/// - parameter block: メインスレッドで行う処理
public func NBExecuteMainThread(block: ()->()) {
    dispatch_async(dispatch_get_main_queue(), block)
}

/// 新しいスレッド(キュー)との同期をとって処理を実行する
/// - parameter block: 新しいスレッドで行う処理
public func NBExecuteNewThread(block: ()->()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
}
