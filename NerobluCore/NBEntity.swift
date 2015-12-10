// =============================================================================
// NerobluCore
// Copyright (C) NeroBlu. All rights reserved.
// =============================================================================
import UIKit
import SwiftyJSON

/// エンティティクラス
public class NBEntity {
    public init() {}
}

/// JSONからオブジェクトに変換可能であるインターフェイス
public protocol NBJsonDecodable {
    init?(json: JSON)
}

/// JSONから変更可能なエンティティクラス
public class NBJsonDecodableEntity : NBEntity, NBJsonDecodable {
    
    public required init?(json: JSON) {
        // NOP
    }
}
