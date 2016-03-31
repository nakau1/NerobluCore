// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK: - App拡張 -

public extension App {
    
    /// アプリケーション色定義
    public class Color {
        /// 透明色
        public static let Clear = UIColor.clearColor()
        /// 白
        public static let White = UIColor.whiteColor()
        /// 黒
        public static let Black = UIColor.blackColor()
    }
}

// MARK: - UIColor拡張 -

public extension UIColor {
    
    /// 0〜255のRGBA整数値からUIColorを生成する
    /// - parameter intRed: R値(0-255)
    /// - parameter intGreen: G値(0-255)
    /// - parameter intBlue: B値(0-255)
    /// - parameter intAlpha: α値(0-255)
    public convenience init(_ r: Int, _ g: Int, _ b: Int, _ a: Int = 255) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
    }
    
    /// RGB値からUIColorを生成する
    /// - parameter rgb: RGB値 (例: red = 0xFF0000)
    public convenience init(rgb: UInt32) {
        let r: CGFloat = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g: CGFloat = CGFloat((rgb & 0x00FF00) >>  8) / 255.0
        let b: CGFloat = CGFloat( rgb & 0x0000FF       ) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    /// RGBA値からUIColorを生成する
    /// - parameter rgba: RGBA値 (例: red = 0xFF0000FF)
    public convenience init(rgba: UInt32) {
        let r: CGFloat = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let g: CGFloat = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let b: CGFloat = CGFloat((rgba & 0x0000FF00) >>  8) / 255.0
        let a: CGFloat = CGFloat( rgba & 0x000000FF       ) / 255.0
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    /// カラーコード文字列からUIColorを生成する
    /// - parameter colorCode: カラーコード文字列 (例: "#FF0000", "#FF0000FF", "#F00", "FF0000", "FF0000FF", "F00")
    public convenience init?(colorCode: String) {
        guard let hex = UIColor.colorCodeToHex(colorCode) else { return nil }
        self.init(rgba: hex)
    }
    
    /// RGBAの文字列表現を返却する (例: red = FF0000FF)
    public var rgbaString: String {
        var r:CGFloat = -1, g:CGFloat = -1, b:CGFloat = -1, a:CGFloat = -1
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return "\(toHex(r))\(toHex(g))\(toHex(b))\(toHex(a))"
    }
    
    /// RGBの文字列表現を返却する (例: red = FF0000)
    public var rgbString: String {
        var r:CGFloat = -1, g:CGFloat = -1, b:CGFloat = -1, a:CGFloat = -1
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return "\(toHex(r))\(toHex(g))\(toHex(b))"
    }
    
    /// カラーコード文字列からRGBA値を取得する
    /// 
    /// 以下の様なカラーコード文字列を受け付けます
    /// * "#FF0000"
    /// * "#FF0000FF"
    /// * "#F00"
    /// * "#F00F"
    /// * "FF0000"
    /// * "FF0000FF"
    /// * "F00"
    /// * "F00F"
    /// - parameter colorCode: カラーコード文字列
    /// - returns: RGBA値
    public class func colorCodeToHex(var colorCode: String) -> UInt32? {
        if colorCode.hasPrefix("#") {
            colorCode = colorCode.substringWithRange(fromIndex: 1)
        }
        
        switch colorCode.length {
        case 8:
            break
        case 6:
            colorCode += "FF"
        case 4:
            let r = colorCode.substringWithRange(0, length: 1)
            let g = colorCode.substringWithRange(1, length: 1)
            let b = colorCode.substringWithRange(2, length: 1)
            let a = colorCode.substringWithRange(3, length: 1)
            colorCode = "\(r)\(r)\(g)\(g)\(b)\(b)\(a)\(a)"
        case 3:
            let r = colorCode.substringWithRange(0, length: 1)
            let g = colorCode.substringWithRange(1, length: 1)
            let b = colorCode.substringWithRange(2, length: 1)
            colorCode = "\(r)\(r)\(g)\(g)\(b)\(b)FF"
        default: return nil
        }
        
        if !colorCode.isMatchedRegularExpression("^[a-fA-F0-9]+$") {
            return nil
        }
        var ret: UInt32 = 0x0
        NSScanner(string: colorCode).scanHexInt(&ret)
        return ret
    }
    
    /// アルファ値を指定した新しいUIColorを生成して取得する
    /// 
    /// このメソッドはcolorWithAlphaComponent:のラッパメソッドです
    /// - parameter alpha: アルファ値(0.0 - 1.0)
    /// - returns: アルファ値を指定した新しいUIColor
    public func alpha(alpha: CGFloat) -> UIColor {
        return self.colorWithAlphaComponent(alpha)
    }
    
    /// 各コンポーネントのCGFloat値をタプルで返却する
    public var floatValues: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r:CGFloat = -1, g:CGFloat = -1, b:CGFloat = -1, a:CGFloat = -1
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
    
    /// 各コンポーネントの0〜255の整数値をタプルで返却する
    public var intValues: (red: UInt32, green: UInt32, blue: UInt32, alpha: UInt32) {
        let f = self.floatValues
        return (
            self.intByCGFloat(f.red),
            self.intByCGFloat(f.green),
            self.intByCGFloat(f.blue),
            self.intByCGFloat(f.alpha)
        )
    }
    
    /// RGB値を返却する
    public var rgb: UInt32 {
        let i = self.intValues
        return (i.red * 0x010000) + (i.green * 0x000100) + i.blue
    }
    
    /// RGBA値を返却する
    public var rgba: UInt32 {
        let i = self.intValues
        return (i.red * 0x01000000) + (i.green * 0x00010000) + (i.blue *  0x00000100) + i.alpha
    }
    
    private func toHex(v: CGFloat) -> String {
        let n = self.intByCGFloat(v)
        return NSString(format: "%02X", n) as String
    }
    
    private func intByCGFloat(v: CGFloat) -> UInt32 {
        return UInt32(round(v * 255))
    }
    
    override public var description: String {
        return "\(NSStringFromClass(self.dynamicType)) #\(self.rgbaString)"
    }
}

// MARK - デバッグ(テスト)用の透過色 -

public let TestColorRed    = UIColor.redColor()   .colorWithAlphaComponent(0.3)
public let TestColorBlue   = UIColor.blueColor()  .colorWithAlphaComponent(0.3)
public let TestColorGreen  = UIColor.greenColor() .colorWithAlphaComponent(0.3)
public let TestColorYellow = UIColor.yellowColor().colorWithAlphaComponent(0.3)
public let TestColorPurple = UIColor.purpleColor().colorWithAlphaComponent(0.3)
public let TestColorGray   = UIColor.grayColor()  .colorWithAlphaComponent(0.3)
