// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit

// MARK: - NBSettingSectionType -

/// セクション種別
public enum NBSettingSectionType {
    /// 各行の挙動に任せる
    case Default
    /// 単一選択用のセクション
    case SingleSelect(Int)
    /// 複数選択用のセクション
    case MultiSelect([Int])
    
    /// Defaultかどうか
    private var isDefault: Bool { switch self { case .Default: return true; default: return false } }
    
    /// 選択された行インデックスの配列
    private var selectedIndecies: [Int] {
        switch self {
        case let .SingleSelect(index):   return [index]
        case let .MultiSelect(indecies): return indecies
        default: return []
        }
    }
}

// MARK: - NBSettingLeftType -

/// 設定項目左側のコンポーネント種別
public enum NBSettingLeftType {
    /// 通常のテキストラベル
    case Plain
    /// テキストフィールドを表示する
    /// - parameter (String): テキストフィールドの文字列値
    case TextField(String)
    
    /// Plainかどうか
    private var isPlain: Bool { switch self { case .Plain: return true; default: return false } }
    /// TextFieldかどうか
    private var isTextField: Bool { switch self { case .TextField: return true; default: return false } }
}

// MARK: - NBSettingRightType -

/// 設定項目右側のコンポーネント種別
public enum NBSettingRightType {
    /// 何も配置しない
    case None
    /// サブテキスト(UITableViewCellStyle.Value1)を配置する
    /// - parameter (String): サブテキストに表示する文字列
    /// - parameter (Bool) detail: 詳細遷移用インジケータを表示するかどうか
    case Text(String, detail: Bool)
    /// チェックマークを配置する
    /// - parameter (Bool): チェックマークの有無
    case Check(Bool)
    /// スイッチを配置する
    /// - parameter (Bool): スイッチのON/OFF
    case Switch(Bool)
    /// バッジを配置する
    /// - parameter (String): バッジに表示する文字列
    /// - parameter (Bool) detail: 詳細遷移用インジケータを表示するかどうか
    case Badge(String, detail: Bool)
    
    /// Noneかどうか
    private var isNone: Bool { switch self { case .None: return true; default: return false } }
    /// Textかどうか
    private var isText: Bool { switch self { case .Text: return true; default: return false } }
    /// Checkかどうか
    private var isCheck: Bool { switch self { case .Check: return true; default: return false } }
    /// Switchかどうか
    private var isSwitch: Bool { switch self { case .Switch: return true; default: return false } }
    /// Badgeかどうか
    private var isBadge: Bool { switch self { case .Badge: return true; default: return false } }
}

// MARK: - NBSettingDefinition -

/// 設定項目の定義と選択時の処理を行うクラス
public class NBSettingDefinition: NSObject {
    
    /// 設定ビューコントローラの参照
    public weak var settingViewController: NBSettingViewController?
    
    /// イニシャライザ
    /// - parameter settingViewController: 設定ビューコントローラの参照
    public init(_ settingViewController: NBSettingViewController? = nil) {
        super.init()
        self.settingViewController = settingViewController
    }
    
    /// 設定項目の定義を行う(継承先でオーバライドして定義を行うこと)
    /// - returns: 設定セクションオブジェクトの配列
    public func define() -> [NBSettingSection] {
        return []
    }
    
    /// 設定ビューコントローラの管理するテーブルビューの再描画を行う
    /// - parameter redefinition: 設定項目定義から行うかどうか
    public func reload(redefinition: Bool = false) {
        self.settingViewController?.reload(redefinition)
    }
    
    /// 設定ビューコントローラの管理するテーブルビューの参照
    public var tableView: UITableView? {
        return self.settingViewController?.tableView
    }
}

// MARK: - NBSettingSection -

/// 設定セクションオブジェクトクラス
public class NBSettingSection {
    
    /// ユーザによる操作が行われた時に呼ばれるハンドラ
    public typealias ActionHandler = ((NBSettingSection) -> Void)
    
