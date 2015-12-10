// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
/*
import UIKit
import SVProgressHUD

/// HUD表示の種別
public enum NBHudType
{
	/// 成功メッセージ
	case Success
	/// エラーメッセージ
	case Error
	/// 情報メッセージ
	case Info
}

/// HUD表示を行うクラス
public class NBHud
{
	// =========================================================================
	// 型定義
	// =========================================================================
	
	/// HUDが閉じられた時のコールバックハンドラ
	public typealias NBHudClosedHandler = ((Void)->Void)
	
	// =========================================================================
	// オプション設定
	// =========================================================================
	
	/// NBHudのオプションクラス
	public class Option
	{
		/// 背景色
		public static var backgroundColor: UIColor? {
			willSet { if let v = newValue { SVProgressHUD.setBackgroundColor(v) } }
		}
		
		/// 文字色
		public static var foregroundColor: UIColor? {
			willSet { if let v = newValue { SVProgressHUD.setForegroundColor(v) } }
		}
		
		/// プログレス表示のインジケータの太さ
		public static var ringThickness: CGFloat? {
			willSet { if let v = newValue { SVProgressHUD.setRingThickness(v) } }
		}
		
		/// フォント
		public static var font: UIFont? {
			willSet { if let v = newValue { SVProgressHUD.setFont(v) } }
		}
		
		/// 情報メッセージ時の画像(28x28を推奨)
		public static var infoImage: UIImage? {
			willSet { if let v = newValue { SVProgressHUD.setInfoImage(v) } }
		}
		
		/// 成功メッセージ時の画像(28x28を推奨)
		public static var successImage: UIImage? {
			willSet { if let v = newValue { SVProgressHUD.setSuccessImage(v) } }
		}
		
		/// 失敗メッセージ時の画像(28x28を推奨)
		public static var errorImage: UIImage? {
			willSet { if let v = newValue { SVProgressHUD.setErrorImage(v) } }
		}
	}
	
	// =========================================================================
	// ローディング表示
	// =========================================================================
	
	/// ローディングを表示する
	/// - parameters:
	///	  - message: メッセージ文言
	public class func startLoading(message: String = "Please Wait...")
	{
		
		
		
		
		/*
		if NBHud.showed { return }
		NBHud.showed = true
		
		NBHud.setEnabledInteractionEvents(false)
		SVProgressHUD.showWithStatus(message)
		*/
	}
	
	public class func endLoading(message: String, type: NBHudType, closedHandler: NBHudClosedHandler?)
	{
		
	}
	
	public class func endLoading(closedHandler: NBHudClosedHandler?)
	{
		
	}
	
	// =========================================================================
	// HUD管理
	// =========================================================================
	
	/// HUD表示を管理するクラス
	internal class NBHudManager : NSObject
	{
		
	}
	
	private static var manager = NBHudManager()
	
	// =========================================================================
	// 汎用メソッド
	// =========================================================================
	
	/// 画面のタップの受付を許可するかどうかを設定する
	/// - parameters:
	///	  - enabled: falseを渡すと画面の操作を受け付けなくなる<br/>trueで解除
	private class func setEnabledInteractionEvents(enabled: Bool)
	{
		if enabled {
			UIApplication.sharedApplication().endIgnoringInteractionEvents()
		} else {
			UIApplication.sharedApplication().beginIgnoringInteractionEvents()
		}
	}
}
*/

