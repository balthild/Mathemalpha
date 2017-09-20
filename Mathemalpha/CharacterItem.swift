//
//  CharacterItemViewController.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 20/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

class CharacterItem: NSCollectionViewItem {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override var representedObject: Any? {
        get {
            return super.representedObject
        }
        set {
            (view as! CharacterItemView).char = newValue as? Character
            super.representedObject = newValue
        }
    }
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            super.isSelected = newValue

            (view as! CharacterItemView).selected = newValue
            (view as! CharacterItemView).needsDisplay = true
        }
    }
}
