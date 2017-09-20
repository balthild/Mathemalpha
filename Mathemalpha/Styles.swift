//
//  Styles.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 19/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

final class Styles {

    private static let schemesFont = NSFont.systemFont(ofSize: 14)
    private static let charactersFont = NSFont(name: "Symbol", size: 18)
    private static let textColor = NSColor(white: 0, alpha: 1)
    private static let textStyle: NSMutableParagraphStyle = {
        let textStyle = NSMutableParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = .center
        return textStyle
    }()

    static let schemesTextAttributes: [String : Any] = [
        NSFontAttributeName: schemesFont,
        NSForegroundColorAttributeName: textColor,
        NSParagraphStyleAttributeName: textStyle
    ]
    static let charactersTextAttributes: [String : Any] = [
        NSFontAttributeName: charactersFont,
        NSForegroundColorAttributeName: textColor,
        NSParagraphStyleAttributeName: textStyle
    ]

    private(set) static var schemesSelectedTextAttributes: [String : Any] = [
        NSFontAttributeName: schemesFont,
        NSForegroundColorAttributeName: schemesSelectedTextColor,
        NSParagraphStyleAttributeName: textStyle
    ]
    private(set) static var charactersSelectedTextAttributes: [String : Any] = [
        NSFontAttributeName: charactersFont,
        NSForegroundColorAttributeName: charactersSelectedTextColor,
        NSParagraphStyleAttributeName: textStyle
    ]

    private(set) static var schemesTileColor = NSColor(white: 0, alpha: 0.1)
    private(set) static var charactersTileColor = NSColor(red: 0.011764706, green: 0.662745098, blue: 0.956862745, alpha: 1)

    private static var _schemesSelectedTextColor = NSColor(white: 0, alpha: 1)
    private static var schemesSelectedTextColor: NSColor {
        get {
            return _schemesSelectedTextColor
        }
        set(newColor) {
            _schemesSelectedTextColor = newColor
            schemesSelectedTextAttributes.updateValue(newColor, forKey: NSForegroundColorAttributeName)
        }
    }

    private static var _charactersSelectedTextColor = NSColor(white: 1, alpha: 1)
    private static var charactersSelectedTextColor: NSColor {
        get {
            return _charactersSelectedTextColor
        }
        set(newColor) {
            _charactersSelectedTextColor = newColor
            charactersSelectedTextAttributes.updateValue(newColor, forKey: NSForegroundColorAttributeName)
        }
    }

    static func flipFocused() {
        (schemesTileColor, charactersTileColor) = (charactersTileColor, schemesTileColor)
        (schemesSelectedTextColor, charactersSelectedTextColor) = (charactersSelectedTextColor, schemesSelectedTextColor)
    }

}
