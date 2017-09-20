//
//  CharacterItemView.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 20/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

class CharacterItemView: NSView {

    var char: Character?
    var selected: Bool = false

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let string = NSString(string: String(char!))
        let textHeight = string.size(withAttributes: Styles.charactersTextAttributes).height
        let textRect = NSMakeRect(0, (32 - textHeight) / 2, 32, textHeight)

        if selected {
            let tileRect = NSMakeRect(0, 0, 32, 32)
            let path = NSBezierPath(roundedRect: tileRect, xRadius: 4, yRadius: 4)

            Styles.charactersTileColor.set()
            path.fill()

            string.draw(in: textRect, withAttributes: Styles.charactersSelectedTextAttributes)
        } else {
            string.draw(in: textRect, withAttributes: Styles.charactersTextAttributes)
        }
    }

}
