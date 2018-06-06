//
//  UIFontExtension.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 6/5/18.
//  Copyright © 2018 Type II Software. All rights reserved.
//

import UIKit

extension UIFont {
    func withTraits(traits:UIFontDescriptorSymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
