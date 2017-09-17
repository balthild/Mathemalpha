//
//  KeyEvent.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 12/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import CoreGraphics
import Cocoa
import Carbon.HIToolbox.Events
import Magnet
import KeyHolder

class KeyEvent: NSObject {

    let eventSource = CGEventSource(stateID: .privateState)
    let appDelegate: AppDelegate = NSApp.delegate as! AppDelegate

    var hotKey: HotKey!

    override init() {
        super.init()

        let keyCombo = KeyEvent.getDefaultKeyCombo()
        hotKey = HotKey(identifier: "ShowWindow", keyCombo: keyCombo, target: appDelegate.mainWindowController, action: #selector(MainWindowController.showAndOrderFront))
        hotKey.register()

        NSEvent.addLocalMonitorForEvents(matching: NSEventMask.keyDown, handler: {(e: NSEvent) -> NSEvent? in
            if e.isARepeat {
                return e
            }

            switch (e.keyCode, e.modifierFlags.intersection(.deviceIndependentFlagsMask)) {
            case (53, []), (13, [.command]):
                // Esc, Cmd + W
                self.appDelegate.mainWindowController.close()

            case (49, []):
                // Space
                self.appDelegate.mainWindowController.window?.orderOut(self)
                self.sendChar("ℳ");
                self.appDelegate.mainWindowController.window?.makeKeyAndOrderFront(self)

            case (36, []):
                // Enter
                self.appDelegate.mainWindowController.window?.orderOut(self)
                self.sendChar("ℳ");

            case (51, []):
                // Backspace
                self.appDelegate.mainWindowController.window?.orderOut(self)
                self.sendBackspace()
                self.appDelegate.mainWindowController.window?.makeKeyAndOrderFront(self)

            default:
#if DEBUG
                debugPrint(e)
#else
                break
#endif
            }

            return e
        })

#if DEBUG
        NSLog("Added local keyboard event listener")
#endif
    }

    func sendChar(_ str: NSString) {
        let e = CGEvent.init(keyboardEventSource: eventSource, virtualKey: 0, keyDown: true)

        let chars: UnsafeMutablePointer<unichar> = UnsafeMutablePointer.allocate(capacity: 1)
        str.getCharacters(chars)

        e?.keyboardSetUnicodeString(stringLength: 1, unicodeString: chars)
        e?.post(tap: .cghidEventTap)
        e?.type = .keyUp
        e?.post(tap: .cghidEventTap)

#if DEBUG
        NSLog("Sent the first character of text: %@", str)
        debugPrint(Character(UnicodeScalar(chars.pointee)!))
#endif
    }

    func sendBackspace() {
        let e = CGEvent.init(keyboardEventSource: eventSource, virtualKey: 51, keyDown: true)

        e?.post(tap: .cghidEventTap)
        e?.type = .keyUp
        e?.post(tap: .cghidEventTap)

#if DEBUG
        NSLog("Sent a backspace")
#endif
    }

    static func getDefaultKeyCombo() -> KeyCombo {
        if let data = UserDefaults.standard.data(forKey: "keyCombo"), let keyCombo = NSKeyedUnarchiver.unarchiveObject(with: data) as? KeyCombo {
            return keyCombo
        } else {
            // Default is Option + Cmd + Space
            return KeyCombo(keyCode: 49, cocoaModifiers: [.option, .command])!
        }
    }

}

extension KeyEvent: RecordViewDelegate {

    func recordViewShouldBeginRecording(_ recordView: RecordView) -> Bool {
        return true
    }

    func recordView(_ recordView: RecordView, canRecordKeyCombo keyCombo: KeyCombo) -> Bool {
        // You can customize validation
        return true
    }

    func recordViewDidClearShortcut(_ recordView: RecordView) {
#if DEBUG
        NSLog("Clear shortcut")
#endif

        hotKey.unregister()
    }

    func recordViewDidEndRecording(_ recordView: RecordView) {
#if DEBUG
        NSLog("End recording")
#endif
    }

    func recordView(_ recordView: RecordView, didChangeKeyCombo keyCombo: KeyCombo) {
#if DEBUG
        NSLog("Recorded")
#endif

        hotKey.unregister()
        hotKey = HotKey(identifier: "ShowWindow", keyCombo: keyCombo, target: appDelegate.mainWindowController, action: #selector(MainWindowController.showAndOrderFront))
        hotKey.register()

        DispatchQueue.main.async {
            let data = NSKeyedArchiver.archivedData(withRootObject: keyCombo)
            UserDefaults.standard.set(data, forKey: "keyCombo")
            UserDefaults.standard.synchronize()
        }
    }

}
