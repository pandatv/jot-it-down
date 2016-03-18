//
//  JotTableViewCell.swift
//  Jot It Down
//
//  Created by Andrey Baranov on 03/02/2016.
//  Copyright © 2016 PaPaPanda. All rights reserved.
//

import UIKit


class JotTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var createdAtLabel: UILabel!
    
    @IBOutlet weak var bodyTextView: UITextView!

    @IBOutlet weak var tickbox: UIButton!

    @IBAction func toggleTickbox(sender: AnyObject) {
        jot!.done = !jot!.done
        updateUI()
    }
    
    var jot: Jot? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        
        guard let jot = jot else {
            titleLabel.text = nil
            bodyTextView.text = ""
            createdAtLabel.text = ""
            return
        }
        
        titleLabel.text = jot.title
        bodyTextView.text = jot.body
        bodyTextView.font = UIFont.systemFontOfSize(16.0)
        bodyTextView.backgroundColor = UIColor.clearColor()
        
        // TODO: Cap on number of lines 
        
        tickbox.hidden = true
        
        if jot.type == .Checkmark {
            tickbox.hidden = false
            tickbox.selected = jot.done
        }
    
        if let color = jot.tagColor {
            switch color {
            case .None: backgroundColor = UIColor.whiteColor()
            case .Red: backgroundColor = Jot.ColorPalette.Red
            case .Green: backgroundColor = Jot.ColorPalette.Green
            case .Blue: backgroundColor = Jot.ColorPalette.Blue
            }
        } else {
            backgroundColor = UIColor.whiteColor() 
        }
        
        let dateFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        
        // Adjust date format
        if calendar.compareDate(jot.createdAt, toDate: NSDate(), toUnitGranularity: .Day) == NSComparisonResult.OrderedSame {
             dateFormatter.dateFormat = "HH:mm:ss"
        } else {
            dateFormatter.dateFormat = "EEEE, MMM d"
        }

        createdAtLabel.text = dateFormatter.stringFromDate(jot.createdAt)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    /*
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */

}
