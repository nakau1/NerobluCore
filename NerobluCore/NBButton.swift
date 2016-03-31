// =============================================================================
// PHOTTY
// Copyright (C) 2015 NeroBlu. All rights reserved.
// =============================================================================
import UIKit

public enum NBButtonLayout {
    case None
    case VerticalImageText(interval:CGFloat)
    case LeftAlign(edge:CGFloat, interval:CGFloat)
}

// MARK: - NBButton -

/// カスタムなボタンクラス
/// 
/// このボタンクラスは以下の機能があります
/// * ハイライト背景色・文字色(highlightedBackgroundColor: XIBから設定可能)
/// * 枠線のみのボタン(linedFrame: XIBから設定可能)
/// * 角丸(cornerRadius: XIBから設定可能)
@IBDesignable public class NBButton : UIButton {
    
    private var originalBackgroundColor: UIColor?
    private var originalBorderColor:     UIColor?
    
    // MARK: 角丸
    
    /// 角丸の半径
    @IBInspectable public var cornerRadius : Float = 0.0 {
        didSet { let v = self.cornerRadius
            self.layer.cornerRadius = CGFloat(v)
        }
    }
    
    // MARK: 枠線
    
    /// 枠線の太さ
    @IBInspectable public var borderWidth : Float = 0.0 {
        didSet { let v = self.borderWidth
            self.layer.borderWidth = CGFloat(v)
        }
    }
    
    /// 枠線の色
    @IBInspectable public var borderColor : UIColor? {
        didSet { let v = self.borderColor
            self.originalBorderColor = v
            self.layer.borderColor   = v?.CGColor
        }
    }
    
    // MARK: ハイライト
    
    /// 通常文字色
    @IBInspectable public var normalTitleColor : UIColor? = nil {
        didSet { let v = self.normalTitleColor
            self.setTitleColor(v, forState: .Normal)
        }
    }
    
    /// 通常背景色
    /// setTitleColor(_:forState:)を使用せずに設定できる
    @IBInspectable public var normalBackgroundColor : UIColor? = nil {
        didSet { let v = self.normalBackgroundColor
            self.originalBackgroundColor = v
            self.backgroundColor         = v
        }
    }
    
    /// ハイライト時の文字色
    @IBInspectable public var highlightedTitleColor : UIColor? = nil {
        didSet { let v = self.highlightedTitleColor
            self.setTitleColor(v, forState: .Highlighted)
        }
    }
    
    /// ハイライト時の背景色
    @IBInspectable public var highlightedBackgroundColor : UIColor? = nil
    
    /// ハイライト時の枠線の色
    @IBInspectable public var highlightedBorderColor : UIColor?
    
    override public var highlighted: Bool {
        get {
            return super.highlighted
        }
        set(v) {
            super.highlighted = v
            
            let nb = self.originalBackgroundColor, hb = self.highlightedBackgroundColor, cb = v ? hb : nb
            self.backgroundColor = cb
            
            let nl = self.originalBorderColor, hl = self.highlightedBorderColor, cl = v ? hl : nl
            self.layer.borderColor = cl?.CGColor
        }
    }
    
    // MARK: 定形レイアウト
    
    /// 定形レイアウト種別
    public var fixedLayout: NBButtonLayout = .None {
        didSet {
            self.applyFixedLayout()
        }
    }
    
    override public var frame: CGRect {
        didSet {
            self.applyFixedLayout()
        }
    }
    
    private struct SizeSet {
        var bw: CGFloat = 0 // buttonWidth
        var bh: CGFloat = 0 // buttonHeight
        var iw: CGFloat = 0 // imageWidth
        var ih: CGFloat = 0 // imageHeight
        var tw: CGFloat = 0 // textWidth
        var th: CGFloat = 0 // textHeight
        
        init?(button: UIButton) {
            guard let imageView = button.imageView, let titleLabel = button.titleLabel else {
                return nil
            }
            self.bw = crW(button.bounds)
            self.bh = crH(button.bounds)
            self.iw = crW(imageView.bounds)
            self.ih = crH(imageView.bounds)
            self.tw = crW(titleLabel.bounds)
            self.th = crH(titleLabel.bounds)
        }
    }
    
    public func applyFixedLayout() {
        guard let size = SizeSet(button: self) else {
            return
        }
        switch self.fixedLayout {
        case .VerticalImageText: self.updateEdgeInsetsVerticalImageText(size)
        case .LeftAlign:         self.updateEdgeInsetsLeftAlign(size)
        default:break
        }
    }
    
