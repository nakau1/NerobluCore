// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// アプリケーションデリゲートの規定クラス
public class NBAppDelegate: UIResponder, UIApplicationDelegate {
    
    /// ウィンドウ
    public var window: UIWindow?
    
    /// 起動オプション
    public var launchOptions: [NSObject: AnyObject]?
    
    /// 最初に表示する画面のビューコントローラを返却する
    /// - returns: 最初に表示する画面のビューコントローラ
    public func defaultViewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.whiteColor()
        return vc
    }
    
    /// 非ビジュアルな(UIなどに関係しない)初期処理を行う
    ///
    /// 設定値やDB初期処理、その他UIに関係しない処理を行ってください
    public func initialize() {} // NOP.
    
    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.launchOptions = launchOptions
        self.initialize()
        
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = self.defaultViewController()
        window.makeKeyAndVisible()
        
        self.window = window
        return true
    }
}