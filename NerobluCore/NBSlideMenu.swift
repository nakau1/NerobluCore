// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

///  NBSlideMenuに関する通知の種別
public enum NBSlideMenuNotification: String {
    case LeftMenuGestureStart
    case LeftMenuGestureUpdate
    case LeftMenuGestureEnd
    case LeftMenuOpen
    case LeftMenuClose
    case RightMenuGestureStart
    case RightMenuGestureUpdate
    case RightMenuGestureEnd
    case RightMenuOpen
    case RightMenuClose
}

// MARK: - NBSlideMenuOptions -

/// NBSlideMenuオプション
public struct NBSlideMenuOptions {
    
    /// メニュー表示時にステータスバーを隠すかどうか
    public var hideStatusBar = true
    /// アニメーションの間隔
    public var animationDuration: NSTimeInterval = 0.4
    
    public struct Content {
        /// メニュー表示中のメインコンテナのスケール(0.0-1.0)
        public var scale: CGFloat = 0.96
        /// メニュー表示中のメインコンテナの不透明度
        public var opacity: CGFloat = 0.5
        /// メニュー表示時のメインコンテナの色(色の濃さは不透明度に依存する)
        public var opacityColor = UIColor.blackColor()
    }
    // メインコンテナの設定
    public var content = Content()
    
    public struct Left {
        /// 左メニューの幅
        public var width: CGFloat = 270
        /// 左メニューをパンによって引っ張りだすことができるかどうか
        public var bezel = true
        /// 左メニューを引っ張り出すことのできる画面左領域の幅
        public var bezelableWidth: CGFloat = 16
        /// 左メニューを引っ張り出すために必要な幅の量
        public var bezelingAmountWidth: CGFloat = 44
    }
    /// 左メニューの設定
    public var left = Left()
    
    public struct Right {
        /// 右メニューの幅
        public var width: CGFloat = 270
        /// 右メニューをパンによって引っ張りだすことができるかどうか
        public var bezel = true
        /// 右メニューを引っ張り出すことのできる画面左領域の幅
        public var bezelableWidth: CGFloat = 16
        /// 右メニューを引っ張り出すために必要な幅の量
        public var bezelingAmountWidth: CGFloat = 44
    }
    /// 右メニューの設定
    public var right = Right()
    
    public struct Shadow {
        /// 影の不透明度(0.0-1.0)
        public var opacity: Float = 0
        /// 影(blur)の半径
        public var radius: CGFloat = 0
        /// 影のオフセット
        public var offset = CGSizeMake(0, 0)
        /// 影の色
        public var color = UIColor.blackColor()
    }
    /// 影の設定
    public var shadow = Shadow()
    
    public init() {}
}

// MARK: - NBSlideMenu -

/// クラスについての処理を行うクラス
public class NBSlideMenu: UIViewController, UIGestureRecognizerDelegate {
    
    private var options = NBSlideMenuOptions()
    
    private var mainContainerView  = UIView()
    private var leftContainerView  = UIView()
    private var rightContainerView = UIView()
    
    private var opacityView = UIView()
    
    private var mainViewController:  UIViewController?
    private var leftViewController:  UIViewController?
    private var rightViewController: UIViewController?
    
    private var leftPanGesture:  UIPanGestureRecognizer?
    private var rightPanGesture: UIPanGestureRecognizer?
    
    private var leftTapGesture:  UITapGestureRecognizer?
    private var rightTapGesture: UITapGestureRecognizer?
    
    private struct PanState {
        var startFrame = CGRectZero
        var startPoint = CGPointZero
        var startOpen  = false
        var startClose = false
    }
    
    private var leftPanState  = PanState()
    private var rightPanState = PanState()
    
    private struct PanInfo {
        var open     : Bool
        var bounce   : Bool
        var velocity : CGFloat
    }
    
    // MARK: イニシャライザ
    
    /// イニシャライザ
    /// - parameter mainViewController: メインとなるビューコントローラ
    /// - parameter leftViewController: 左側メニューとなるビューコントローラ
    /// - parameter rightViewController: 右側メニューとなるビューコントローラ
    /// - parameter options: オプション
    public convenience init(mainViewController: UIViewController, leftViewController: UIViewController? = nil, rightViewController: UIViewController? = nil, options: NBSlideMenuOptions = NBSlideMenuOptions()) {
        self.init()
        self.mainViewController  = mainViewController
        self.leftViewController  = leftViewController
        self.rightViewController = rightViewController
        self.options             = options
        self.initializeViews()
    }
    
    // MARK: パブリックメソッド
    
