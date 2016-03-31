// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// アプリケーション
public class App {
    
    /// アプリケーションのシングルトンオブジェクト
    public static var Shared: UIApplication { return UIApplication.sharedApplication() }
    
    /// ルートビューコントローラ
    public static var Root: UIViewController? {
        get    { return App.Shared.delegate?.window??.rootViewController }
        set(v) { App.Shared.delegate?.window??.rootViewController = v }
    }
}
