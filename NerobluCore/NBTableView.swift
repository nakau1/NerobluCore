// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK: - NBTableAdapter -

/// テーブルビューを管理するアダプタクラス
public class NBTableAdapter : NSObject, UITableViewDelegate, UITableViewDataSource {
    
    /// 管理するテーブルビュー
    public weak var tableView: UITableView!
    
    /// 関連するビューコントローラの参照
    public weak var controller: UIViewController?
    
    /// イニシャライザ
    /// - parameter tableView: 管理するテーブルビュー
    /// - parameter controller: 関連するビューコントローラの参照
    /// - parameter flexibleHeight: 高さを動的に変更するかどうか
    public required init(tableView: UITableView, controller: UIViewController? = nil, flexibleHeight: Bool = true) {
        super.init()
        if flexibleHeight {
            tableView.estimatedRowHeight = 100
            tableView.rowHeight = UITableViewAutomaticDimension
        }
        self.tableView  = tableView
        self.controller = controller
    }
    
    /// テーブルビューのリロードを行う
    public func reload() {
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    /// 行数を返却する(継承先でオーバライドして指定する)
    /// - parameter section: セクションインデックス
    /// - returns: 行数
    public func numberOfRowsInSection(section: Int) -> Int {
        return 0
    }
    
    /// セルの再利用ID文字列を返却する(継承先でオーバライドして指定する)
    /// - parameter indexPath: インデックスパス
    /// - returns: セルの再利用ID文字列
    public func cellIdentifier(indexPath: NSIndexPath) -> String {
        return NBTableCellDefaultIdentifier
    }
    
    /// セルを返却する(継承先でオーバライドして指定する)
    /// - parameter indexPath: インデックスパス
    /// - parameter reusedCell: 再利用されてきたセル
    /// - returns: セル
    public func cellForRowAtIndexPath(indexPath: NSIndexPath, reusedCell: UITableViewCell) -> UITableViewCell {
        return reusedCell
    }
    
    /// セルが選択された時の処理を行う
    /// - parameter indexPath: インデックスパス
    public func didSelectRowAtIndexPath(indexPath: NSIndexPath) {} // NOP.
    
    // MARK: UITableViewDelegate / UITableViewDataSource
    
    /// 行数
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRowsInSection(section)
    }
    
    /// セル
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = self.cellIdentifier(indexPath)
        guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier) else {
            return UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        if let nb = cell as? NBTableCell {
            nb.adapter    = self
            nb.controller = self.controller
            nb.tableView  = tableView
            nb.indexPath  = indexPath
        }
        return self.cellForRowAtIndexPath(indexPath, reusedCell: cell)
    }
    
    /// 選択時
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.didSelectRowAtIndexPath(indexPath)
    }
}

// MARK: - NBTableCell -

public let NBTableCellDefaultIdentifier = "cell"

/// テーブルビューセルの基底クラス
public class NBTableCell : UITableViewCell {
    
    /// 自身の行インデックス
    public var row: Int = 0
    
    /// セクションインデックス
    public var section: Int = 0
    
    /// アダプタオブジェクトの参照
    public weak var adapter: NBTableAdapter?
    
    /// 関連するビューコントローラの参照
    public weak var controller: UIViewController?
    
    /// 所属するテーブルビューの参照
    public weak var tableView: UITableView?
    
    /// インデックスパス
    public var indexPath: NSIndexPath {
        get {
            return NSIndexPath(self.row, self.section)
        }
        set(v) {
            self.row     = v.row
            self.section = v.section
        }
    }
}

// MARK: - NBViewController拡張 -
public extension NBViewController {
    
    /// テーブルビューアダプタオブジェクト
    public var adapter: NBTableAdapter? {
        get {
            return self.externalComponents["NBTableAdapter"] as? NBTableAdapter
        }
        set(v) {
            self.externalComponents["NBTableAdapter"] = v
        }
    }
}

// MARK: - UITableView拡張 -
public extension UITableView {
    
    public func moveToTop(animated: Bool = true) {
        self.scrollToRowAtIndexPath(NSIndexPath(0), atScrollPosition: .Top, animated: animated)
    }
}

// MARK: - NSIndexPath拡張 -
public extension NSIndexPath {
    
    public convenience init(_ row: Int, _ section: Int = 0) {
        self.init(forRow: row, inSection: section)
    }
}

// MARK: - NBTableCellBackgrounViewOptions -

/// NBTableCellBackgrounViewのオプション
public struct NBTableCellBackgrounViewOptions {
    
    /// イニシャライザ
    /// - parameter highlightedBackgroundColor: ハイライト時の背景色
    /// - parameter separatorColor: セパレータ色
    public init(highlightedBackgroundColor: UIColor? = nil, separatorColor: UIColor? = nil) {
        if let color = highlightedBackgroundColor { self.highlightedBackgroundColor = color }
        if let color = separatorColor             { self.separatorColor             = color }
    }
    
    /// 選択スタイル(highlightedBackgroundColorが指定されていない場合は、この値によって背景色を決定する)
    public var selectionStyle: UITableViewCellSelectionStyle = .Blue
    
    /// ハイライト時の背景色
    public var highlightedBackgroundColor: UIColor?
    
    /// 通常時の背景色
    public var backgroundColor = UIColor.whiteColor()
    
    /// セパレータ色
    public var separatorColor = UIColor(rgb: 0xC8C7CC)
    
    /// セパレータの太さ
    public var separatorWidth: CGFloat = 0.5
    
    /// セパレータの左側マージン値
    public var separatorLeftMargin: CGFloat = 20.0
    
    /// セパレータの右側マージン値
    public var separatorRightMargin: CGFloat = 0.0
}