/*
/// HUDが閉じられた時のコールバックハンドラ
public typealias NBHudClosedHandler = ((Void)->Void)

// =========================================================================
// オプション設定
// =========================================================================

/// NBHudのオプションクラス
public class Option
{
/// 背景色
public static var backgroundColor: UIColor? {
willSet { if let v = newValue { SVProgressHUD.setBackgroundColor(v) } }
}

/// 文字色
public static var foregroundColor: UIColor? {
willSet { if let v = newValue { SVProgressHUD.setForegroundColor(v) } }
}

/// プログレス表示のインジケータの太さ
public static var ringThickness: CGFloat? {
willSet { if let v = newValue { SVProgressHUD.setRingThickness(v) } }
}

/// フォント
public static var font: UIFont? {
willSet { if let v = newValue { SVProgressHUD.setFont(v) } }
}

/// 情報メッセージ時の画像(28x28を推奨)
public static var infoImage: UIImage? {
willSet { if let v = newValue { SVProgressHUD.setInfoImage(v) } }
}

/// 成功メッセージ時の画像(28x28を推奨)
public static var successImage: UIImage? {
willSet { if let v = newValue { SVProgressHUD.setSuccessImage(v) } }
}

/// 失敗メッセージ時の画像(28x28を推奨)
public static var errorImage: UIImage? {
willSet { if let v = newValue { SVProgressHUD.setErrorImage(v) } }
}
}

// =========================================================================
// ローディング表示
// =========================================================================

/// ローディングを表示する
/// - parameters:
///	  - message: メッセージ文言
public class func startLoading(message: String = "Please Wait...")
{
if NBHud.showed { return }
NBHud.showed = true

NBHud.setEnabledInteractionEvents(false)
SVProgressHUD.showWithStatus(message)
}

public class func endLoading(message: String, type: NBHudType, closedHandler: NBHudClosedHandler?)
{

}

public class func endLoading(closedHandler: NBHudClosedHandler?)
{

}


/// ローディングを閉じる
/// - parameters:
///	  - closedHandler: 閉じられた時のコールバックハンドラ
public class func endLoading(closedHandler: NBHudClosedHandler?)
{
NBHud.endLoadingCommon(nil, closedHandler: closedHandler) {
message in
SVProgressHUD.dismiss()
}
}

/// 成功メッセージを表示してローディングを閉じる
/// - parameters:
///	  - message: メッセージ文言
///	  - closedHandler: 閉じられた時のコールバックハンドラ
public class func endLoadingWithSuccess(message: String, closedHandler: NBHudClosedHandler?)
{
NBHud.endLoadingCommon(message, closedHandler: closedHandler) {
message in
SVProgressHUD.showSuccessWithStatus(message)
}
}

/// 情報メッセージを表示してローディングを閉じる
/// - parameters:
///	  - message: メッセージ文言
///	  - closedHandler: 閉じられた時のコールバックハンドラ
public class func endLoadingWithInfo(message: String, closedHandler: NBHudClosedHandler?)
{
NBHud.endLoadingCommon(message, closedHandler: closedHandler) {
message in
SVProgressHUD.showInfoWithStatus(message)
}
}

/// エラーメッセージを表示してローディングを閉じる
/// - parameters:
///	  - message: メッセージ文言
///	  - closedHandler: 閉じられた時のコールバックハンドラ
public class func endLoadingWithError(message: String, closedHandler: NBHudClosedHandler?)
{
NBHud.endLoadingCommon(message, closedHandler: closedHandler) {
message in
SVProgressHUD.showErrorWithStatus(message)
}
}

// =========================================================================
// 単発HUD表示
// =========================================================================

/// 成功メッセージを表示する
/// - parameters:
///	  - message: メッセージ文言
///	  - closedHandler: 閉じられた時のコールバックハンドラ
public class func showSuccess(message: String, closedHandler: NBHudClosedHandler?)
{
NBHud.showCommon(message, closedHandler: closedHandler) {
message in
SVProgressHUD.showSuccessWithStatus(message)
}
}

/// 情報メッセージを表示する
/// - parameters:
///	  - message: メッセージ文言
///	  - closedHandler: 閉じられた時のコールバックハンドラ
public class func showInfo(message: String, closedHandler: NBHudClosedHandler?)
{
NBHud.showCommon(message, closedHandler: closedHandler) {
message in
SVProgressHUD.showInfoWithStatus(message)
}
}

/// エラーメッセージを表示する
/// - parameters:
///	  - message: メッセージ文言
///	  - closedHandler: 閉じられた時のコールバックハンドラ
public class func showError(message: String, closedHandler: NBHudClosedHandler?)
{
NBHud.showCommon(message, closedHandler: closedHandler) {
message in
SVProgressHUD.showErrorWithStatus(message)
}
}

// =========================================================================
// 共通処理
// =========================================================================

/// ローディング表示終了の共通処理
/// - parameters:
///	  - message: メッセージ文言
///	  - closedHandler: 閉じられた時のコールバックハンドラ
///	  - closure: 非共通処理
private class func endLoadingCommon(message: String?, closedHandler: NBHudClosedHandler?, closure: ((String)->Void))
{
if !NBHud.showed { return }

NBHud.observer = NBHud.NBHudObserver(closedHandler: closedHandler)
closure(message ?? "")
}

/// 単発HUD表示の共通処理
/// - parameters:
///	  - message: メッセージ文言
///	  - closedHandler: 閉じられた時のコールバックハンドラ
///	  - closure: 非共通処理
private class func showCommon(message: String?, closedHandler: NBHudClosedHandler?, closure: ((String)->Void))
{
if NBHud.showed { return }
NBHud.showed = true

NBHud.observer = NBHud.NBHudObserver(closedHandler: closedHandler)
NBHud.setEnabledInteractionEvents(false)
closure(message ?? "")
}

// =========================================================================
// プライベートメンバ変数
// =========================================================================

/// 表示中フラグ
private static var showed = false

/// HUD表示を監視するオブジェクト
private static var observer: NBHud.NBHudObserver?

// =========================================================================
// 内部クラス
// =========================================================================

/// HUD表示を監視するクラス
internal class NBHudObserver : NSObject
{
/// HUDが閉じられた時のコールバックハンドラ
private var closedHandler: NBHudClosedHandler?

/// イニシャライザ
/// - parameters:
///	  - handler: HUDが閉じられた時のコールバックハンドラ
init(closedHandler: NBHudClosedHandler?)
{
super.init()
self.closedHandler = closedHandler
self.observeDidDisappearNotification(true)
}

/// HUDが閉じられた時
/// - parameters:
///	  - notify: 通知オブジェクト
internal func didHUDDisappear(notify: NSNotification)
{
NBHud.setEnabledInteractionEvents(true)
NBHud.showed = false

if let closedHandler = self.closedHandler {
closedHandler()
}

NBHud.observer = nil
}

/// デイニシャライザ
deinit
{
self.observeDidDisappearNotification(false)
}

/// HUDが閉じられた時の通知監視を開始または終了する
/// - parameters:
///	  - start: 開始/終了
private func observeDidDisappearNotification(start: Bool)
{
let nc = NSNotificationCenter.defaultCenter()
let name = SVProgressHUDDidDisappearNotification

if start {
nc.addObserver(self, selector: Selector("didHUDDisappear:"), name: name, object: nil)
} else {
nc.removeObserver(self, name: name, object: nil)
}
}
}

// =========================================================================
// 汎用メソッド
// =========================================================================

/// 画面のタップの受付を許可するかどうかを設定する
/// - parameters:
///	  - enabled: falseを渡すと画面の操作を受け付けなくなる<br/>trueで解除
private class func setEnabledInteractionEvents(enabled: Bool)
{
if enabled {
UIApplication.sharedApplication().endIgnoringInteractionEvents()
} else {
UIApplication.sharedApplication().beginIgnoringInteractionEvents()
}
}
}
*/
