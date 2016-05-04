//
//  JotInputCell.swift
//  Jot It Down
//
//  Created by Andrey Baranov on 07/02/2016.
//  Copyright © 2016 PaPaPanda. All rights reserved.
//

import UIKit

protocol JotInputCellDelegate: class {
    func jotInputCelldidUpdateTextView(cell: JotInputCell)
    func jotInputCellIsActivated(cell: JotInputCell)
    func jotAddedFromInputCell(cell: JotInputCell)
    
}


class JotInputCell: UITableViewCell, UITextViewDelegate {
    


    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var colorTagButton: UIButton!
    @IBOutlet weak var tickboxSwitch: UISwitch!
    
    
    weak var delegate: JotInputCellDelegate?
    
    let placeholder = "Jot it down!"
    
    var colorSelector: Jot.TagColor = .None
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.delegate = self
        textView.inputAccessoryView = makeKeyboardAccessoryView()
        
        // Color button
        colorTagButton.backgroundColor = UIColor.lightGrayColor()
        colorTagButton.layer.cornerRadius = 3.0
      
        // Make placeholder
        makePlaceholder()
        
        //Set switch to "off"
        tickboxSwitch.setOn(false, animated: false)
        tickboxSwitch.enabled = false 
        
        
     }
    
    @IBAction func colorTagChanged(sender: UIButton) {
        
        textView.becomeFirstResponder()
        
        var color = UIColor()
        
        switch colorSelector {
        case .None:
            colorSelector = .Red
            color = Jot.ColorPalette.Red
        case .Red:
            colorSelector = .Blue
            color = Jot.ColorPalette.Blue
        case .Blue:
            colorSelector = .Green
            color = Jot.ColorPalette.Green
        case .Green:
            colorSelector = .None
            color = Jot.ColorPalette.None
        }
        
        colorTagButton.backgroundColor = color 
        
        
    }
    
    func makePlaceholder() {
        textView.textColor = UIColor.lightGrayColor()
        textView.text = placeholder
    }

    
    func textViewDidEndEditing(textView: UITextView) {
        
        let alphanum = NSCharacterSet.alphanumericCharacterSet()
        let range = textView.text.rangeOfCharacterFromSet(alphanum)
        
        if let _ = range {
            return
        } else {
            makePlaceholder()
        }
    }

    
    func textViewDidChange(textView: UITextView) {
        delegate?.jotInputCelldidUpdateTextView(self)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        delegate?.jotInputCellIsActivated(self)
    }
    
    // TODO: Should probable be different class?
    // Create input accessory view in code
    func makeKeyboardAccessoryView() -> UIToolbar {
        
        let rect = CGRectMake(0.0, 0.0, 0.0, 44)
        let accView = UIToolbar(frame: rect)
        
        // Create custom button
        let button = UIButton(type: .System)
        button.setTitle("Show Numpad", forState: .Normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(toggleNumpad), forControlEvents: .TouchUpInside)
        
        // Test functionality, evaluate UI experience 
        
        let doneButton = UIBarButtonItem(title: "Add", style: .Done, target: self, action: #selector(addJotToTop))
        let flex = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        
        accView.items = [UIBarButtonItem(customView: button), flex, doneButton]
    
        return accView
    }
    
    func addJotToTop() {
        delegate?.jotAddedFromInputCell(self)
    }
    

    
    // Toggle keyboard type. Note the use of "sender"
    func toggleNumpad(sender: UIButton) {
        
        if textView.keyboardType == .Twitter {
            textView.keyboardType = .PhonePad
            sender.setTitle("Show Keyboard", forState: .Normal)
        } else {
            textView.keyboardType = .Twitter
            sender.setTitle("Show Numpad", forState: .Normal)
        }
        
        sender.sizeToFit()
        textView.reloadInputViews()
    }

}
