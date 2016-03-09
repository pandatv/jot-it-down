//
//  AllJotsController.swift
//  Jot It Down
//
//  Created by Andrey Baranov on 01/02/2016.
//  Copyright © 2016 PaPaPanda. All rights reserved.
//

import UIKit

class AllJotsController: UITableViewController, NewJotControllerDelegate, JotInputCellDelegate, JotTableViewCellDelegate {
   
   
   var jots = [Jot]() {
      didSet {
         // Re-draw toolbar to update count, make sure we're not in editing mode
         if !editing {
            self.toolbarItems = normalToolbar()
         }
         
         // UI changes for empty state
         if jots.isEmpty {
            self.navigationItem.rightBarButtonItem = nil
         } else {
            self.navigationItem.rightBarButtonItem = self.editButtonItem()
         }
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // TODO: Test for empty state (model is empty)
      // Uncomment to build a test array:
      buildTestArray()
   
      // register JotInputCell's nib
      tableView.registerNib(UINib(nibName: "JotInputCell", bundle: nil), forCellReuseIdentifier: "JotInputCell")
      
      
      // Resizable row height
      tableView.estimatedRowHeight = tableView.rowHeight
      tableView.rowHeight = UITableViewAutomaticDimension
      
      // Bottom toolbar that displays "Compose" icon that presents NewJotController
      navigationController?.toolbarHidden = false
      
      // Toolbar for a normal table state
      self.toolbarItems = normalToolbar()
      
      // Toggle "Edit" button
      switch jots.isEmpty {
      case true: self.navigationItem.rightBarButtonItem = nil
      case false: self.navigationItem.rightBarButtonItem = self.editButtonItem()
      }
      
      // Multiple selection checkmarks during editing
      tableView.allowsMultipleSelectionDuringEditing = true
      
      // Experimenting with tap recognizer to dismiss keyboard on tap out of the cell
      let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
      // !!!
      tapRecognizer.cancelsTouchesInView = false
      view.addGestureRecognizer(tapRecognizer)
      
      // Remove separators for empty rows (hack?)
      tableView.tableFooterView = UIView(frame: CGRectZero)
      
      // Remove separators altogether
      tableView.separatorStyle = .None
      
      
   }
   
   func buildTestArray() {
      
      let string = "На шестой международной конференции в Женеве наши делегации выступили с пакетом конструктивных предложений, направленных на углубление процессов интеграции в Европе. А я не поехал."
      
      let calendar = NSCalendar.currentCalendar()
      let todayComps = calendar.components([.Day], fromDate: NSDate())
      
      for month in 1...3 {
         for day in 1...31 {
            let components = NSDateComponents()
            components.day = day
            components.month = month
            components.year = 2016
            // Check if components are set to a valid date so we don't return extra days
            if components.isValidDateInCalendar(calendar) && components.day <= todayComps.day {
               let date = calendar.dateFromComponents(components)
               let jot = Jot(string: string, title: nil)
               jot.createdAt = date!
               jots.append(jot)
            }
         }
      }
      
      // Reverse so the latest date is on top
      jots = jots.reverse()
   }
   
   func handleSingleTap(recognizer: UITapGestureRecognizer) {
      dismissKeyboard(self)
   }
   
   // helper
   func composeJot() {
      performSegueWithIdentifier("composeJot", sender: nil)
   }
   
   // register as a delegate for NewJotController
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "composeJot" {
         let navCon = segue.destinationViewController as! UINavigationController
         let njc = navCon.topViewController as! NewJotController
         njc.delegate = self
      }
   }
   
   // MARK: - Set up table and sections
   
