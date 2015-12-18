// =============================================================================
// PHOTTY
// Copyright (C) 2015 NeroBlu. All rights reserved.
// =============================================================================
import UIKit

/// UITextFieldの拡張
public extension UITextField {
    
    /// プレースホルダの文字色
    @IBInspectable public var placeholderColor : UIColor? {
        get {
            var r : NSRange? = NSMakeRange(0, 1)
            guard
                let ap = self.attributedPlaceholder,
                let ret = ap.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: &r!) as? UIColor
                else {
                    return nil
            }
            return ret
        }
        set(v) {
            guard let color = v, font = self.font else {
                return
            }
            let attributes: [String : AnyObject] = [
                NSForegroundColorAttributeName : color,
                NSFontAttributeName            : font,
            ]
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: attributes)
        }
    }
}
