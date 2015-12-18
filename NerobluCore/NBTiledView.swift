// =============================================================================
// PHOTTY
// Copyright (C) 2015 NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// 簡易的なタイルビュークラス
public class NBTiledView : UIScrollView {
    
    /// 1行に配置する要素ビューの数
    @IBInspectable public var numberOfElementsPerRow: Int = 3
    
    /// 表示する行数(表示されない分はスクロールで表示する)
    @IBInspectable public var numberOfShowedRows: Int = 2
    
    /// 要素ビュー同士の間隔
    @IBInspectable public var intervalWidth: Float = 1.0
    
    private var renderedSize = CGSizeZero
    
    /// 要素ビューの配列
    public var elements: [UIView] = [] {
        didSet {
            self.subviews.forEach { $0.removeFromSuperview() }
            self.elements.forEach {
                self.addSubview($0)
            }
        }
    }
    
    /// レンダリングを行う
    public func render() {
        if CGSizeEqualToSize(self.bounds.size, self.renderedSize) {
            return
        }
        self.renderedSize = self.bounds.size
        
        let vw = crW(self.bounds), vh = crH(self.bounds) // view-size
        let iw = CGFloat(self.intervalWidth) // interval-width
        let nc = CGFloat(self.numberOfElementsPerRow), nr = CGFloat(self.numberOfShowedRows) // number of columns and rows .. to CGFloat
        let w  = (vw - (iw * (nc - 1.0))) / nc // button-width
        let h  = (vh - (iw * nr)) / nr // button-height
        var c  = 0, r = 0 // column and row index
        var x: CGFloat = 0 // x offset
        var y: CGFloat = 0 // y offset
        
        for element in self.elements {
            let cf = CGFloat(c), rf = CGFloat(r) // column and row index .. to CGFloat
            x = (cf * (w + iw))
            y = (rf * (h + iw))
            
            element.frame = cr(x, y, w, h)
            
            if ++c >= self.numberOfElementsPerRow {
                c  = 0
                r += 1
            }
        }
        
        if let last = self.elements.last {
            let maxY = crB(last.frame)
            self.contentSize = cs(vw, maxY)
        }
        
        self.bounces = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
    }
}
