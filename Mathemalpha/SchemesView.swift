//
//  TypesView.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 18/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

class SchemesView: NSView {

    let textFont = NSFont.systemFont(ofSize: 14)
    let textColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1)
    let textStyle = NSMutableParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
    let textAttributes: [String : Any]!

    var highlightColor = NSColor(red: 0.011764706, green: 0.662745098, blue: 0.956862745, alpha: 1)
    var textColorHighlighted = NSColor(red: 1, green: 1, blue: 1, alpha: 1)
    var types: Array<NSString> = [
        "Latin",
        "Greek",
        "Cyrillic"
    ]
    var selected = 0

    required init?(coder aDecoder: NSCoder) {
        textStyle.alignment = .center
        textAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: textStyle
        ]

        super.init(coder: aDecoder)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        var y: CGFloat = 0

        for (i, type) in types.enumerated() {
            let rect = NSMakeRect(0, y, 140, 24)

            let marginTop = (24 - type.size(withAttributes: textAttributes).height) / 2
            let textRect = NSMakeRect(10, y + marginTop, 120, 24 - marginTop)

            if i == selected {
                let path = NSBezierPath(roundedRect: rect, xRadius: 4, yRadius: 4)

                highlightColor.set()
                path.fill()

                type.draw(in: textRect, withAttributes: [
                    NSFontAttributeName: textFont,
                    NSForegroundColorAttributeName: textColorHighlighted,
                    NSParagraphStyleAttributeName: textStyle
                ])
            } else {
                type.draw(in: textRect, withAttributes: textAttributes)
            }

            y += 24
        }
    }

    override var isFlipped: Bool {
        return true
    }
    
}