    /// セクションタイトル
    public private(set) var title = ""
    
    /// セクション種別
    public private(set) var sectionType = NBSettingSectionType.Default
    
    /// セクションに所属する行
    private var rows = [NBSettingRow]()
    
    /// ユーザによる操作が行われた時に呼ばれるハンドラ
    private var actionHandler: ActionHandler?
    
    /// セクションの挙動や表示を変更するためのオプション
    private var options: NBSettingViewControllerOptions?
    
    // MARK: イニシャライザ
    
    /// イニシャライザ
    /// - parameter title: セクションタイトル
    public init(_ title: String) {
        self.title = title
    }
    
    // MARK: 行の追加
    
    /// 行を追加する
    /// - parameter row: 設定行オブジェクト
    /// - returns: 自身の参照
    public func row(row: NBSettingRow) -> Self {
        self.rows.append(row)
        return self
    }
    
    /// 行をクロージャを使用して追加する
    /// - parameter closure: 設定行オブジェクトを返却するクロージャ
    /// - returns: 自身の参照
    public func row(closure: Void -> NBSettingRow) -> Self {
        return self.row(closure())
    }
    
    /// 複数の行を追加する
    /// - parameter rows: 設定行オブジェクトの配列
    /// - returns: 自身の参照
    public func rows(rows: [NBSettingRow]) -> Self {
        self.rows.appendContentsOf(rows)
        return self
    }
    
    /// 複数の行をクロージャを使用して追加する
    /// - parameter closure: 設定行オブジェクトを配列で返却するクロージャ
    /// - returns: 自身の参照
    public func rows(closure: Void -> [NBSettingRow]) -> Self {
        return self.rows(closure())
    }
    
    // MARK: セクションの設定
    
    /// セクション種別をセットする
    /// - parameter closure: セクション種別を返却するクロージャ
    /// - returns: 自身の参照
    public func typeIs(closure: Void -> (NBSettingSectionType)) -> Self {
        self.sectionType = closure()
        return self
    }
    
    /// セクションごとに挙動や表示を変更するためのオプションをセットする
    /// - parameter closure: セクションの挙動や表示を変更するためのオプションを返すクロージャ
    /// - returns: 自身の参照
    public func customize(closure: NBSettingViewControllerOptions -> (NBSettingViewControllerOptions)) -> Self {
        self.options = closure(NBSettingViewControllerOptions())
        return self
    }
    
    /// ユーザによりセルの選択操作が行われた時に呼ばれるハンドラをセットする
    /// - parameter handler: ユーザによりセルの選択操作が行われた時に呼ばれるハンドラ
    /// - returns: 自身の参照
    public func action(handler: ActionHandler) -> Self {
        self.actionHandler = handler
        return self
    }
    
    // MARK: 値の取得
    
    /// 選択されたインデックス(単一選択用)
    public var selectedIndex: Int {
        return self.sectionType.selectedIndecies.first ?? -1
    }
    
    /// 選択されたインデックスの配列(複数選択用)
    public var selectedIndecies: [Int] {
        return self.sectionType.selectedIndecies
    }
}


// MARK: - NBSettingRow -

/// 設定項目行オブジェクトクラス
public class NBSettingRow: NSObject {
    
    /// ユーザによる操作が行われた時に呼ばれるハンドラ
    public typealias ActionHandler = ((NBSettingRow) -> Void)
    
    /// 設定項目名(タイトル)
    public private(set) var title = ""
    
    /// アイコン画像
    public private(set) var iconImage: UIImage?
    
    /// 右側のコンポーネント種別
    public private(set) var rightType = NBSettingRightType.None
    
    /// 左側のコンポーネント種別
    public private(set) var leftType  = NBSettingLeftType.Plain
    
    /// ユーザによる操作が行われた時に呼ばれるハンドラ
    private var actionHandler: ActionHandler?
    
    /// 行の挙動や表示を変更するためのオプション
    private var options: NBSettingViewControllerOptions?
    
