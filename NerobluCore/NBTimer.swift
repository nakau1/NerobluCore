// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// タイマークラス
public class NBTimer : NSObject {
    
    /// タイマー発火時のコールバックハンドラ
    public typealias NBTimerFiredHandler = (Void) -> Void
    
    /// タイマーを開始する
    /// - parameter time: タイマー時間
    /// - parameter firedHandler: タイマー発火時のコールバック
    public class func start(time: NSTimeInterval, fired: NBTimerFiredHandler?) {
        let timer = NBTimer()
        NBTimer.timers.append(timer)
        
        timer.firedHandler = fired
        timer.timer = NSTimer.scheduledTimerWithTimeInterval(time,
            target:   timer,
            selector: "didFireTimer",
            userInfo: nil,
            repeats:  false
        )
    }
    
    /// 自身をスタックする静的配列
    private static var timers: [NBTimer] = []
    
    /// コールバックハンドラ
    private var firedHandler: NBTimerFiredHandler?
    
    /// NSTimerオブジェクト
    private weak var timer: NSTimer?
    
    /// タイマー発火時
    @objc private func didFireTimer() {
        if let firedHandler = self.firedHandler {
            firedHandler()
        }
        self.timer = nil
        
        if let index = NBTimer.timers.indexOf(self) {
            NBTimer.timers.removeAtIndex(index.hashValue)
        }
    }
}
