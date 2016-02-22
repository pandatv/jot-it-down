//
//  NewJotController.swift
//  Jot It Down
//
//  Created by Andrey Baranov on 01/02/2016.
//  Copyright © 2016 PaPaPanda. All rights reserved.
//

import UIKit

protocol NewJotControllerDelegate: class {
    func newJotController(contoller: NewJotController, didFinishAddingJot jot: Jot)
}

class NewJotController: UIViewController, UITextViewDelegate {

    // TODO: Define protocol for delegation 
    
    @IBOutlet weak var textView: UITextView!
    
    weak var delegate: NewJotControllerDelegate?
 
    // Constraint to be changed by keyboard height 
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func cancelButton(sender: AnyObject) {
        hideKeyboardAndController()
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        let jot = Jot(string: textView.text, title: nil)
        delegate?.newJotController(self, didFinishAddingJot: jot) 
        hideKeyboardAndController()
    }

    func hideKeyboardAndController() {
        // Sequence of this calls counts:
        textView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Keep the cursor nicely on top
        self.automaticallyAdjustsScrollViewInsets = false
        // Cosmetic adjustment, bring the cursor down a bit
        textView.contentInset.top += 10
        
        // Attach accessory view
        textView.inputAccessoryView = makeKeyboardAccessoryView()
        // Turn on keyboard observer. The keyboard is never off screen, so no sense to remove it?
        observeKeyboard()
        // Summon keyboard by default
        textView.becomeFirstResponder()
    
    }
    
    // Keyboard observer
    func observeKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resizeForKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    // Update constraint on keyboard appearance (called from keyboard observer)
    func resizeForKeyboard(notification: NSNotification) {
        let kbHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        bottomConstraint.constant = kbHeight
    }
    
    
    // Create input accessory view in code
    func makeKeyboardAccessoryView() -> UIToolbar {
        
        let width = view.bounds.width
        let rect = CGRectMake(0.0, 0.0, width, 44)
        let accView = UIToolbar(frame: rect)
        
        // Create custom button
        let button = UIButton(type: .System)
        button.setTitle("Show Numpad", forState: .Normal)
        button.sizeToFit()
        button.addTarget(self, action: "toggleNumpad:", forControlEvents: .TouchUpInside)
        
        accView.items = [UIBarButtonItem(customView: button)]
        
        return accView
    }
    
    // Toggle keyboard type. Note the use of "sender"
    func toggleNumpad(sender: UIButton) {
        
        if textView.keyboardType == .Default {
            textView.keyboardType = .PhonePad
            sender.setTitle("Show Keyboard", forState: .Normal)
        } else {
            textView.keyboardType = .Default
            sender.setTitle("Show Numpad", forState: .Normal)
        }
        
        sender.sizeToFit()
        textView.reloadInputViews()
    }
    

    
    // TODO LATER
//    func doneEnteringNumber() {
//        textFieldShouldReturn(textField)
//    }
    
}