    // MARK: イニシャライザ
    
    /// イニシャライザ
    /// - parameter title: 設定項目名
    public init(_ title: String) {
        self.title = title
    }
    
    // MARK: 行の設定
    
    /// 左側のコンポーネント種別をセットする
    /// - parameter closure: 左側のコンポーネント種別を返却するクロージャ
    /// - returns: 自身の参照
    public func leftIs(closure: Void -> (NBSettingLeftType)) -> Self {
        self.leftType = closure()
        return self
    }
    
    /// 右側のコンポーネント種別をセットする
    /// - parameter closure: 右側のコンポーネント種別を返却するクロージャ
    /// - returns: 自身の参照
    public func rightIs(closure: Void -> (NBSettingRightType)) -> Self {
        self.rightType = closure()
        return self
    }
    
    /// アイコン画像をセットする
    /// - parameter closure: アイコン画像を返却するクロージャ
    /// - returns: 自身の参照
    public func iconImageIs(closure: Void -> (UIImage?)) -> Self {
        self.iconImage = closure()
        return self
    }
    
    /// 行ごとに挙動や表示を変更するためのオプションをセットする
    /// - parameter closure: 行の挙動や表示を変更するためのオプションを返すクロージャ
    /// - returns: 自身の参照
    public func customize(closure: NBSettingViewControllerOptions -> (NBSettingViewControllerOptions)) -> Self {
        self.options = closure(NBSettingViewControllerOptions())
        return self
    }
    
    /// セルの選択/スイッチ操作/文字入力などの
    /// ユーザによる操作が行われた時に呼ばれるハンドラをセットする
    /// - parameter handler: ユーザによる操作が行われた時に呼ばれるハンドラ
    /// - returns: 自身の参照
    public func action(handler: ActionHandler) -> Self {
        self.actionHandler = handler
        return self
    }
    
    // MARK: 値の取得
    
    /// スイッチ/チェックのブール値
    public var boolValue: Bool {
        switch self.rightType {
        case let .Check(v):  return v
        case let .Switch(v): return v
        default: return false
        }
    }
    
    /// テキストフォーム入力値
    public var inputValue: String {
        switch self.leftType {
        case let .TextField(v): return v
        default: return ""
        }
    }
}

// MARK: - NBSettingViewController -

/// 設定ビューコントローラ
public class NBSettingViewController: NBViewController, UITableViewDelegate, UITableViewDataSource {
    
    /// テーブルビュー
    @IBOutlet public weak var tableView: UITableView!
    
    /// カスタマイズ用オプション
    public var options: NBSettingViewControllerOptions {
        return NBSettingViewControllerOptions()
    }
    
    /// 設定項目定義オブジェクト
    public var definition = NBSettingDefinition() {
        didSet {
            if self.isViewLoaded() {
                self.reload(true)
            }
        }
    }
    
    /// セクションの配列
    private var sections = [NBSettingSection]()
    
    // MARK: ライフサイクル
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate            = self
        self.tableView.dataSource          = self
        self.tableView.keyboardDismissMode = .OnDrag
        self.tableView.separatorStyle      = .None
        self.tableView.registerClass(NBSettingCell.self, forCellReuseIdentifier: "cell")
        