    private func updateEdgeInsetsVerticalImageText(s: SizeSet) {
        var interval:CGFloat = 0
        switch self.fixedLayout {
        case .VerticalImageText(let i): interval = i
        default:return // dead code
        }
        
        let verticalMergin     = (s.bh - (s.th + interval + s.ih)) / 2.0
        let imageHorizonMergin = (s.bw - s.iw) / 2.0
        
        // content
        var t:CGFloat = 0, l:CGFloat = 0, b:CGFloat = 0, r:CGFloat = 0
        self.contentEdgeInsets = UIEdgeInsetsMake(t, l, b, r)
        
        // image
        t = verticalMergin
        l = imageHorizonMergin
        b = verticalMergin + s.th + (interval / 2.0)
        r = imageHorizonMergin - s.tw
        self.imageEdgeInsets = UIEdgeInsetsMake(t, l, b, r)
        
        // text
        t = verticalMergin + s.ih + (interval / 2.0)
        l = -s.iw
        b = verticalMergin
        r = 0
        self.titleEdgeInsets = UIEdgeInsetsMake(t, l, b, r)
    }
    
    private func updateEdgeInsetsLeftAlign(s: SizeSet) {
        var edge:CGFloat = 0, interval:CGFloat = 0, l:CGFloat = 0
        switch self.fixedLayout {
        case .LeftAlign(let e, let i): edge = e; interval = i
        default:return // dead code
        }
        
        // content
        l = s.bw - s.tw - s.iw - edge
        self.contentEdgeInsets = UIEdgeInsetsMake(0, -l, 0, 0)
        
        // text
        l = interval
        self.titleEdgeInsets = UIEdgeInsetsMake(0, l, 0, 0)
    }
    
    // MARK: 初期化
    
    /// インスタン生成時の共通処理
    internal func commonInitialize() {
        self.originalBackgroundColor = self.backgroundColor
    }
    
    override public init (frame : CGRect) { super.init(frame : frame); commonInitialize() }
    convenience public init () { self.init(frame:CGRect.zero) }
    required public init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); commonInitialize() }
}

// MARK: - UIButton Extension -

public extension UIButton {
    
    /// タイトルラベルのフォント
    public var titleFont: UIFont? {
        get {
            return self.titleLabel?.font
        }
        set(v) {
            guard let titleLabel = self.titleLabel else { return }
            titleLabel.font = v
        }
    }
}

// MARK: - NBLongPressableButton -

/// NBLongPressableButton用デリゲートプロトコル
@objc public protocol NBLongPressableButtonDelegate {
    
    /// 継続的な長押しイベントが発生した時(押しっぱなし中に一定間隔で呼ばれる)
    /// - parameter longPressableButton: ボタンの参照
    /// - parameter times: イベント発生回数(1から始まる通し番号)
    optional func longPressableButtonDidHoldPress(longPressableButton: NBLongPressableButton, times: UInt64)
    
    /// 継続的な長押しが始まった時
    /// - parameter longPressableButton: ボタンの参照
    optional func longPressableButtonDidStartLongPress(longPressableButton: NBLongPressableButton)
    
    /// 継続的な長押しが終わった時
    /// - parameter longPressableButton: ボタンの参照
    optional func longPressableButtonDidStopLongPress(longPressableButton: NBLongPressableButton)
}

/// 継続的長押しが可能なボタンクラス
@IBDesignable public class NBLongPressableButton : NBButton {
    
    /// デリゲート
    @IBOutlet public weak var delegate: NBLongPressableButtonDelegate?
    
    /// 長押しを感知するまでに要する秒数
    @IBInspectable public var longPressRecognizeDuration : Double = 1.2 // as CFTimeInterval
    
    /// 1段階目の長押し継続を感知するまでに要する秒数
    @IBInspectable public var primaryIntervalOfContinuousEvent : Double = 0.1
    
    /// 1段階目の長押し継続を繰り返す回数
    @IBInspectable public var primaryTimesOfContinuousEvent : Int = 10
    
    /// 2段階目の長押し継続を感知するまでに要する秒数
    @IBInspectable public var secondaryIntervalOfContinuousEvent : Double = 0.05
    
    /// 2段階目の長押し継続を繰り返す回数
    @IBInspectable public var secondaryTimesOfContinuousEvent : Int = 50
    
