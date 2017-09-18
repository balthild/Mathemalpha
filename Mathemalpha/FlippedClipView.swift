//
//  FlippedClipView.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 17/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

class FlippedClipView: NSClipView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }

    override var isFlipped: Bool {
        return true
    }
}