        self.reload(true)
    }
    
    // MARK: テーブルビュー処理
    
    /// テーブルビューの再描画を行う
    /// - parameter redefinition: 設定項目定義から行うかどうか
    public func reload(redefinition: Bool = false) {
        if redefinition {
            self.sections = self.definition.define()
        }
        self.tableView.reloadData()
    }
    
    /// セクション数
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    /// 行数
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rows.count
    }
    
    /// セル
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NBSettingCell
        
        cell.settingViewController = self
        cell.indexPath = indexPath
        cell.setup()
        
        return cell
    }
    
    /// 選択時
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let section = self.sections[indexPath.section]
        let row     = section.rows[indexPath.row]
        
        switch section.sectionType {
        case .Default:
            switch row.leftType {
            case .Plain:
                switch row.rightType {
                case .Check:
                    self.didSelectOnCheckRow(row)
                case .None, .Text, .Badge:
                    row.actionHandler?(row)
                default:break
                }
            default:break
            }
        case .SingleSelect:
            self.didSelectOnSingleSelectSection(indexPath.row, section: section)
        case .MultiSelect:
            self.didSelectOnMultiSelectSection(indexPath.row, section: section)
        }
    }
    
    /// ヘッダビュー
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = self.sections[section]
        if !section.title.isEmpty {
            return NBTableExternalView(text: section.title, tableView: tableView, opt: self.options.headerViewOptions)
        }
        return nil
    }
    
    /// ヘッダの高さ
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let view = tableView.delegate?.tableView?(tableView, viewForHeaderInSection: section) {
            return crH(view.frame)
        }
        return 0.0
    }
    
    // MARK: 選択時処理
    
    /// チェック用セルが選択された時
    /// - parameter row: 行オブジェクト
    private func didSelectOnCheckRow(row: NBSettingRow) {
        row.rightType = .Check(!row.boolValue) // 値を反転
        row.actionHandler?(row)
        self.reload()
    }
    
    /// 単数選択セクションのセルが選択された時
    /// - parameter rowIndex: 行インデックス
    /// - parameter section: セクションオブジェクト
    private func didSelectOnSingleSelectSection(rowIndex: Int, section: NBSettingSection) {
        section.sectionType = .SingleSelect(rowIndex)
        section.actionHandler?(section)
        self.reload()
    }
    
    /// 複数選択可能セクションのセルが選択された時
    /// - parameter rowIndex: 行インデックス
    /// - parameter section: セクションオブジェクト
    private func didSelectOnMultiSelectSection(rowIndex: Int, section: NBSettingSection) {
        var indecies = section.sectionType.selectedIndecies
        if let index = indecies.indexOf(rowIndex) {
            indecies.removeAtIndex(index)
        } else {
            indecies.append(rowIndex)
        }
        section.sectionType = .MultiSelect(indecies)
        section.actionHandler?(section)
        self.reload()
    }
}

// MARK: - NBSettingCell -

/// 設定ビューコントローラ用テーブルセルクラス
public class NBSettingCell: UITableViewCell, UITextFieldDelegate {
    
    /// 管理元の設定ビューコントローラ
    private weak var settingViewController: NBSettingViewController!
    
    /// インデックパス
    private var indexPath: NSIndexPath!
    
    /// セクションオブジェクト
    private var section: NBSettingSection {
        return self.settingViewController.sections[self.indexPath.section]
    }
    
    /// 行オブジェクト
    private var row: NBSettingRow {
        return self.section.rows[self.indexPath.row]
    }
    
    /// セクション種別
    private var sectionType: NBSettingSectionType {
        return self.section.sectionType
    }
    
    /// 左側のコンポーネント種別
    private var leftType: NBSettingLeftType {
        return self.row.leftType
    }
    
    /// 右側のコンポーネント種別
    private var rightType: NBSettingRightType {
        return self.row.rightType
    }
    
    /// 設定項目名(メインラベルの文字列)
    private var title: String {
        return self.row.title
    }
    
    /// アイコン画像
    private var iconImage: UIImage? {
        return self.row.iconImage
    }
    
    /// オプション
    private var options: NBSettingViewControllerOptions {
        if let opt = self.section.options {
            return opt
        } else if let opt = self.row.options {
            return opt
        } else {
            return self.settingViewController.options
        }
    }
    
    /// テキストフィールド
    private weak var textField: UITextField?
    
    /// バッジ表示用ラベル
    private weak var badge: UILabel?
    
    private var badgeWidthConstraint: NSLayoutConstraint!
    
    // MARK: セットアップ
    
    private var initialized = false
    
