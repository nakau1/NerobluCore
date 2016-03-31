// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK: - NBDialogPresentationOption -

/// ダイアログ表示のオプション設定
public struct NBDialogPresentationOption {
    /// イニシャライザ
    /// - parameter cancellable: 背景がタップされた時に閉じるかどうか
    public init(cancellable: Bool = false) {
        self.cancellable = cancellable
    }
    /// 背景がタップされた時に閉じるかどうか
    public var cancellable = false
    /// 背景にブラーエフェクトをかけるかどうか
    public var blur = false
    /// ブラーエフェクトのスタイル
    public var blurEffectStyle: UIBlurEffectStyle = .Light
    /// ビューを自動的に中央に配置するかどうか
    public var automaticCenter = true
    /// 背景色
    public var backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
    /// 表示時のアニメーション間隔
    public var presentationDuration: NSTimeInterval = 0.3
    /// 表示時のアニメーションオプション
    public var presentationAnimationOptions: UIViewAnimationOptions = [.TransitionCrossDissolve, .CurveEaseInOut]
    /// 表示終了時のアニメーション間隔
    public var dismissingDuration: NSTimeInterval = 0.3
    /// 表示終了時のアニメーションオプション
    public var dismissingAnimationOptions: UIViewAnimationOptions = [.TransitionCrossDissolve, .CurveEaseInOut]
}

// MARK: - UIView+Dialog -

/// ダイアログ表示用UIView拡張
public extension UIView {
    
    /// ダイアログとして表示する
    /// - parameter option: ダイアログ表示のオプション設定
    /// - parameter completionHandler: 表示完了時の処理
    public func presentAsDialog(option: NBDialogPresentationOption? = nil, completionHandler: CompletionHandler? = nil) {
        if UIView.dialogBackground != nil { return }
        
        let opt = option ?? NBDialogPresentationOption()
        
        let mask = opt.blur ? UIVisualEffectView(effect: UIBlurEffect(style: opt.blurEffectStyle)) : UIView()
        mask.frame = UIScreen.mainScreen().bounds
        mask.backgroundColor = opt.backgroundColor
        mask.alpha = 0.0
        
        if opt.automaticCenter {
            let x = (crW(mask.frame) - crW(self.frame)) / 2
            let y = (crH(mask.frame) - crH(self.frame)) / 2
            self.frame.origin = cp(x, y)
        }
        
        if opt.cancellable {
            let gesture = UITapGestureRecognizer(target: self, action: Selector("didTapDialogBackground"))
            let handler = UIView.DialogBackgroundTapHandler(view: self)
            gesture.delegate = handler
            UIView.dialogBackgroundTapHandler = handler
            mask.addGestureRecognizer(gesture)
        }
        
        mask.addSubview(self)
        UIView.dialogBackground = mask
        
        let windows = UIApplication.sharedApplication().windows.reverse()
        for window in windows {
            let isMainScreen  =  window.screen == UIScreen.mainScreen()
            let isVisible     = !window.hidden && window.alpha > 0
            let isNormalLevel =  window.windowLevel == UIWindowLevelNormal
            
            if isMainScreen && isVisible && isNormalLevel {
                window.addSubview(mask)
            }
        }
        
        UIView.transitionWithView(mask, duration: opt.presentationDuration, options: opt.presentationAnimationOptions,
            animations: {
                mask.alpha = 1.0
            },
            completion: { _ in
                completionHandler?()
            }
        )
    }
    
    /// 表示しているダイアログの表示を終了する
    /// - parameter option: ダイアログ表示のオプション設定
    /// - parameter completionHandler: 表示終了完了時の処理
    public class func dismissPresentedDialog(option: NBDialogPresentationOption? = nil, completionHandler: CompletionHandler? = nil) {
        guard let mask = self.dialogBackground else {
            return
        }
        
        let opt = option ?? NBDialogPresentationOption()
        
        UIView.transitionWithView(mask, duration: opt.dismissingDuration, options: opt.dismissingAnimationOptions,
            animations: {
                mask.alpha = 0.0
            },
            completion: { _ in
                mask.subviews.forEach { $0.removeFromSuperview() }
                UIView.dialogBackground = nil
                UIView.dialogBackgroundTapHandler = nil
                completionHandler?()
            }
        )
    }
    
    @objc private func didTapDialogBackground() {
        UIView.dismissPresentedDialog()
    }
    
    private static var dialogBackground: UIView? = nil
    
    private static var dialogBackgroundTapHandler: DialogBackgroundTapHandler? = nil
    
    private class DialogBackgroundTapHandler : NSObject, UIGestureRecognizerDelegate {
        
        private var view: UIView
        
        init(view: UIView) {
            self.view = view
        }
        
        @objc func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
            if let touchedView = touch.view {
                if touchedView == self.view {
                    return false
                }
                for v in self.view.subviews {
                    if touchedView.isDescendantOfView(v) {
                        return false
                    }
                }
            }
            return true
        }
    }
}
