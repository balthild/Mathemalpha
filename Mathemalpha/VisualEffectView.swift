//
//  VisualEffectView.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 13/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

class VisualEffectView: NSVisualEffectView {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        blurEffect()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        blurEffect()
    }

    func blurEffect() {
        state = .active
        blendingMode = .behindWindow
        material = .mediumLight
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }

}