    /// 初期化処理を行う
    private func initialize() {
        if self.initialized { return }
        
        self.initializeTextLabel()
        self.initializeDetailTextLabel()
        self.textField = self.buildTextField()
        self.badge     = self.buildBadge()
        
        self.initialized = true
    }
    
    /// セットアップを行う
    private func setup() {
        self.initialize()
        
        /// コンポーネントの基本設定
        self.setupTextLabel()
        self.setupDetailTextLabel()
        self.setupTextField()
        self.setupBadge()
        
        // コンポーネントの可視/非可視
        self.textLabel?.hidden       = !self.textLabelVisibility
        self.detailTextLabel?.hidden = !self.detailTextLabelVisibility
        self.textField?.hidden       = !self.textFieldVisibility
        self.badge?.hidden           = !self.badgeVisibility
        
        // アクセサリ
        self.accessoryView = self.cellAccessoryView
        if self.accessoryView == nil {
            self.accessoryType = self.cellAccessoryType
        }
        
        // 選択スタイル
        self.selectionStyle = self.cellSelectionStyle
        
        // 各コンポーネントの値の更新
        self.updateTextLabelValue()
        self.updateDetailTextLabelValue()
        self.updateTextFieldValue()
        self.updateBadgeValue()
        self.updateIconImage()
        
        // 背景
        self.setTableCellBackgrounView(options: self.options.tableCellBackgrounViewOptions)
    }
    
    // MARK: メインラベル(textLabel)
    
    /// メインラベルの初期設定を行う
    private func initializeTextLabel() {
        guard let v = self.textLabel else { return }
        v.backgroundColor = UIColor.clearColor()
    }
    
    /// メインラベルの基本設定を行う
    private func setupTextLabel() {
        guard var v = self.textLabel else { return }
        v.textColor = self.options.textLabel.textColor
        
        if let proc = self.options.textLabel.customizeProcess {
            v = proc(v)
        }
    }
    
    /// メインラベルの可視/非可視を返却する
    private var textLabelVisibility: Bool {
        return !self.textFieldVisibility
    }
    
    /// メインラベルの表示値を更新する
    private func updateTextLabelValue() {
        self.textLabel?.text = self.title
    }
    
    // MARK: サブラベル(detailTextLabel)
    
    /// サブラベルの初期設定を行う
    private func initializeDetailTextLabel() {
        guard let v = self.detailTextLabel else { return }
        v.backgroundColor = UIColor.clearColor()
    }
    
    /// サブラベルの基本設定を行う
    private func setupDetailTextLabel() {
        guard var v = self.detailTextLabel else { return }
        v.textColor = self.options.detailTextLabel.textColor
        
        if let proc = self.options.detailTextLabel.customizeProcess {
            v = proc(v)
        }
    }
    
    /// サブラベルの可視/非可視を返却する
    private var detailTextLabelVisibility: Bool {
        return (self.sectionType.isDefault && self.leftType.isPlain && self.rightType.isText)
    }
    
    /// サブラベルの表示値を更新する
    private func updateDetailTextLabelValue() {
        self.detailTextLabel?.text = self.detailTextLabelValue
    }
    
    /// サブラベルの値
    private var detailTextLabelValue: String {
        switch self.rightType {
        case let .Text(text, detail: _): return text;
        default: return ""
        }
    }
    
    // MARK: テキストフィールド
    
    /// テキストフィールドを生成する
    /// - returns: 生成したテキストフィールド
    private func buildTextField() -> UITextField {
        let cv = self.contentView
        let v = UITextField()
        v.parent = cv
        v.returnKeyType   = .Done
        v.clearButtonMode = .WhileEditing
        v.addTarget(self, action: Selector("didEditingChangeTextField:"), forControlEvents: .EditingChanged)
        
        v.prepareConstraints()
        cv.addConstraints([
            Constraint(v, .Leading,  to: cv, .Leading,  20),
            Constraint(v, .Trailing, to: cv, .Trailing, -8),
            Constraint(v, .CenterY,  to: cv, .CenterY,   0),
            ]
        )
        
        return v
    }
    
