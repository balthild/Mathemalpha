//
//  CharactersView.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 17/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

class CharactersView: NSView {

    let textFont = NSFont.systemFont(ofSize: 18)
    let textColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1)
    let textStyle = NSMutableParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
    let textAttributes: [String : Any]!

    var highlightColor = NSColor(red: 0.011764706, green: 0.662745098, blue: 0.956862745, alpha: 1)
    var textColorHighlighted = NSColor(red: 1, green: 1, blue: 1, alpha: 1)
    var sections: Array<String> = [
        "𝓐𝓑𝓒𝓓𝓔𝓕𝓖𝓗𝓘𝓙𝓚𝓛𝓜𝓝𝓞𝓟𝓠𝓡𝓢𝓣𝓤𝓥𝓦𝓧𝓨𝓩",
        "𝓪𝓫𝓬𝓭𝓮𝓯𝓰𝓱𝓲𝓳𝓴𝓵𝓶𝓷𝓸𝓹𝓺𝓻𝓼𝓽𝓾𝓿𝔀𝔁𝔂𝔃",
        "0123456789",
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        "abcdefghijklmnopqrstuvwxyz",
        "+-*/=~!@#$%^&()_",
        "测试汉字"
    ]
    var highlight: (section: Int, index: Int) = (0, 0)

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

        var scrollY: Int = 0
        var sectionY: Int = 0

        for (section, chars) in sections.enumerated() {
            for (index, char) in chars.characters.enumerated() {
                let string = NSString(string: String(char))

                let y = CGFloat((index / 10) * 32 + sectionY)
                let x = CGFloat((index % 10) * 32)
                let rect = NSMakeRect(x, y, 32, 32)

                let marginTop = (32 - string.size(withAttributes: textAttributes).height) / 2
                let textRect = NSMakeRect(x, y + marginTop, 32, 32 - marginTop)

                if section == highlight.section && index == highlight.index {
                    let path = NSBezierPath(roundedRect: rect, xRadius: 4, yRadius: 4)

                    highlightColor.set()
                    path.fill()

                    string.draw(in: textRect, withAttributes: [
                        NSFontAttributeName: textFont,
                        NSForegroundColorAttributeName: textColorHighlighted,
                        NSParagraphStyleAttributeName: textStyle
                    ])
                } else {
                    string.draw(in: textRect, withAttributes: textAttributes)
                }
            }

            sectionY += (chars.characters.count - 1) / 10 * 32 + 40
        }

        frame = NSMakeRect(0, 0, 320, CGFloat(sectionY))
    }

    override var isFlipped: Bool {
        return true
    }
}
