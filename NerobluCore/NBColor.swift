// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// 色の16進数指定に関するクラス拡張
public extension UIColor {
    
    /// UInt32によるカラー値からUIColorを取得する
    /// - parameter hex: UInt32によるカラー値 (例: red = 0xFF0000FF)
    /// - returns: 新しいUIColorオブジェクト
    public class func colorWithRGBA(hex: UInt32)->UIColor {
        let r: CGFloat = CGFloat((hex & 0xFF000000) >> 24) / 255.0
        let g: CGFloat = CGFloat((hex & 0x00FF0000) >> 16) / 255.0
        let b: CGFloat = CGFloat((hex & 0x0000FF00) >>  8) / 255.0
        let a: CGFloat = CGFloat( hex & 0x000000FF       ) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    /// UInt32によるカラー値からUIColorを取得する
    /// - parameter hex: UInt32によるカラー値 (例: red = 0xFF0000)
    /// - returns: 新しいUIColorオブジェクト(alphaは1.0固定)
    public class func colorWithRGB(hex: UInt32)->UIColor {
        let r: CGFloat = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g: CGFloat = CGFloat((hex & 0x00FF00) >>  8) / 255.0
        let b: CGFloat = CGFloat( hex & 0x0000FF       ) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    /// RGBAの文字列表現 (例: red = FF0000FF)
    public var rgbaString: String {
        var r:CGFloat = -1, g:CGFloat = -1, b:CGFloat = -1, a:CGFloat = -1
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return "\(toHex(r))\(toHex(g))\(toHex(b))\(toHex(a))"
    }
    
    /// RGBの文字列表現 (例: red = FF0000)
    public var rgbString: String {
        var r:CGFloat = -1, g:CGFloat = -1, b:CGFloat = -1, a:CGFloat = -1
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return "\(toHex(r))\(toHex(g))\(toHex(b))"
    }
    
    private func toHex(x: CGFloat)->String {
        let n = Int(round(x * 255))
        return NSString(format: "%02X", n) as String
    }
    
    override public var description: String {
        return "\(NSStringFromClass(self.dynamicType)) #\(self.rgbaString)"
    }
}