    /// テキストフィールドの基本設定をする
    private func setupTextField() {
        guard var v = self.textField else { return }
        
        v.textColor = self.options.textField.textColor
        v.delegate  = self.options.textField.delegate ?? self
        
        if let proc = self.options.textField.customizeProcess {
            v = proc(v)
        }
    }
    
    /// テキストフィールドの可視/非可視を返却する
    private var textFieldVisibility: Bool {
        return (self.sectionType.isDefault && self.leftType.isTextField)
    }
    
    /// テキストフィールドの表示値を更新する
    private func updateTextFieldValue() {
        self.textField?.placeholder = self.title
        self.textField?.text        = self.textFieldValue
    }
    
    /// テキストフィールドの値
    private var textFieldValue: String {
        switch self.leftType {
        case let .TextField(text): return text;
        default: return ""
        }
    }
    
    /// テキストフィールドの値が変更されるごとに呼ばれる
    /// - parameter sender: テキストフィールド
    @objc private func didEditingChangeTextField(sender: UITextField) {
        self.row.leftType = .TextField(sender.text ?? "")
        self.row.actionHandler?(self.row)
    }
    
    /// キーボードリターンキー押下時
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: バッジ
    
    /// バッジを生成する
    /// - returns: 生成したバッジ用ラベル
    private func buildBadge() -> UILabel {
        let cv = self.contentView
        let v = UILabel()
        v.parent = cv
        v.textAlignment = .Center
        v.clipsToBounds = true
        
        v.prepareConstraints()
        cv.addConstraints([
            Constraint(v, .Trailing, to: cv,  .Trailing, -8),
            Constraint(v, .CenterY,  to: cv,  .CenterY,   0),
            Constraint(v, .Height,   to: nil, .Height,   20, relate: .GreaterThanOrEqual),
            ]
        )
        self.badgeWidthConstraint = Constraint(v, .Width, to: nil, .Width, 0, relate: .GreaterThanOrEqual)
        self.addConstraint(self.badgeWidthConstraint)
        
        return v
    }
    
    /// バッジの基本設定を行う
    private func setupBadge() {
        guard var v = self.badge else { return }
        
        v.textColor             = self.options.badge.textColor
        v.layer.backgroundColor = self.options.badge.badgeColor.CGColor
        v.layer.cornerRadius    = self.options.badge.cornerRadius
        
        self.badgeWidthConstraint.constant = self.options.badge.minimumWidth
        
        if let proc = self.options.badge.customizeProcess {
            v = proc(v)
        }
    }
    
    /// バッジの可視/非可視を返却する
    private var badgeVisibility: Bool {
        return (self.sectionType.isDefault && self.leftType.isPlain && self.rightType.isBadge)
    }
    
    /// バッジの表示値を更新する
    private func updateBadgeValue() {
        self.badge?.text = self.badgeValue
    }
    
    /// バッジの値
    private var badgeValue: String {
        switch self.rightType {
        case let .Badge(text, detail: _): return text;
        default: return ""
        }
    }
    
    // MARK: スイッチ
    
    /// スイッチを生成して返却する
    /// - parameter on: スイッチのON/OFF
    /// - returns: スイッチ
    private func buildSwitch(on: Bool) -> UISwitch {
        var v = UISwitch()
        v.addTarget(self, action: Selector("didValueChangeSwitch:"), forControlEvents: .ValueChanged)
        v.on          = on
        v.tintColor   = self.options.switcher.tintColor
        v.onTintColor = self.options.switcher.onTintColor
        
        if let proc = self.options.switcher.customizeProcess {
            v = proc(v)
        }
        
        return v
    }
    
    /// スイッチの値が変更された時
    /// - parameter sender: スイッチ
    @objc private func didValueChangeSwitch(sender: UISwitch) {
        self.row.rightType = .Switch(sender.on)
        self.row.actionHandler?(self.row)
    }
    
