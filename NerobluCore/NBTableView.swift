// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK: - アダプタ -

/// テーブルビューアダプタクラス
public class NBTableAdapter : NSObject, UITableViewDelegate, UITableViewDataSource {
    
    /// 自身が管理するテーブルビュー
    public weak var tableView: UITableView!
    
    /// 自身を管理するビューコントローラの参照
    public weak var controller: UIViewController?
    
    /// セルの高さが伸縮するかどうか
    public var isFlexibleCellHeight: Bool = true
    
    private var sections = [NBTableSection]()
    
    private var registeredCells = [String]()
    
    /// イニシャライザ
    /// - parameter tableView: 自身が管理するテーブルビュー
    /// - parameter controller: 自身を管理するビューコントローラの参照
    public init(tableView: UITableView, controller: UIViewController? = nil) {
        super.init()
        
        tableView.delegate   = self
        tableView.dataSource = self
        
        self.controller = controller
        self.tableView  = tableView
    }
    
    /// テーブルビューのリロードを行う
    public func reload() {
        self.sections = self.setupSections()
        self.registerCells(self.sections)
        
        if self.isFlexibleCellHeight {
            self.tableView.estimatedRowHeight = self.rowHeight()
            self.tableView.rowHeight  = UITableViewAutomaticDimension
        } else {
            self.tableView.rowHeight = self.rowHeight()
        }
        
        self.tableView.reloadData()
    }
    
    /// セクションのセットアップを行う(継承先でオーバライドして指定する)
    /// - returns: NBTableSectionオブジェクトの配列
    public func setupSections() -> [NBTableSection] {
        return [NBTableSection()]
    }
    
    /// セルの高さ
    ///
    /// isFlexibleCellHeight=false時は、この高さが採用される。
    /// isFlexibleCellHeight=true時は、この高さがestimatedRowHeightの値として使用される
    /// - returns: セルの高さ
    public func rowHeight() -> CGFloat { return 44.0 }
    
    // セルの登録
    private func registerCells(sections: [NBTableSection]) {
        var i = 0
        for section in sections {
            section.adapter = self
            section.index   = i++
            for row in 0..<section.rowNumber {
                let cellIdentifier = section.cellIdentifierAtRow(row)
                if self.registeredCells.contains(cellIdentifier) { continue }
                
                if let _ = NSBundle.mainBundle().pathForResource(cellIdentifier, ofType: "nib") {
                    let nib = UINib(nibName: cellIdentifier, bundle: nil)
                    self.tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
                } else {
                    let cls = section.cellClassAtRow(row)
                    self.tableView.registerClass(cls, forCellReuseIdentifier: cellIdentifier)
                }
                self.registeredCells.append(cellIdentifier)
            }
        }
    }
    
    // MARK: テーブルビューデリゲート/データソース
    
    // セクション数
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    // 行数
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rowNumber
    }
    
    // セル
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sec = indexPath.section, row = indexPath.row
        let section = self.sections[sec]
        let cellIdentifier = section.cellIdentifierAtRow(row)
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) else {
            return UITableViewCell()
        }
        if let nbcell = cell as? NBTableCell {
            nbcell.section = section
            nbcell.index   = row
            nbcell.data    = section.dataAtRow(row)
            nbcell.setup()
        }
        
        return section.setup(cell, row: row)
    }
    
    // セル選択時
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.sections[indexPath.section].didSelectAtRow(indexPath.row)
    }
    
    // セクションヘッダタイトル
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].title
    }
}

// MARK: - セクション -

/// テーブルビューのセクションクラス
public class NBTableSection : NSObject {
    
    /// 自身のセクションインデックス
    public private(set) var index: Int = 0
    
    /// セクションを管理するアダプタオブジェクトの参照
    public weak var adapter: NBTableAdapter?
    
    /// セクションのタイトル(継承先でオーバライドして指定する)
    /// 
    /// 自動的にセクションヘッダとして使用される。
    /// 表示しない場合はオーバライドしないかもしくはnilを返すこと
    public var title: String? { return nil }
    
    /// セクションの行数(継承先でオーバライドして指定する)
    public var rowNumber: Int { return 0 }
    
    /// 指定した行で使用するセルのクラスを返却する(継承先でオーバライドして指定する)
    /// - parameter row: 行インデックス
    /// - returns: セルのクラス
    public func cellClassAtRow(row: Int) -> UITableViewCell.Type {
        return NBTableCell.self
    }
    
    /// 指定した行で使用するセルの再利用ID文字列を返却する(継承先でオーバライドして指定する)
    ///
    /// 特段の理由がなければオーバライドの必要はない
    /// - parameter row: 行インデックス
    /// - returns: セルの再利用ID文字列
    public func cellIdentifierAtRow(row: Int) -> String {
        return NBReflection(self.cellClassAtRow(row)).shortClassName
    }
    
    /// セルに割り当てられるデータを返却する(継承先でオーバライドして指定する)
    /// - parameter row: 行インデックス
    /// - returns: セルに割り当てられるデータ
    public func dataAtRow(row: Int) -> AnyObject? {
        return nil
    }
    
    /// セルのセットアップを行う(継承先でオーバライドして指定する)
    /// 
    /// セルのセットアップはNBTableCell#setup()で個別に行うこともできるが、
    /// このメソッドは非NBTableCellのセルクラスにも対応することができる。
    /// もしNBTableCell#setup()を同時に実装した場合は、このメソッドのほうが後に呼ばれることに留意すること。
    /// - parameter originalCell: セットアップ対象の再利用されたセルオブジェクト
    /// - parameter row: 行インデックス
    /// - returns: セットアップされたセルオブジェクト
    public func setup(originalCell: UITableViewCell, row: Int) -> UITableViewCell {
        return originalCell
    }
    
    /// セルが選択された時の処理(継承先でオーバライドして指定する)
    /// - parameter row: 行インデックス
    public func didSelectAtRow(row: Int) {} // NOP.
}

// MARK: - セル -

/// テーブルビューセルの基底クラス
public class NBTableCell : UITableViewCell {
    
    /// XIBを使用しない場合のセルスタイル
    public class var style: UITableViewCellStyle { return .Default }
    
    /// セルが属するセクションオブジェクト
    public weak var section: NBTableSection?
    
    /// セルに割り当てられるデータ
    public var data: AnyObject?
    
    /// 自身の行インデックス
    public private(set) var index: Int = 0
    
    /// セルの初期処理を行う
    public func initialize() {}
    
    /// インデックスパス
    public var indexPath: NSIndexPath {
        return NSIndexPath(forRow: self.index, inSection: self.section?.index ?? 0)
    }
    
    /// セルのセットアップを行う
    public func setup() {
        // 下記の実装は最もシンプルな実装です
        if let text = self.section?.dataAtRow(self.index) as? String {
            self.textLabel?.text = text
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize() // XIBがある場合はこちらが呼ばれる
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: self.dynamicType.style, reuseIdentifier: reuseIdentifier)
        self.initialize() // XIBがない場合はこちらが呼ばれる
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder) // 特に何もしないが実装しないと怒られる
    }
}

// MARK: - ビューコントローラ拡張 -
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
