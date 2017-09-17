//
//  SettingsWindowController.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 14/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa
import Magnet
import KeyHolder

class SettingsWindowController: NSWindowController {

    let appDelegate: AppDelegate = NSApp.delegate as! AppDelegate

    @IBOutlet weak var recordView: RecordView!

    override func windowDidLoad() {
        super.windowDidLoad()

        recordView.keyCombo = KeyEvent.getDefaultKeyCombo()
        recordView.delegate = appDelegate.keyEvent

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

}