    // MARK: アイコン画像
    
    /// アイコンイメージビューの画像を更新する
    private func updateIconImage() {
        self.imageView?.contentMode = .ScaleAspectFit
        self.imageView?.image = self.iconImage
    }
    
    // MARK: チェックマーク
    
    /// チェックマーク用画像ビューを生成する
    private func buildCheckmarkView(value: Bool) -> UIView? {
        let image: UIImage
        if value {
            guard let on = self.options.check.onImage else { return nil }
            image = on
        } else {
            guard let off = self.options.check.offImage else { return nil }
            image = off
        }
        
        let cv = self
        var v = UIImageView()
        v.parent = cv
        v.image = image
        v.contentMode = .ScaleAspectFit
        
        v.prepareConstraints()
        cv.addConstraints([
            Constraint(v, .Trailing, to: cv,  .Trailing, -16),
            Constraint(v, .CenterY,  to: cv,  .CenterY,    0),
            Constraint(v, .Height,   to: nil, .Height,    20,  relate: .GreaterThanOrEqual),
            Constraint(v, .Width,    to: nil, .Width,     20,  relate: .GreaterThanOrEqual),
            ]
        )
        
        if let proc = self.options.check.customizeProcess {
            v = proc(v)
        }
        return v
    }
    
    /// バッジの可視/非可視を返却する
    private var checkmarkVisibility: Bool {
        return (self.sectionType.isDefault && self.leftType.isPlain && self.rightType.isBadge)
    }
    
    /// バッジの表示値を更新する
    private func updateCheckmarkValue() {
        self.badge?.text = self.badgeValue
    }
    
    /// 適切なチェックマーク項目のアクセサリタイプを返却する
    private func checkmarkAccessoryType(value: Bool) -> UITableViewCellAccessoryType {
        return value && self.options.check.onImage == nil ? .Checkmark : .None
    }
    
    /// バッジの値
    private var checkValue: String {
        switch self.rightType {
        case let .Badge(text, detail: _): return text;
        default: return ""
        }
    }
    
    // MARK: 単数/複数選択セクション
    
    /// 自身の行インデックスが複数選択セクションにおいて選択状態であるかどうかを返す
    /// - parameter index: 行インデックス
    /// - returns: 選択状態であるかどうか
    private func isSelected(index: Int) -> Bool {
        return index == self.indexPath.row
    }
    
    /// 自身の行インデックスが複数選択セクションにおいて選択状態であるかどうかを返す
    /// - parameter indecies: 行インデックスの配列
    /// - returns: 選択状態であるかどうか
    private func isSelected(indecies: [Int]) -> Bool {
        return indecies.contains(self.indexPath.row)
    }
    
    // MARK: 種別に基づくプロパティ値の分岐
    
    /// セルのアクセサリタイプ
    private var cellAccessoryType: UITableViewCellAccessoryType {
        switch self.sectionType {
        case .Default:
            switch self.leftType {
            case .Plain:
                switch self.rightType {
                case let .Text(_, detail: v):  return v ? .DisclosureIndicator : .None;
                case let .Badge(_, detail: v): return v ? .DisclosureIndicator : .None;
                case let .Check(v): return self.checkmarkAccessoryType(v)
                default: return .None
                }
            case .TextField:
                return .None
            }
        case let .SingleSelect(index):
            return self.checkmarkAccessoryType(self.isSelected(index))
        case let .MultiSelect(indecies):
            return self.checkmarkAccessoryType(self.isSelected(indecies))
        }
    }
    
    /// セルのアクセサリタイプ
    private var cellAccessoryView: UIView? {
        switch self.sectionType {
        case .Default:
            switch self.leftType {
            case .Plain:
                switch self.rightType {
                case let .Switch(v):
                    return self.buildSwitch(v)
                case let .Check(v):
                    return self.buildCheckmarkView(v)
                default: return nil
                }
            default: return nil
            }
        case let .SingleSelect(index):
            return self.buildCheckmarkView(self.isSelected(index))
        case let .MultiSelect(indecies):
            return self.buildCheckmarkView(self.isSelected(indecies))
        }
    }
    
