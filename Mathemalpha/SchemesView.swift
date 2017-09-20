//
//  TypesView.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 18/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

class SchemesView: NSView {

    var selected = 0

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        var y: CGFloat = 0

        for (i, type) in Schemes.schemeNames.enumerated() {
            let rect = NSMakeRect(0, y, 140, 24)

            let marginTop = (24 - type.size(withAttributes: Styles.schemesTextAttributes).height) / 2
            let textRect = NSMakeRect(10, y + marginTop, 120, 24 - marginTop)

            if i == selected {
                let path = NSBezierPath(roundedRect: rect, xRadius: 4, yRadius: 4)

                Styles.schemesTileColor.set()
                path.fill()

                type.draw(in: textRect, withAttributes: Styles.schemesSelectedTextAttributes)
            } else {
                type.draw(in: textRect, withAttributes: Styles.schemesTextAttributes)
            }

            y += 24
        }
    }

    override var isFlipped: Bool {
        return true
    }
    
}
