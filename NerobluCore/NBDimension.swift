// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK - App拡張 -

public extension App {
    
    /// アプリケーションサイズ定義
    public class Dimen {
        /// 画面サイズ
        public struct Screen {
            /// 画面の幅
            public static var Size: CGSize { return UIScreen.mainScreen().bounds.size }
            /// 画面の幅
            public static var Width: CGFloat { return App.Dimen.Screen.Size.width }
            /// 画面の高さ
            public static var Height: CGFloat { return App.Dimen.Screen.Size.height }
        }
        
        /// ステータスバーの高さ
        public static let StatusBarsHeight: CGFloat = 20.0
        
        /// ヘッダの高さ
        public static let HeaderHeight: CGFloat = 44.0
        
        /// ステータスバーとヘッダを合わせた高さ
        public static let HeaderTotalHeight: CGFloat = App.Dimen.StatusBarsHeight + App.Dimen.HeaderHeight
        
        /// ページコントロールの高さ
        public static let PageControlHeight: CGFloat = 37.0
    }
}
