//
//  MenuCotroller.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 12/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

class MenuCotroller: NSObject {

    @IBOutlet weak var menu: NSMenu!

    var statusItem: NSStatusItem!

    override func awakeFromNib() {
        statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

        statusItem.image = NSImage(named: "StatusIcon")
        statusItem.image?.size = NSSize(width: 18, height: 18)
        statusItem.image?.isTemplate = true

        statusItem.menu = menu
        statusItem.length = 24
        statusItem.highlightMode = true

    }

    @IBAction func terminate(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }

}