   // NUMBER OF SECTIONS
   override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      if !editing {
         return SectionBuilder.numberOfSections(jots, accountForInputRow: true)
      } else {
         return 2
      }
   }
   
   
   // NUMBER OF ROWS IN SECTION
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
      switch section {
      case 0: return 1
      default: break
      }
      
      if !editing {
         return SectionBuilder.numberOfRowsInSection(jots, section: section, accountForInputRow: true)
      } else {
         return jots.count
      }
   }
   
   // SECTION TITLES 
   override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      switch section {
      case 0: return nil
      default: break
      }
      
      if !editing {
         return SectionBuilder.titleForHeaderInSection(jots, section: section, accountForInputRow: true)
      } else {
         return nil 
      }

   }
   
   //MARK: - Dispatch cells
   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      
      var cellToReturn: UITableViewCell?
      
      
      if indexPath.section == 0 {
         
         let cell = tableView.dequeueReusableCellWithIdentifier("JotInputCell") as! JotInputCell
         cell.delegate = self
         cellToReturn = cell
         
         // Disable selection
         cell.selectionStyle = UITableViewCellSelectionStyle.None
         
         
      } else {
         
         var jot: Jot! 
         
         if !editing {
            jot = SectionBuilder.jotForRowAtIndexPath(jots, indexPath: indexPath, accountForInputRow: true)
         } else {
            jot = jots[indexPath.row]
         }
         
         
         let cell = tableView.dequeueReusableCellWithIdentifier("standard", forIndexPath: indexPath) as! JotTableViewCell
         cell.jot = jot
         cell.delegate = self
         
         let jotType = jot.type!
         
         switch jotType {
         case .Normal:
            break
         case .Checkmark:
            cell.tickbox.hidden = false
         }
         
         cellToReturn = cell
         
      }
      
      return cellToReturn!
      
   }
   
   
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
      // Account for editing mode
      if !editing {
         tableView.deselectRowAtIndexPath(indexPath, animated: true)
         
         // Test checkbox selection
         let cell = tableView.cellForRowAtIndexPath(indexPath)
         switch cell!.reuseIdentifier! {
         case "standard": break
         case "test":
            if cell?.accessoryType == .Checkmark {
               cell?.accessoryType = .None
            } else {
               cell?.accessoryType = .Checkmark
            }
         default: break
         }
      }
      
      if editing {
         updateToolbarOnMultipleSelection()
      }
   }
   
   // DEselect row
   override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
      updateToolbarOnMultipleSelection()
   }
   
   // Possible bugs
   func updateToolbarOnMultipleSelection() {
      if editing && tableView.indexPathsForSelectedRows?.count > 1 {
         toolbarItems![0].title = "Merge (\(tableView.indexPathsForSelectedRows!.count))"
      } else {
         toolbarItems![0].title = nil
      }
      
      if editing && tableView.indexPathsForSelectedRows?.count > 0 {
         toolbarItems![2].title = "Delete"
      } else {
         toolbarItems![2].title = nil
      }
   }
   
   
   // Prohibit editing for first row
   override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      if indexPath.section == 0 {
         return false
      } else {
         return true
      }
   }
   
   // Disable swipe actions
   override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
      if editing {
         return UITableViewCellEditingStyle.Delete
      } else {
         return UITableViewCellEditingStyle.None
      }
   }
   
   
   // Override to support editing the table view.
   override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      
      if editingStyle == .Delete {
         jots.removeAtIndex(indexPath.row)
         tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
         modifyToolbarsOnEditing(editing)
      } else if editingStyle == .Insert {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
      }
   }
   
   // Toggles editing mode
   override func setEditing(editing: Bool, animated: Bool) {
      super.setEditing(editing, animated: animated)
      
      
      modifyToolbarsOnEditing(editing)
      toggleInputRowOnEditing(editing)
      
     // Experiment with animations
      UIView.transitionWithView(tableView,
         duration:0.2,
         options:.TransitionCrossDissolve,
         animations:
         { () -> Void in
            self.tableView.reloadData()
         },
         completion: nil);
   }
   
   // Make interface changes
   func modifyToolbarsOnEditing(editing: Bool) {
      
      // Enter editing
      if editing {
         self.toolbarItems = editToolbar()
         
         // Exit editing
      } else {
         self.toolbarItems = normalToolbar()
      }
   }
   
   func toggleInputRowOnEditing(editing: Bool) {
      guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? JotInputCell else {
         return
      }
      cell.hidden = editing
      cell.tickboxSwitch.hidden = editing
   }
   
   override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      switch indexPath.section {
      case 0: if editing { return 0 }
      default: break
      }
      return UITableViewAutomaticDimension
   }
   
   
   // TODO: Re-write toolbar creation for nicer code, consider compose button in normal state
   
   // return toolbar items for normal state
   func normalToolbar() -> [UIBarButtonItem] {
      
      let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
      // let composeJot = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "composeJot")
      let jotCount = UIBarButtonItem(title: "\(jots.count) Jots", style: .Plain, target: self, action: nil)
      
      return [flexSpace, jotCount, flexSpace]
      
   }
   
   // return toolbar items for editing state
   func editToolbar() -> [UIBarButtonItem] {
      
      // Create placeholders for "Merge" and "Delete" buttons that will appear on multiple row selection
      return [UIBarButtonItem(title: nil, style: .Plain, target: self, action: "mergeAndDelete"),
         UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil),
         UIBarButtonItem(title: nil, style: .Plain, target: self, action: "deleteSelectedRows")]
   }
   
   func mergeAndDelete() {
      mergeSelected(andDelete: true)
   }
   
   // Consider adding to UI
   func mergeAndLeaveinPlace() {
      mergeSelected(andDelete: false)
   }
   
   // Merge selected rows and insert above the uppermost selected
   func mergeSelected(andDelete delete: Bool) {
      if let selectedRows = tableView.indexPathsForSelectedRows {
         let sortedRows = selectedRows.sort({$0.row < $1.row})
         var mergedJotString = ""
         for indexPath in sortedRows {
            mergedJotString += "\n"
            mergedJotString += jots[indexPath.row].body
         }
         // Instantiate new jot with a merged string
         let newJot = Jot(string: mergedJotString, title: nil)
         // Set it's color to the uppermost selected jot's color
         newJot.tagColor = jots[sortedRows.first!.row].tagColor
         
         let index = sortedRows[0]
         
         if delete {
            deleteSelectedRows()
         }
         
         jots.insert(newJot, atIndex: index.row)
         tableView.reloadData()
      }
   }
   
   // Who knew it would be such a PAIN IN THE ASS because we can't predictably iterate over Swift Array while it updates
   func deleteSelectedRows() {
      
      // Just making sure we selected something
      guard let selectedPaths = tableView.indexPathsForSelectedRows else {
         return
      }
      
      //  create NSIndexSet from [NSIndexPath]
      let indexSet = NSMutableIndexSet()
      for path in selectedPaths {
         indexSet.addIndex(path.row)
      }
      
      // cast Swift Array to NSMutableArray
      let mutableJots = (jots as NSArray).mutableCopy() as! NSMutableArray
      // Do NSMagic to remove several objects at once, not one by one
      mutableJots.removeObjectsAtIndexes(indexSet)
      // make NSArray from NSMutableArray
      let immutableJots = NSArray(array: mutableJots)
      // Replace entire model array by casting NSArray back to Swift Array
      jots = immutableJots as! Array
      
      tableView.deleteRowsAtIndexPaths(selectedPaths, withRowAnimation: .Automatic)
      
      // exit editing of no jots left
      if jots.isEmpty {
         setEditing(false, animated: true)
      }
   }
   
   // Override to support rearranging the table view.
   override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
      
      let jotToBeMoved = jots[fromIndexPath.row]
      jots.removeAtIndex(fromIndexPath.row)
      
      let destinationJot = jots[toIndexPath.row]
      jotToBeMoved.createdAt = destinationJot.createdAt
      
      jots.insert(jotToBeMoved, atIndex: toIndexPath.row)
      
   }
   
   // MARK: NewJotController delegate methods
   
   func newJotController(contoller: NewJotController, didFinishAddingJot jot: Jot) {
      jots.insert(jot, atIndex: 0)
      // refresh table
      tableView.reloadData()
   }
   
   // MARK: JotInputCell delegate methods
   
   func jotInputCelldidUpdateTextView(cell: JotInputCell) {
      tableView.beginUpdates()
      tableView.endUpdates()
   }
   
   
   // Update navigation bar and handle placeholder
   func jotInputCellIsActivated(cell: JotInputCell) {
      self.navigationItem.rightBarButtonItem = nil // UIBarButtonItem(title: "Done", style: .Done, target: self, action: "jotAddedFromInputCell")
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "dismissKeyboard:")
      
      if cell.textView.text == cell.placeholder {
         cell.textView.textColor = UIColor.blackColor()
         cell.textView.text = ""
      }
      
      cell.tickboxSwitch.enabled = true
   }
   
   //NB: model update is handled from AJC, not JIC
   
   
   func jotAddedFromInputCell(cell: JotInputCell) {
      
      //TODO: Check for whitespace only, not absence of alphanumeric. Not good for Emojis
      // Check if there is anything except whitespace
      let alphanum = NSCharacterSet.alphanumericCharacterSet()
      
      guard let _ = cell.textView.text.rangeOfCharacterFromSet(alphanum) else {
         dismissKeyboard(self)
         return
      }
      
      addJot(cell)
      
      cell.endEditing(true)
      cell.makePlaceholder()
      
      // Disable "Cancel" button
      self.navigationItem.leftBarButtonItem = nil
      
      tableView.reloadData()
      
   }
   
   // TODO: Should I have it as a separate method? 
   func addJot(cell: JotInputCell) {
      let jot = Jot(string: cell.textView.text, title: nil)
      jot.tagColor = cell.colorSelector
      
      if cell.tickboxSwitch.on {
         jot.type = .Checkmark
         cell.tickboxSwitch.setOn(false, animated: true)
      }
            
      jots.insert(jot, atIndex: 0)

   }
   
   func dismissKeyboard(sender: AnyObject) {
      if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? JotInputCell
      {
         self.navigationItem.leftBarButtonItem = nil
         self.navigationItem.rightBarButtonItem = editButtonItem()
         
         cell.endEditing(true)
         
         if sender is UIBarButtonItem {
            cell.makePlaceholder()
         }
         
         cell.tickboxSwitch.setOn(false, animated: true)
         cell.tickboxSwitch.enabled = false
         
         tableView.beginUpdates()
         tableView.endUpdates()
      }
      
   }
   
   // JotTableViewCell delegate methods
   func jotTableViewCellDetectedLongPress(cell: JotTableViewCell) {
      if !editing {
         self.setEditing(true, animated: false)
      }
   }
}
