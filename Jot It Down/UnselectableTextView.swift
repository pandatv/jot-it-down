//
//  UnselectableTextView.swift
//  Jot It Down
//
//  Created by Andrey Baranov on 01/03/16.
//  Copyright © 2016 PaPaPanda. All rights reserved.
//

import UIKit

class UnselectableTextView: UITextView {
    override func canBecomeFirstResponder() -> Bool {
        return false 
    }
}