// MARK: - NBTableCellBackgrounView -

/// テーブルビューセルの汎用背景ビュー
public class NBTableCellBackgrounView : UIView {
    
    /// ハイライト用背景ビューかどうか
    private var highlighted = false
    
    /// オプション
    private var options: NBTableCellBackgrounViewOptions!
    
    /// イニシャライザ(内部用)
    private convenience init(highlighted: Bool, options: NBTableCellBackgrounViewOptions) {
        self.init()
        self.highlighted = highlighted
        self.options     = options
    }
    
    /// 描画
    override public func drawRect(rect: CGRect) {
        let opt = self.options
        let context = UIGraphicsGetCurrentContext()
        
        opt.backgroundColor.setFill(); UIRectFill(rect)
        
        CGContextMoveToPoint(context, 0, 0)
        CGContextSetFillColorWithColor(context, self.properBackgroundColor(opt).CGColor)
        CGContextFillRect(context, rect)
        
        let minX: CGFloat = opt.separatorLeftMargin
        let maxX: CGFloat = CGRectGetMaxX(rect) - opt.separatorRightMargin
        let y:    CGFloat = CGRectGetMaxY(rect) - opt.separatorWidth / 2
        CGContextSetStrokeColorWithColor(context, opt.separatorColor.CGColor)
        CGContextSetLineWidth(context, opt.separatorWidth)
        CGContextMoveToPoint(context, minX, y)
        CGContextAddLineToPoint(context, maxX, y)
        CGContextStrokePath(context)
    }
    
    /// オプションとメンバ変数を元に適切な背景色を返却する
    /// - parameter opt: オプション
    /// - returns: 背景色
    private func properBackgroundColor(opt: NBTableCellBackgrounViewOptions) -> UIColor {
        if !self.highlighted {
            return UIColor.clearColor()
        } else {
            if let hbg = self.options.highlightedBackgroundColor {
                return hbg
            } else {
                return self.backgroundColorWithSelectionStyle(self.options.selectionStyle)
            }
        }
    }
    
    /// 選択スタイルから背景色を返却する
    /// - parameter selectionStyle: 選択スタイル
    /// - returns: 背景色
    private func backgroundColorWithSelectionStyle(selectionStyle: UITableViewCellSelectionStyle) -> UIColor {
        switch selectionStyle {
        case .None: return UIColor.clearColor()
        case .Blue: return UIColor(red: 0.408, green: 0.757, blue: 0.992, alpha: 0.5)
        default:    return UIColor(white: 0.8, alpha: 0.5)
        }
    }
}

public extension UITableViewCell {
    
    /// テーブルセルに背景ビューをセットする
    /// - parameter options: オプション
    /// - parameter tableView: optionsを省略した場合に、テーブルビューの設定が自動的に反映されます
    public func setTableCellBackgrounView(options options: NBTableCellBackgrounViewOptions? = nil, tableView: UITableView? = nil) {
        
        // オプションの設定
        var opt: NBTableCellBackgrounViewOptions
        if let _ = options {
            opt = options!
        } else {
            opt = NBTableCellBackgrounViewOptions()
            if let table = tableView {
                if let color = table.backgroundColor { opt.backgroundColor = color }
                if let color = table.separatorColor  { opt.separatorColor  = color }
                opt.separatorLeftMargin  = table.separatorInset.left
                opt.separatorRightMargin = table.separatorInset.right
                opt.selectionStyle       = self.selectionStyle
            }
        }
        // 背景ビューの当て込み
        self.backgroundView         = NBTableCellBackgrounView(highlighted: false, options: opt)
        self.selectedBackgroundView = NBTableCellBackgrounView(highlighted: true,  options: opt)
    }
}

// MARK: - NBTableExternalViewOptions -

/// NBTableExternalViewのオプション
public struct NBTableExternalViewOptions {
    
    /// 文字色
    public var textColor = UIColor(rgb: 0x94949A)
    
    /// 背景色
    public var backgroundColor = UIColor.clearColor()
    
    /// フォント
    public var font = UIFont.systemFontOfSize(16.0)
    
    /// セパレータの左側マージン値
    public var insets = UIEdgeInsets(top: 4.0, left: 20.0, bottom: 4.0, right: 12.0)
    
    /// テキスト揃え
    public var align = NSTextAlignment.Left
}

// MARK: - NBTableExternalView -

/// テーブルビューのヘッダ/フッタ用の汎用ビュー
public class NBTableExternalView : UIView {
    
    /// イニシャライザ
    /// - parameter text: テキスト
    /// - parameter tableView: テーブルビューの参照
    /// - parameter opt: NBTableExternalViewのオプション
    public convenience init(text: String, tableView: UITableView, opt: NBTableExternalViewOptions = NBTableExternalViewOptions()) {
        self.init()
        self.backgroundColor = opt.backgroundColor
        
        let max = crW(tableView.frame) - (opt.insets.left + opt.insets.right)
        
        let label = UILabel()
        label.text          = text
        label.numberOfLines = 0
        label.textAlignment = opt.align
        label.font          = opt.font
        label.textColor     = opt.textColor
        
        var labelFrame = crZ()
        labelFrame.size.width  = max
        labelFrame.size.height = label.sizeThatFits(cs(max, CGFloat.max)).height
        labelFrame.origin.x    = opt.insets.left
        labelFrame.origin.y    = opt.insets.top
        
        label.frame = labelFrame
        self.addSubview(label)
        
        var selfFrame = crZ()
        selfFrame.size.width  = opt.insets.left + crW(labelFrame) + opt.insets.right
        selfFrame.size.height = opt.insets.top  + crH(labelFrame) + opt.insets.bottom
        
        self.frame = selfFrame
    }
}