    /// セルの選択スタイル
    private var cellSelectionStyle: UITableViewCellSelectionStyle {
        switch self.sectionType {
        case .Default:
            switch self.leftType {
            case .Plain:
                switch self.rightType {
                case .Switch: return .None
                default: return .Default
                }
            case .TextField:
                return .None
            }
        default: return .Default
        }
    }
    
    // MARK: イニシャライザ
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value1, reuseIdentifier: reuseIdentifier) // 右に文字を表示
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - NBSettingViewControllerOptions -

/// NBSettingViewControllerのオプション
public struct NBSettingViewControllerOptions {
    
    // MARK: メインラベル(textLabel)
    
    /// メインラベル(textLabel)設定項目
    public struct TextLabel {
        /// 文字色
        public var textColor = UIColor.darkTextColor()
        /// カスタマイズ用クロージャ
        public var customizeProcess: (UILabel -> UILabel)?
    }
    /// メインラベル設定
    public var textLabel = NBSettingViewControllerOptions.TextLabel()
    
    // MARK: テキストフィールド
    
    /// テキストフィールド設定項目
    public struct TextField {
        /// 文字色
        public var textColor = UIColor.darkTextColor()
        /// デリゲート
        public weak var delegate: UITextFieldDelegate?
        /// カスタマイズ用クロージャ
        public var customizeProcess: (UITextField -> UITextField)?
    }
    /// テキストフィールド設定
    public var textField = NBSettingViewControllerOptions.TextField()
    
    // MARK: サブラベル(detailTextLabel)
    
    /// サブラベル(detailTextLabel)設定項目
    public struct DetailTextLabel {
        /// 文字色
        public var textColor = UIColor.grayColor()
        /// カスタマイズ用クロージャ
        public var customizeProcess: (UILabel -> UILabel)?
    }
    /// サブラベル(detailTextLabel)設定
    public var detailTextLabel = NBSettingViewControllerOptions.DetailTextLabel()
    
    // MARK: バッジ
    
    /// バッジ設定項目
    public struct Badge {
        /// バッジの最小幅
        public var minimumWidth: CGFloat = 30
        /// バッジ色(背景色)
        public var badgeColor = UIColor.grayColor()
        /// バッジの文字色
        public var textColor = UIColor.whiteColor()
        /// バッジの角丸半径
        public var cornerRadius: CGFloat = 10
        /// カスタマイズ用クロージャ
        public var customizeProcess: (UILabel -> UILabel)?
    }
    /// バッジ設定
    public var badge = NBSettingViewControllerOptions.Badge()
    
    // MARK: スイッチ
    
    /// スイッチ設定項目
    public struct Switcher {
        /// OFF側の色
        public var tintColor: UIColor?
        /// ON側の色
        public var onTintColor: UIColor?
        /// カスタマイズ用クロージャ
        public var customizeProcess: (UISwitch -> UISwitch)?
    }
    /// スイッチ設定(switchは予約後なのでswitcher)
    public var switcher = NBSettingViewControllerOptions.Switcher()
    
    // MARK: チェックマーク
    
    /// チェックマーク設定項目
    public struct Checkmark {
        /// チェックマークON時の画像
        public var onImage: UIImage? = nil
        /// チェックマークOFF時の画像
        public var offImage: UIImage? = nil
        /// カスタマイズ用クロージャ
        public var customizeProcess: (UIImageView -> UIImageView)?
    }
    /// チェックマーク設定
    public var check = NBSettingViewControllerOptions.Checkmark()
    
    /// テーブルビュー背景色のオプション
    public var tableCellBackgrounViewOptions = NBTableCellBackgrounViewOptions()
    
    /// ヘッダのオプション
    public var headerViewOptions = NBTableExternalViewOptions()
    
    public init() {}
}
