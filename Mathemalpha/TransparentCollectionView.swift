//
//  TransparentCollectionView.swift
//  Mathemalpha
//
//  Created by Balthild Ires on 20/09/2017.
//  Copyright © 2017 Balthild Ires. All rights reserved.
//

import Cocoa

class TransparentCollectionView: NSCollectionView {

    override var backgroundColors: [NSColor]! {
        get { return [.clear] }
        set { }
    }

}
