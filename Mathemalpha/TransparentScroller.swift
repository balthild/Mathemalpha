//
//  TransparentScroller.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 17/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

class TransparentScroller: NSScroller {

    override func draw(_ dirtyRect: NSRect) {
        drawKnob()
    }

}