    /// 3段階目の長押し継続を感知するまでに要する秒数
    @IBInspectable public var finalyIntervalOfContinuousEvent : Double = 0.01
    
    enum ContinuousEventPhase { case Primary, Secondary, Finaly }
    
    private let longPressMinimumPressDuration: Double = 1.0
    private var longPressRecognizer:           UILongPressGestureRecognizer?
    private var longPressTimer:                NSTimer?
    private var touchesStarted:                CFTimeInterval?
    private var touchesEnded:                  Bool = false
    private var eventPhase:                    ContinuousEventPhase = .Primary
    private var eventTimes:                    Int = 0
    private var eventTotalTimes:               UInt64 = 0
    
    internal override func commonInitialize() {
        super.commonInitialize()
        
        let lpr = UILongPressGestureRecognizer(target: self, action: Selector("didRecognizeLongPress:"))
        lpr.cancelsTouchesInView = false
        lpr.minimumPressDuration = self.longPressRecognizeDuration
        self.addGestureRecognizer(lpr)
    }
    
    @objc private func didRecognizeLongPress(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .Began {
            self.didBeginPressButton()
        } else if recognizer.state == .Ended {
            self.didEndPressButton()
        }
    }
    
    private func didBeginPressButton() {
        if self.touchesStarted != nil { return }
        self.setNeedsDisplay()
        
        self.touchesStarted = CACurrentMediaTime()
        self.touchesEnded   = false
        
        let delta = Int64(Double(NSEC_PER_SEC) * self.longPressMinimumPressDuration)
        let delay = dispatch_time(DISPATCH_TIME_NOW, delta)
        dispatch_after(delay, dispatch_get_main_queue()) { [weak self] in
            if let strongSelf = self where strongSelf.touchesEnded {
                strongSelf.didEndPressButton()
            }
        }
        self.delegate?.longPressableButtonDidStartLongPress?(self)
        self.startLongPressTimer()
    }
    
    private func didEndPressButton() {
        if let touchesStarted = self.touchesStarted where (CACurrentMediaTime() - touchesStarted) >= Double(self.longPressMinimumPressDuration) {
            self.touchesStarted = nil
            self.stopLongPressTimer()
            self.delegate?.longPressableButtonDidStopLongPress?(self)
        }
        else {
            self.touchesEnded = true
        }
    }
    
    private func startLongPressTimer() {
        self.eventPhase = .Primary
        self.eventTimes  = 0
        self.eventTotalTimes = 0
        
        self.longPressTimer = NSTimer.scheduledTimerWithTimeInterval(self.intervalOfContinuousEvent,
            target:   self,
            selector: Selector("didFireLongPressTimer:"),
            userInfo: nil,
            repeats:  false
        )
    }
    
    @objc private func didFireLongPressTimer(timer: NSTimer) {
        if self.eventTotalTimes < UINT64_MAX {
           self.eventTotalTimes++
        }
        self.delegate?.longPressableButtonDidHoldPress?(self, times: self.eventTotalTimes)
        
        if self.eventPhase != .Finaly && ++self.eventTimes >= self.timesOfContinuousEvent {
            self.updateToNextContinuousEventPhase()
            self.eventTimes  = 0
        }
        
        self.longPressTimer = NSTimer.scheduledTimerWithTimeInterval(self.intervalOfContinuousEvent,
            target:   self,
            selector: Selector("didFireLongPressTimer:"),
            userInfo: nil,
            repeats:  false
        )
    }
    
    private func stopLongPressTimer() {
        if let timer = self.longPressTimer where timer.valid {
            timer.invalidate()
        }
        self.longPressTimer = nil
    }
    
    private var intervalOfContinuousEvent: NSTimeInterval {
        switch self.eventPhase {
        case .Primary:   return self.primaryIntervalOfContinuousEvent
        case .Secondary: return self.secondaryIntervalOfContinuousEvent
        case .Finaly:    return self.finalyIntervalOfContinuousEvent
        }
    }
    
    private var timesOfContinuousEvent: Int {
        switch self.eventPhase {
        case .Primary:   return self.primaryTimesOfContinuousEvent
        case .Secondary: return self.secondaryTimesOfContinuousEvent
        case .Finaly:    return -1
        }
    }
    
    private func updateToNextContinuousEventPhase() {
        if self.eventPhase == .Primary {
            self.eventPhase = .Secondary
        } else if self.eventPhase == .Secondary {
            self.eventPhase = .Finaly
        }
    }
}

