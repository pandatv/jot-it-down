//
//  Jot.swift
//  Jot It Down
//
//  Created by Andrey Baranov on 03/02/2016.
//  Copyright © 2016 PaPaPanda. All rights reserved.
//

import Foundation
import UIKit 


class Jot : NSObject {
    
    struct ColorPalette {
        static let None = UIColor.lightGrayColor()
        static let Red = UIColor(red:1.0, green:0.61, blue:0.61, alpha:1.0)
        static let Green = UIColor(red:0.87, green:1.0, blue:0.72, alpha:1.0)
        static let Blue = UIColor(red:0.49, green:0.66, blue:0.98, alpha:1.0)
    }
    
    enum TagColor {
        case None
        case Red
        case Blue
        case Green
    }
    
    
    enum JotType {
        case Normal
        case Checkmark
    }
    
    var type: JotType?
    
    var tagColor: TagColor?
    
    var done: Bool = false
    
    var createdAt = NSDate()
    var body = " "
    var title: String?
    
    override var description: String {
        return "\(createdAt): \(body)"
    }
    
    init(string: String, title: String?) {
        self.body = string
        if let title = title {
            self.title = title 
        }
        self.type = JotType.Normal
        self.done = false 
    }
}