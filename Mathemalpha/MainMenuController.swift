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

        statusItem = NSStatusBar.system().statusItem(withLength: 28)

        statusItem.image = NSImage(named: "StatusIcon")
        statusItem.image?.size = NSSize(width: 18, height: 18)
        statusItem.image?.isTemplate = true

        statusItem.menu = menu
        statusItem.highlightMode = true
    }

    @IBAction func terminate(_ sender: NSMenuItem) {
        NSApp.terminate(self)
    }

    @IBAction func reload(_ sender: NSMenuItem) {
        Schemes.load()

        appDelegate.mainWindowController.currentScheme = Schemes.schemes[0]
        appDelegate.mainWindowController.schemesView.selected = 0
        appDelegate.mainWindowController.schemesView.needsDisplay = true

        appDelegate.mainWindowController.collectionView.reloadData()
        appDelegate.mainWindowController.collectionView.deselectAll(self)
        appDelegate.mainWindowController.collectionView.needsDisplay = true
    }

    @IBAction func edit(_ sender: NSMenuItem) {
        NSWorkspace.shared().openFile(Schemes.baseDir)
    }

    @IBAction func settings(_ sender: NSMenuItem) {
        appDelegate.settingsWindowController.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
    }

}
