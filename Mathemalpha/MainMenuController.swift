//
//  MainMenuCotroller.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 12/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

class MainMenuController: NSObject {

    @IBOutlet weak var appDelegate: AppDelegate!
    @IBOutlet weak var menu: NSMenu!

    var statusItem: NSStatusItem!

    override func awakeFromNib() {
        super.awakeFromNib()

        statusItem = NSStatusBar.system().statusItem(withLength: 24)

        statusItem.image = NSImage(named: "StatusIcon")
        statusItem.image?.size = NSSize(width: 18, height: 18)
        statusItem.image?.isTemplate = true

        statusItem.menu = menu
        statusItem.highlightMode = true
    }

    @IBAction func terminate(_ sender: NSMenuItem) {
        NSApp.terminate(self)
    }

    @IBAction func settings(_ sender: NSMenuItem) {
        appDelegate.settingsWindowController.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
    }

}
