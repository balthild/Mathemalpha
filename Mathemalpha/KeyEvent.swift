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

final class KeyEvent {

    fileprivate(set) static var instance: KeyEvent!

    let eventSource = CGEventSource(stateID: .privateState)
    let appDelegate: AppDelegate = NSApp.delegate as! AppDelegate

    var hotKey: HotKey!

    fileprivate init() {
        let keyCombo = KeyEvent.getDefaultKeyCombo()
        hotKey = HotKey(identifier: "ShowWindow", keyCombo: keyCombo, target: appDelegate.mainWindowController, action: #selector(MainWindowController.showAndOrderFront))
        hotKey.register()

        NSEvent.addLocalMonitorForEvents(matching: NSEventMask.keyDown, handler: keyPressed)

#if DEBUG
        NSLog("Added local keyboard event listener")
#endif
    }

    func keyPressed(e: NSEvent) -> NSEvent? {
        if !appDelegate.mainWindowController.shouldHandleKeyEvent {
            return e
        }

        var allowRepeat = false
        var handler: () -> Void = {}

        switch (e.keyCode, e.modifierFlags.intersection(.deviceIndependentFlagsMask)) {
        case (53, []), (13, [.command]):
            // Esc, Cmd + W
            handler = self.appDelegate.mainWindowController.close

        case (49, []):
            // Space
            handler = {
                // We must temporarily hide the window before sending a key event, otherwise
                // the event will be sent to the window itself, which is not expected to
                self.appDelegate.mainWindowController.window?.orderOut(self)
                self.sendChar(self.appDelegate.mainWindowController.getCurrentChar());
                self.appDelegate.mainWindowController.window?.makeKeyAndOrderFront(self)
            }

        case (36, []):
            // Enter
            handler = {
                self.appDelegate.mainWindowController.hide(self)
                self.sendChar(self.appDelegate.mainWindowController.getCurrentChar());
            }

        case (51, []):
            // Backspace
            handler = {
                self.appDelegate.mainWindowController.window?.orderOut(self)
                self.sendBackspace()
                self.appDelegate.mainWindowController.window?.makeKeyAndOrderFront(self)
            }

        case (123...126, _):
            // Arrows
            allowRepeat = true
            handler = {
                self.appDelegate.mainWindowController.navigate(e.keyCode)
            }

        case (48, []):
            // Tab
            handler = self.appDelegate.mainWindowController.flipFocused

        default:
#if DEBUG
            debugPrint(e)
#endif
            return e
        }

        if allowRepeat || !e.isARepeat {
            handler()
        }

        return e
    }

    func sendChar(_ char: Character) {
        let event = CGEvent.init(keyboardEventSource: eventSource, virtualKey: 0, keyDown: true)
        let str = NSString(string: String(char))
        let unicode: UnsafeMutablePointer<unichar> = UnsafeMutablePointer.allocate(capacity: str.length)

        str.getCharacters(unicode)

        event?.keyboardSetUnicodeString(stringLength: str.length, unicodeString: unicode)
        event?.post(tap: .cghidEventTap)
        event?.type = .keyUp
        event?.post(tap: .cghidEventTap)

#if DEBUG
        NSLog("Sent a character: %@", str)
#endif
    }

    func sendBackspace() {
        let event = CGEvent.init(keyboardEventSource: eventSource, virtualKey: 51, keyDown: true)

        event?.post(tap: .cghidEventTap)
        event?.type = .keyUp
        event?.post(tap: .cghidEventTap)

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

    static func initialize() {
        instance = KeyEvent()
    }

    static func stop() {
        instance.hotKey.unregister()
    }

}