    /// NBSlideMenuに関する通知の監視を開始する
    /// - parameter observer: 監視をするオブジェクト
    /// - parameter selector: 通知時に実行するセレクタ
    /// - parameter notification: 監視をする通知の種別
    public func addObserver(observer: AnyObject, selector: Selector, notification: NBSlideMenuNotification) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(observer, selector: selector, name: NBSlideMenu.notificationName(notification), object: nil)
    }
    
    /// NBSlideMenuに関する通知の監視を終了する
    /// - parameter observer: 監視をするオブジェクト
    /// - parameter notification: 監視をする通知の種別
    public func removeObserver(observer: AnyObject, notification: NBSlideMenuNotification) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(observer, name: NBSlideMenu.notificationName(notification), object: nil)
    }
    
    /// メニュー側のビューコントローラにスクロールビュー(テーブルビュー等)がある場合に
    /// scrollViewWillBeginDraggingのタイミングで適切な処理を行う
    public func regulateOnScrollViewWillBeginDragging() {
        self.removeLeftGestureRecognizers()
        self.removeRightGestureRecognizers()
    }
    
    /// メニュー側のビューコントローラにスクロールビュー(テーブルビュー等)がある場合に
    /// scrollViewDidEndDeceleratingのタイミングで適切な処理を行う
    public func regulateOnScrollViewDidEndDecelerating() {
        self.addLeftGestureRecognizers()
        self.addRightGestureRecognizers()
    }
    
    /// メニュー側のビューコントローラにスクロールビュー(テーブルビュー等)がある場合に
    /// scrollViewDidEndDraggingのタイミングで適切な処理を行う
    /// - parameter decelerate: scrollViewDidEndDraggingの引数decelerateをそのまま渡す
    public func regulateOnScrollViewDidEndDragging(decelerate: Bool) {
        if !decelerate {
            self.addLeftGestureRecognizers()
            self.addRightGestureRecognizers()
        }
    }
    
    /// 左メニューのオープン/クローズを切り替える
    public func toggleLeft() {
        if self.isLeftOpen {
            self.closeLeft()
            self.setCloseWindowLevel()
        } else {
            self.openLeft()
        }
    }
    
    /// 右メニューのオープン/クローズを切り替える
    public func toggleRight() {
        if self.isRightOpen {
            self.closeRight()
            self.setCloseWindowLevel()
        } else {
            self.openRight()
        }
    }
    
    /// 左メニューをオープン
    public func openLeft() {
        self.setOpenWindowLevel()
        self.leftViewController?.beginAppearanceTransition(self.isLeftClose, animated: true)
        self.openLeftWithVelocity(0)
    }
    
    /// 右メニューをオープン
    public func openRight() {
        self.setOpenWindowLevel()
        self.rightViewController?.beginAppearanceTransition(self.isRightClose, animated: true)
        self.openRightWithVelocity(0)
    }
    
    /// 左メニューをクローズ
    public func closeLeft(animated: Bool = true) {
        if !animated {
            self.closeLeftNonAnimation()
            return
        }
        self.leftViewController?.beginAppearanceTransition(self.isLeftClose, animated: true)
        self.closeLeftWithVelocity(0)
        self.setCloseWindowLevel()
    }
    
    /// 右メニューをクローズ
    public func closeRight(animated: Bool = true) {
        if !animated {
            self.closeRightNonAnimation()
            return
        }
        self.rightViewController?.beginAppearanceTransition(self.isRightClose, animated: true)
        self.closeRightWithVelocity(0)
        self.setCloseWindowLevel()
    }
    
    /// メインのビューコントローラを差し替える
    /// - parameter viewController: ビューコントローラ
    /// - parameter close: 差し替え時に表示中のメニューを閉じるかどうか
    public func changeMainViewController(viewController: UIViewController, close: Bool) {
        self.teardownViewController(self.mainViewController)
        self.mainViewController = viewController
        self.setupViewController(viewController, containerView: self.mainContainerView)
        if close {
            self.closeLeft()
            self.closeRight()
        }
    }
    
    /// 左側のビューコントローラを差し替える
    /// - parameter viewController: ビューコントローラ
    /// - parameter closeLeft: 差し替え時に表示中の左メニューを閉じるかどうか
    public func changeLeftViewController(viewController: UIViewController, closeLeft: Bool) {
        self.teardownViewController(self.leftViewController)
        self.leftViewController = viewController
        self.setupViewController(viewController, containerView: self.leftContainerView)
        if closeLeft {
            self.closeLeft()
        }
    }
    
    /// 右側のビューコントローラを差し替える
    /// - parameter viewController: ビューコントローラ
    /// - parameter closeRight: 差し替え時に表示中の右メニューを閉じるかどうか
    public func changeRightViewController(viewController: UIViewController, closeRight: Bool) {
        self.teardownViewController(self.rightViewController)
        self.rightViewController = viewController
        self.setupViewController(viewController, containerView: self.rightContainerView)
        if closeRight {
            self.closeRight()
        }
    }
    
    /// 左側の幅を変更する
    /// 
    /// 直接frameが書き変わるので左側メニューが隠れている時に変更するほうがよい
    /// - parameter width: 変更する幅
    public func changeLeftViewWidth(width: CGFloat) {
        self.options.left.width = width
        
        var frame = self.view.bounds
        frame.size.width = width
        frame.origin.x = self.leftMinimumOrigin
        
        self.leftContainerView.frame = frame
    }
    
    /// 右側の幅を変更する
    ///
    /// 直接frameが書き変わるので左側メニューが隠れている時に変更するほうがよい
    /// - parameter width: 変更する幅
    public func changeRightViewWidth(width: CGFloat) {
        self.options.right.bezelableWidth = width // ?
        
        var frame = self.view.bounds
        frame.size.width = width
        frame.origin.x = self.rightMinimumOrigin
        
        self.rightContainerView.frame = frame
    }
    
    ///
    public func isTargetViewController() -> Bool { return true }
    
    // MARK: 初期化処理
    
    /// 各ビューの初期化
    private func initializeViews() {
        var viewIndex = 0
        self.initializeMainContainerView(viewIndex++)
        self.initializeOpacityView(viewIndex++)
        self.initializeLeftContainerView(viewIndex++)
        self.initializeRightContainerView(viewIndex++)
        
        self.addLeftGestureRecognizers()
        self.addRightGestureRecognizers()
    }
    
    /// メインコンテナビューの初期化
    /// - parameter viewIndex: ビュー階層のインデックス
    private func initializeMainContainerView(viewIndex: Int) {
        let v = UIView(frame: self.view.bounds)
        v.backgroundColor = UIColor.clearColor()
        v.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.view.insertSubview(v, atIndex: viewIndex)
        self.mainContainerView = v
    }
    
    /// 不透過ビューの初期化
    /// - parameter viewIndex: ビュー階層のインデックス
    private func initializeOpacityView(viewIndex: Int) {
        let v = UIView(frame: self.view.bounds)
        v.backgroundColor = self.options.content.opacityColor
        v.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        v.layer.opacity = 0
        self.view.insertSubview(v, atIndex: viewIndex)
        self.opacityView = v
    }
    
    /// 左側コンテナビューの初期化
    /// - parameter viewIndex: ビュー階層のインデックス
    private func initializeLeftContainerView(viewIndex: Int) {
        var frame = self.view.bounds
        frame.size.width = self.options.left.width
        frame.origin.x   = self.leftMinimumOrigin
        
        let v = UIView(frame: frame)
        v.backgroundColor = UIColor.clearColor()
        v.autoresizingMask = [.FlexibleHeight]
        self.view.insertSubview(v, atIndex: viewIndex)
        self.leftContainerView = v
    }
    
    /// 右側コンテナビューの初期化
    /// - parameter viewIndex: ビュー階層のインデックス
    private func initializeRightContainerView(viewIndex: Int) {
        var frame = self.view.bounds
        frame.size.width = self.options.right.width
        frame.origin.x   = self.rightMinimumOrigin
        
        let v = UIView(frame: frame)
        v.backgroundColor = UIColor.clearColor()
        v.autoresizingMask = [.FlexibleHeight]
        self.view.insertSubview(v, atIndex: viewIndex)
        self.rightContainerView = v
    }
    
    // MARK: ライフサイクル
    
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        self.mainContainerView.transform = CGAffineTransformMakeScale(1, 1)
        self.leftContainerView .hidden = true
        self.rightContainerView.hidden = true
        
        coordinator.animateAlongsideTransition(nil) { _ in
            self.closeLeftNonAnimation()
            self.closeRightNonAnimation()
            self.leftContainerView .hidden = false
            self.rightContainerView.hidden = false
            
            if self.existsLeftGestureRecognizers {
                self.removeLeftGestureRecognizers()
                self.addLeftGestureRecognizers()
            }
            if self.existsRightGestureRecognizers {
                self.removeRightGestureRecognizers()
                self.addRightGestureRecognizers()
            }
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if let vc = self.mainViewController {
            return vc.supportedInterfaceOrientations()
        }
        return .All
    }
    
    public override func viewWillLayoutSubviews() {
        self.setupViewController(self.mainViewController,  containerView: self.mainContainerView)
        self.setupViewController(self.leftViewController,  containerView: self.leftContainerView)
        self.setupViewController(self.rightViewController, containerView: self.rightContainerView)
    }

    // MARK: ジャスチャレコグナイザの追加
    
    /// 左側用のジェスチャレコグナイザを追加する
    private func addLeftGestureRecognizers() {
        if self.leftViewController == nil { return }
        
        if self.leftPanGesture == nil {
            let ges = UIPanGestureRecognizer(target: self, action: Selector("didRecognizeLeftPanGesture:"))
            ges.delegate = self
            self.view.addGestureRecognizer(ges)
            self.leftPanGesture = ges
        }
        if self.leftTapGesture == nil {
            let ges = UITapGestureRecognizer(target: self, action: Selector("didRecognizeLeftTapGesture:"))
            ges.delegate = self
            self.view.addGestureRecognizer(ges)
            self.leftTapGesture = ges
        }
    }
    
    /// 右側用のジェスチャレコグナイザを追加する
    private func addRightGestureRecognizers() {
        if self.rightViewController == nil { return }
        
        if self.rightPanGesture == nil {
            let ges = UIPanGestureRecognizer(target: self, action: Selector("didRecognizeRightPanGesture:"))
            ges.delegate = self
            self.view.addGestureRecognizer(ges)
            self.rightPanGesture = ges
        }
        if self.rightTapGesture == nil {
            let ges = UITapGestureRecognizer(target: self, action: Selector("didRecognizeRightTapGesture:"))
            ges.delegate = self
            self.view.addGestureRecognizer(ges)
            self.rightTapGesture = ges
        }
    }
    
    // MARK: ジャスチャレコグナイザの削除
    
    /// 左側用のジェスチャレコグナイザを削除する
    private func removeLeftGestureRecognizers() {
        if let ges = self.leftPanGesture {
            self.view.removeGestureRecognizer(ges)
            self.leftPanGesture = nil
        }
        if let ges = self.leftTapGesture {
            self.view.removeGestureRecognizer(ges)
            self.leftTapGesture = nil
        }
    }
    
    /// 右側用のジェスチャレコグナイザを削除する
    private func removeRightGestureRecognizers() {
        if let ges = self.rightPanGesture {
            self.view.removeGestureRecognizer(ges)
            self.rightPanGesture = nil
        }
        if let ges = self.rightTapGesture {
            self.view.removeGestureRecognizer(ges)
            self.rightTapGesture = nil
        }
    }
    
    // MARK: ジャスチャレコグナイザの存在確認
    
    /// 左側用のジェスチャレコグナイザの存在確認
    private var existsLeftGestureRecognizers: Bool {
        return self.leftPanGesture != nil && self.leftTapGesture != nil
    }
    
    /// 右側用のジェスチャレコグナイザの存在確認
    private var existsRightGestureRecognizers: Bool {
        return self.rightPanGesture != nil && self.rightTapGesture != nil
    }
    
    // MARK: 左側パンジェスチャレコグナイザのハンドラ
    
    /// 左側のパンジェスチャを感知した時
    /// - parameter ges: パンジェスチャレコグナイザ
    @objc private func didRecognizeLeftPanGesture(ges: UIPanGestureRecognizer) {
        if !self.isTargetViewController() { return }
        if self.isRightOpen { return }
        
        switch ges.state {
        case .Began:     self.leftPanBegan(ges)
        case .Changed:   self.leftPanChanged(ges)
        case .Ended:     self.leftPanEnded(ges)
        case .Cancelled: self.leftPanCancelled(ges)
        default: break
        }
    }
    
    /// 左側のパンジェスチャが開始された時
    /// - parameter ges: パンジェスチャレコグナイザ
    private func leftPanBegan(ges: UIPanGestureRecognizer) {
        self.leftPanState.startFrame = self.leftContainerView.frame
        self.leftPanState.startPoint = ges.locationInView(self.view)
        self.leftPanState.startOpen  = self.isLeftOpen
        self.leftPanState.startClose = self.isLeftClose
        
        self.leftViewController?.beginAppearanceTransition(self.isLeftClose, animated: true)
        self.addShadowToContainerView(self.leftContainerView)
        self.setOpenWindowLevel()
        self.notify(.LeftMenuGestureStart)
    }
    
    /// 左側のパンジェスチャが更新された時
    /// - parameter ges: パンジェスチャレコグナイザ
    private func leftPanChanged(ges: UIPanGestureRecognizer) {
        self.notify(.LeftMenuGestureUpdate)
        let translation = ges.translationInView(ges.view!)
        self.leftContainerView.frame = self.applyLeftTranslation(translation, toFrame: self.leftPanState.startFrame)
        self.applyLeftOpacity()
        self.applyLeftContentViewScale()
    }
    
    /// 左側のパンジェスチャが終了した時
    /// - parameter ges: パンジェスチャレコグナイザ
    private func leftPanEnded(ges: UIPanGestureRecognizer) {
        self.notify(.LeftMenuGestureEnd)
        let velocity = ges.velocityInView(ges.view)
        let panInfo = self.panInfoLeftForVelocity(velocity)
        
        if panInfo.open {
            self.notify(.LeftMenuOpen)
            if self.leftPanState.startOpen {
                self.leftViewController?.beginAppearanceTransition(true, animated: true)
            }
            self.openLeftWithVelocity(panInfo.velocity)
        } else {
            self.notify(.LeftMenuClose)
            if self.leftPanState.startClose {
                self.leftViewController?.beginAppearanceTransition(false, animated: true)
            }
            self.closeLeftWithVelocity(panInfo.velocity)
            self.setCloseWindowLevel()
        }
    }
    
    /// 左側のパンジェスチャがキャンセルされた時
    /// - parameter ges: パンジェスチャレコグナイザ
    private func leftPanCancelled(ges: UIPanGestureRecognizer) {
        self.notify(.LeftMenuGestureEnd)
    }
    
    // MARK: 右側パンジェスチャレコグナイザのハンドラ
    
    /// 右側のパンジェスチャを感知した時
    /// - parameter ges: パンジェスチャレコグナイザ
    @objc private func didRecognizeRightPanGesture(ges: UIPanGestureRecognizer) {
        if !self.isTargetViewController() { return }
        if self.isLeftOpen { return }
        
        switch ges.state {
        case .Began:     self.rightPanBegan(ges)
        case .Changed:   self.rightPanChanged(ges)
        case .Ended:     self.rightPanEnded(ges)
        case .Cancelled: self.rightPanEnded(ges)
        default: break
        }
    }
    
    /// 右側のパンジェスチャが開始された時
    /// - parameter ges: パンジェスチャレコグナイザ
    private func rightPanBegan(ges: UIPanGestureRecognizer) {
        self.rightPanState.startFrame = self.rightContainerView.frame
        self.rightPanState.startPoint = ges.locationInView(self.view)
        self.rightPanState.startOpen  = self.isRightOpen
        self.rightPanState.startClose = self.isRightClose
        
        self.rightViewController?.beginAppearanceTransition(self.isRightClose, animated: true)
        self.addShadowToContainerView(self.rightContainerView)
        self.setOpenWindowLevel()
        
        self.notify(.RightMenuGestureStart)
    }
    
    /// 右側のパンジェスチャが更新された時
    /// - parameter ges: パンジェスチャレコグナイザ
    private func rightPanChanged(ges: UIPanGestureRecognizer) {
        self.notify(.RightMenuGestureUpdate)
        let translation = ges.translationInView(ges.view!)
        self.rightContainerView.frame = self.applyRightTranslation(translation, toFrame: self.rightPanState.startFrame)
        self.applyRightOpacity()
        self.applyRightContentViewScale()
    }
    
    /// 右側のパンジェスチャが終了した時
    /// - parameter ges: パンジェスチャレコグナイザ
    private func rightPanEnded(ges: UIPanGestureRecognizer) {
        self.notify(.RightMenuGestureEnd)
        let velocity = ges.velocityInView(ges.view)
        let panInfo = self.panInfoRightForVelocity(velocity)
        
        if panInfo.open {
            self.notify(.RightMenuOpen)
            if self.rightPanState.startOpen {
                self.rightViewController?.beginAppearanceTransition(true, animated: true)
            }
            self.openRightWithVelocity(panInfo.velocity)
        } else {
            self.notify(.RightMenuClose)
            if self.rightPanState.startClose {
                self.rightViewController?.beginAppearanceTransition(false, animated: true)
            }
            self.closeRightWithVelocity(panInfo.velocity)
            self.setCloseWindowLevel()
        }
    }
    
    /// 右側のパンジェスチャがキャンセルされた時
    /// - parameter ges: パンジェスチャレコグナイザ
    private func rightPanCancelled(ges: UIPanGestureRecognizer) {
        self.notify(.RightMenuGestureEnd)
    }
    
    // MARK: タップジェスチャレコグナイザのハンドラ
    
    /// 左側のタップジェスチャを感知した時
    /// - parameter ges: タップジェスチャレコグナイザ
    @objc private func didRecognizeLeftTapGesture(ges: UITapGestureRecognizer) {
        self.toggleLeft()
    }

    /// 右側のタップジェスチャを感知した時
    /// - parameter ges: タップジェスチャレコグナイザ
    @objc private func didRecognizeRightTapGesture(ges: UITapGestureRecognizer) {
        self.toggleRight()
    }
    
    // MARK: パンの強さ(velocity)を考慮したオープン/クローズ処理
    
    /// パンの強さ(velocity)を考慮した左側のオープン処理
    /// - parameter velocity: パンの強さ
    private func openLeftWithVelocity(velocity: CGFloat) {
        var frame = self.leftContainerView.frame
        frame.origin.x = 0
        
        var duration = self.options.animationDuration
        if velocity != 0 {
            duration = NSTimeInterval(fabs(self.leftContainerX) / velocity)
            duration = NSTimeInterval(fmax(0.1, fmin(1.0, duration)))
        }
        
        self.addShadowToContainerView(self.leftContainerView)
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut,
            animations: { [weak self]() -> Void in
                if let strongSelf = self {
                    let scale = strongSelf.options.content.scale
                    strongSelf.leftContainerView.frame     = frame
                    strongSelf.opacityView.layer.opacity   = Float(strongSelf.options.content.opacity)
                    strongSelf.mainContainerView.transform = CGAffineTransformMakeScale(scale, scale)
                }
            },
            completion: { [weak self](Bool) -> Void in
                if let strongSelf = self {
                    strongSelf.disableContentInteraction()
                    strongSelf.leftViewController?.endAppearanceTransition()
                }
            }
        )
    }
    
    /// パンの強さ(velocity)を考慮した右側のオープン処理
    /// - parameter velocity: パンの強さ
    private func openRightWithVelocity(velocity: CGFloat) {
        var frame = self.rightContainerView.frame
        frame.origin.x = self.totalWidth - self.rightContainerWidth
        
        var duration = self.options.animationDuration
        if velocity != 0 {
            duration = NSTimeInterval(fabs(self.rightContainerX - self.totalWidth) / velocity)
            duration = NSTimeInterval(fmax(0.1, fmin(1.0, duration)))
        }
        
        self.addShadowToContainerView(self.rightContainerView)
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut,
            animations: { [weak self]() -> Void in
                if let strongSelf = self {
                    let scale = strongSelf.options.content.scale
                    strongSelf.rightContainerView.frame    = frame
                    strongSelf.opacityView.layer.opacity   = Float(strongSelf.options.content.opacity)
                    strongSelf.mainContainerView.transform = CGAffineTransformMakeScale(scale, scale)
                }
            },
            completion: { [weak self](Bool) -> Void in
                if let strongSelf = self {
                    strongSelf.disableContentInteraction()
                    strongSelf.rightViewController?.endAppearanceTransition()
                }
            }
        )
    }
    
    /// パンの強さ(velocity)を考慮した左側のクローズ処理
    /// - parameter velocity: パンの強さ
    private func closeLeftWithVelocity(velocity: CGFloat) {
        var frame = self.leftContainerView.frame
        frame.origin.x = self.leftMinimumOrigin
        
        var duration = self.options.animationDuration
        if velocity != 0 {
            duration = NSTimeInterval(fabs(self.leftContainerX - self.leftMinimumOrigin) / velocity)
            duration = NSTimeInterval(fmax(0.1, fmin(1.0, duration)))
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut,
            animations: { [weak self]() -> Void in
                if let strongSelf = self {
                    strongSelf.leftContainerView.frame     = frame
                    strongSelf.opacityView.layer.opacity   = 0
                    strongSelf.mainContainerView.transform = CGAffineTransformMakeScale(1, 1)
                }
            },
            completion: { [weak self](Bool) -> Void in
                if let strongSelf = self {
                    strongSelf.removeShadowFromContainerView(strongSelf.leftContainerView)
                    strongSelf.enableContentInteraction()
                    strongSelf.leftViewController?.endAppearanceTransition()
                }
            }
        )
    }
    
    /// パンの強さ(velocity)を考慮した右側のクローズ処理
    /// - parameter velocity: パンの強さ
    private func closeRightWithVelocity(velocity: CGFloat) {
        var frame = self.rightContainerView.frame
        frame.origin.x = self.totalWidth
        
        var duration = self.options.animationDuration
        if velocity != 0 {
            duration = NSTimeInterval(fabs(self.rightContainerX - self.totalWidth) / velocity)
            duration = NSTimeInterval(fmax(0.1, fmin(1.0, duration)))
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut,
            animations: { [weak self]() -> Void in
                if let strongSelf = self {
                    strongSelf.rightContainerView.frame    = frame
                    strongSelf.opacityView.layer.opacity   = 0
                    strongSelf.mainContainerView.transform = CGAffineTransformMakeScale(1, 1)
                }
            },
            completion: { [weak self](Bool) -> Void in
                if let strongSelf = self {
                    strongSelf.removeShadowFromContainerView(strongSelf.rightContainerView)
                    strongSelf.enableContentInteraction()
                    strongSelf.rightViewController?.endAppearanceTransition()
                }
            }
        )
    }
    
    // MARK: オープン/クローズ状態の取得
    
    /// 左側が開いているかどうか
    private var isLeftOpen: Bool {
        return self.leftContainerX == 0
    }
    
    /// 左側が閉じているどうか
    private var isLeftClose: Bool {
        return self.leftContainerX <= self.leftMinimumOrigin
    }
    
    /// 右側が開いているかどうか
    private var isRightOpen: Bool {
        return self.rightContainerX == (self.totalWidth - self.rightContainerWidth)
    }
    
    /// 右側が閉じているどうか
    private var isRightClose: Bool {
        return self.rightContainerX >= self.totalWidth
    }
    
    // MARK: 各座標値の取得
    
    /// 左側コンテナビューの現在の幅
    private var leftContainerWidth: CGFloat { return CGRectGetWidth(self.leftContainerView.frame) }
    
    /// 右側コンテナビューの現在の幅
    private var rightContainerWidth: CGFloat { return CGRectGetWidth(self.rightContainerView.frame) }
    
    /// 左側コンテナビューの現在のX座標
    private var leftContainerX: CGFloat { return CGRectGetMinX(self.leftContainerView.frame) }
    
    /// 右側コンテナビューの現在のX座標
    private var rightContainerX: CGFloat { return CGRectGetMinX(self.rightContainerView.frame) }
    
    /// 左側メニューが隠れた際のX座標
    private var leftMinimumOrigin: CGFloat { return -self.options.left.width }
    
    /// 右側メニューが隠れた際のX座標
    private var rightMinimumOrigin: CGFloat { return self.totalWidth }
    
    /// 全体幅
    private var totalWidth: CGFloat { return CGRectGetWidth(self.view.bounds) }
    
    
    // MARK: パン情報の取得
    
    /// 左パン情報を取得する
    /// - parameter velocity: パンの強さ
    /// - returns: パン情報
    private func panInfoLeftForVelocity(velocity: CGPoint) -> PanInfo {
        let threshold: CGFloat = 1000
        let pnr = floor(self.leftMinimumOrigin) + self.options.left.bezelingAmountWidth
        var ret = PanInfo(open: false, bounce: false, velocity: 0)
        
        ret.open = self.leftContainerX > pnr
        if velocity.x >= threshold {
            ret.open = true
            ret.velocity = velocity.x
        } else if velocity.x <= -1 * threshold {
            ret.open = false
            ret.velocity = velocity.x
        }
        
        return ret
    }

    /// 右パン情報を取得する
    /// - parameter velocity: パンの強さ
    /// - returns: パン情報
    private func panInfoRightForVelocity(velocity: CGPoint) -> PanInfo {
        let threshold: CGFloat = -1000
        let pnr = floor(self.totalWidth) - self.options.right.bezelingAmountWidth
        var ret = PanInfo(open: false, bounce: false, velocity: 0)
        
        ret.open = self.rightContainerX < pnr
        if velocity.x <= threshold {
            ret.open = true
            ret.velocity = velocity.x
        } else if velocity.x >= -1 * threshold {
            ret.open = false
            ret.velocity = velocity.x
        }
        
        return ret
    }
    
    // MARK: トランスレーション適用
    
    /// 渡した矩形座標に左用のトランスレーションを適用する
    /// - parameter translation: トランスレーション
    /// - parameter toFrame: 適用する句形座標(CGRect)
    /// - returns: 適用した句形座標(CGRect)
    private func applyLeftTranslation(translation: CGPoint, toFrame:CGRect) -> CGRect {
        var x = CGRectGetMinX(toFrame)
        x += translation.x
        
        let min = self.leftMinimumOrigin
        let max = 0.f
        
        var frame = toFrame
        if x < min {
            x = min
        } else if x > max {
            x = max
        }
        frame.origin.x = x
        return frame
    }
    
    /// 渡した矩形座標に右用のトランスレーションを適用する
    /// - parameter translation: トランスレーション
    /// - parameter toFrame: 適用する句形座標(CGRect)
    /// - returns: 適用した句形座標(CGRect)
    private func applyRightTranslation(translation: CGPoint, toFrame:CGRect) -> CGRect {
        var x = CGRectGetMinX(toFrame)
        x += translation.x
        
        let min = self.rightMinimumOrigin
        let max = self.rightMinimumOrigin - self.rightContainerWidth
        
        var frame = toFrame
        if x > min {
            x = min
        } else if x < max {
            x = max
        }
        frame.origin.x = x
        return frame
    }
    
    // MARK: 幅比率の計算
    
    /// 左コンテナ幅全体に対する現在の左メニューの位置の比率
    private var openedLeftRatio: CGFloat {
        let pos = self.leftContainerX - self.leftMinimumOrigin
        return pos / self.leftContainerWidth
    }
    
    /// 右コンテナ幅全体に対する現在の右メニューの位置の比率
    private var openedRightRatio: CGFloat {
        let pos = self.rightContainerX
        return -(pos - self.totalWidth) / self.rightContainerWidth
    }
    
    // MARK: 不透明度の適用
    
    /// 左メニューを基準にして不透明ビューの不透明度(opacity)を適用する
    private func applyLeftOpacity() {
        self.applyOpacity(self.openedLeftRatio)
    }
    
    /// 右メニューを基準にして不透明ビューの不透明度(opacity)を適用する
    private func applyRightOpacity() {
        self.applyOpacity(self.openedRightRatio)
    }
    
    /// 不透明ビューの不透明度(opacity)を適用する
    /// - parameter openedRatio: 不透明度を計算するための比率係数
    private func applyOpacity(openedRatio: CGFloat) {
        let opacity = self.options.content.opacity * openedRatio
        self.opacityView.layer.opacity = Float(opacity)
    }
    
    // MARK: メインコンテナのスケールの適用
    
    /// 左メニューを基準にしてメインコンテナのスケールを適用する
    private func applyLeftContentViewScale() {
        self.applyContentViewScale(self.openedLeftRatio)
    }
    
    /// 右メニューを基準にしてメインコンテナのスケールを適用する
    private func applyRightContentViewScale() {
        self.applyContentViewScale(self.openedRightRatio)
    }
    
    /// メインコンテナのスケールを適用する
    /// - parameter openedRatio: スケールを計算するための比率係数
    private func applyContentViewScale(openedRatio: CGFloat) {
        let scale = CGFloat(1 - ((1 - self.options.content.scale) * openedRatio))
        self.mainContainerView.transform = CGAffineTransformMakeScale(scale, scale)
    }
    
    // MARK: 影
    
    /// 指定したビューに影を追加する
    /// - parameter containerView: 対象のビュー(コンテナビュー)
    private func addShadowToContainerView(containerView: UIView) {
        containerView.layer.masksToBounds = false
        containerView.layer.shadowOffset  = self.options.shadow.offset
        containerView.layer.shadowOpacity = self.options.shadow.opacity
        containerView.layer.shadowRadius  = self.options.shadow.radius
        containerView.layer.shadowColor   = self.options.shadow.color.CGColor
        containerView.layer.shadowPath    = UIBezierPath(rect: containerView.bounds).CGPath
    }
    
    /// 指定したビューから影を削除する
    /// - parameter containerView: 対象のビュー(コンテナビュー)
    private func removeShadowFromContainerView(containerView: UIView) {
        containerView.layer.masksToBounds = true
        self.mainContainerView.layer.opacity = 1
    }
    
    // MARK: メインコンテナビューのタッチ受け付けを切り替え
    
    /// メインコンテナビューのタッチイベントを可能にする
    private func enableContentInteraction() {
        mainContainerView.userInteractionEnabled = true
    }
    
    /// メインコンテナビューのタッチイベントを不可にする
    private func disableContentInteraction() {
        mainContainerView.userInteractionEnabled = false
    }
    
    // MARK: ウィンドウレベル
    
    /// オープン時用のウィンドウレベルに設定する
    private func setOpenWindowLevel() {
        self.setWindowLevel(UIWindowLevelStatusBar + 1)
    }
    
    /// クローズ時用のウィンドウレベルに設定する
    private func setCloseWindowLevel() {
        self.setWindowLevel(UIWindowLevelNormal)
    }
    
    /// ウィンドウレベルを設定する
    /// - parameter level: ウィンドウレベル
    private func setWindowLevel(level: UIWindowLevel) {
        if !self.options.hideStatusBar { return }
        
        dispatch_async(dispatch_get_main_queue()) {
            if let window = UIApplication.sharedApplication().keyWindow {
                window.windowLevel = level
            }
        }
    }
    
    // MARK: ビューコントローラのセットアップ/ティアダウン
    
    /// ビューコントローラのセットアップ
    /// - parameter viewController: ビューコントローラ
    /// - parameter containerView: ビューコントローラのビューを配置するコンテナビュー
    private func setupViewController(viewController: UIViewController?, containerView: UIView) {
        guard let vc = viewController else { return }
        
        self.addChildViewController(vc)
        vc.view.frame = containerView.bounds
        containerView.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
    
    /// ビューコントローラのティアダウン
    /// - parameter viewController: ビューコントローラ
    private func teardownViewController(viewController: UIViewController?) { // removeViewController
        guard let vc = viewController else { return }
        
        vc.view.layer.removeAllAnimations()
        vc.willMoveToParentViewController(nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
    
    // MARK: アニメーションなしのクローズ処理
    
    /// アニメーションなしで左側を閉じる
    private func closeLeftNonAnimation() {
        self.setCloseWindowLevel()
        
        var frame = self.leftContainerView.frame
        frame.origin.x = self.leftMinimumOrigin
        self.leftContainerView.frame = frame
        
        self.opacityView.layer.opacity = 0
        self.mainContainerView.transform = CGAffineTransformMakeScale(1, 1)
        self.removeShadowFromContainerView(self.leftContainerView)
        self.enableContentInteraction()
    }
    
    /// アニメーションなしで右側を閉じる
    private func closeRightNonAnimation() {
        self.setCloseWindowLevel()
        
        var frame = self.rightContainerView.frame
        frame.origin.x = self.totalWidth
        self.rightContainerView.frame = frame
        
        self.opacityView.layer.opacity = 0
        self.mainContainerView.transform = CGAffineTransformMakeScale(1, 1)
        self.removeShadowFromContainerView(self.rightContainerView)
        self.enableContentInteraction()
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        let point = touch.locationInView(self.view)
        
        if gestureRecognizer == self.leftPanGesture {
            return self.isRightClose && self.shouldSlideLeftForGestureRecognizer(gestureRecognizer, point: point)
        } else if gestureRecognizer == self.rightPanGesture {
            return self.isLeftClose && self.shouldSlideRightForGestureRecognizer(gestureRecognizer, point: point)
        } else if gestureRecognizer == self.leftTapGesture {
            return self.isLeftOpen && !self.isPointContainedWithinLeftRect(point)
        } else if gestureRecognizer == self.rightTapGesture {
            return self.isRightOpen && !self.isPointContainedWithinRightRect(point)
        }
        return true
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: ジェスチャレコグナイザデリゲート用のメソッド
    
    /// ジェスチャレコグナイザに対して左メニューのスライドを許可するかどうか
    /// - parameter ges: ジェスチャレコグナイザ
    /// - parameter point: ジェスチャレコグナイザのタッチ位置
    /// - returns: 許可/不許可
    private func shouldSlideLeftForGestureRecognizer(ges: UIGestureRecognizer, point: CGPoint) -> Bool {
        return self.isLeftOpen || (self.options.left.bezel && self.isLeftPointContainedWithinBezelRect(point))
    }
    
    /// 渡した位置が左メニューを引っ張り出すことのできる画面左領域の幅の中かどうかを返す
    /// - parameter point: 位置
    /// - returns: 渡した位置が左メニューを引っ張り出すことのできる画面左領域の幅の中かどうか
    private func isLeftPointContainedWithinBezelRect(point: CGPoint) -> Bool {
        var bezelRect = CGRectZero, temp = CGRectZero
        let width = self.options.left.bezelableWidth
        CGRectDivide(self.view.bounds, &bezelRect, &temp, width, .MinXEdge)
        return CGRectContainsPoint(bezelRect, point)
    }
    
    /// 渡した位置が左コンテナ内かどうかを返す
    /// - parameter point: 位置
    /// - returns: 渡した位置が左コンテナ内かどうか
    private func isPointContainedWithinLeftRect(point: CGPoint) -> Bool {
        return CGRectContainsPoint(self.leftContainerView.frame, point)
    }
    
    /// ジェスチャレコグナイザに対して右メニューのスライドを許可するかどうか
    /// - parameter ges: ジェスチャレコグナイザ
    /// - parameter point: ジェスチャレコグナイザのタッチ位置
    /// - returns: 許可/不許可
    private func shouldSlideRightForGestureRecognizer(ges: UIGestureRecognizer, point: CGPoint) -> Bool {
        return self.isRightOpen || (self.options.right.bezel && self.isRightPointContainedWithinBezelRect(point))
    }
    
    /// 渡した位置が右メニューを引っ張り出すことのできる画面右領域の幅の中かどうかを返す
    /// - parameter point: 位置
    /// - returns: 渡した位置が右メニューを引っ張り出すことのできる画面右領域の幅の中かどうか
    private func isRightPointContainedWithinBezelRect(point: CGPoint) -> Bool {
        var bezelRect = CGRectZero, temp = CGRectZero
        let width = self.totalWidth - self.options.right.bezelableWidth
        CGRectDivide(self.view.bounds, &temp, &bezelRect, width, .MinXEdge)
        return CGRectContainsPoint(bezelRect, point)
    }
    
    /// 渡した位置が右コンテナ内かどうかを返す
    /// - parameter point: 位置
    /// - returns: 渡した位置が右コンテナ内かどうか
    private func isPointContainedWithinRightRect(point: CGPoint) -> Bool {
        return CGRectContainsPoint(self.rightContainerView.frame, point)
    }
    
    // MARK: 通知
    
    /// 通知を行う
    /// - parameter notification: 通知内容
    private func notify(notification: NBSlideMenuNotification) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName(NBSlideMenu.notificationName(notification), object: nil)
    }
    
    /// 通知名を取得する
    /// - parameter notification: 通知内容
    /// - returns: 通知名
    private class func notificationName(notification: NBSlideMenuNotification) -> String {
        return "\(notification.rawValue)Notification@\(NBReflection(self).fullClassName)"
    }
    
    /// イニシャライザ
    
    public override func awakeFromNib() {
        self.initializeViews()
    }
    
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) { super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil) }
}

// MARK: - UIViewController -

public extension UIViewController {
    
    /// スライドメニュー
    public var slideMenu: NBSlideMenu? {
        var vc: UIViewController? = self
        while vc != nil {
            if vc is NBSlideMenu {
                return vc as? NBSlideMenu
            }
            vc = vc?.parentViewController
        }
        return nil
    }
}
