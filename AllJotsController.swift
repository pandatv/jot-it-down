//
//  AllJotsController.swift
//  Jot It Down
//
//  Created by Andrey Baranov on 01/02/2016.
//  Copyright © 2016 PaPaPanda. All rights reserved.
//

import UIKit

class AllJotsController: UITableViewController, NewJotControllerDelegate, JotInputCellDelegate {
   
   
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
         
         sectionedJots = SectionBuilder.arraysForSections(jots)
      }
   }
   
   var sectionedJots = [[Jot]]()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Uncomment to build a test array
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

      for month in 1...2 {
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
      return sectionedJots.count
   }
   
   
   // NUMBER OF ROWS
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
      switch section {
      case 0: return 1
      case 1: return sectionedJots[0].count
      case 2: return sectionedJots[1].count
      case 3: return sectionedJots[2].count
      case 4: return sectionedJots[3].count
      case 5: return sectionedJots[4].count
      case 6: return sectionedJots[5].count
      case 7: return sectionedJots[6].count
      default: break
      }
      
      return 0
   }
   
   // NAME SECTIONS
   override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      switch section {
      case 1: return SectionBuilder.namesForSections()[0]
      case 2: return SectionBuilder.namesForSections()[1]
      case 3: return SectionBuilder.namesForSections()[2]
      case 4: return SectionBuilder.namesForSections()[3]
      case 5: return SectionBuilder.namesForSections()[4]
      case 6: return SectionBuilder.namesForSections()[5]
      case 7: return SectionBuilder.namesForSections()[6]
         
      default: break
      }
      return nil
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
         
         let jot = sectionedJots[indexPath.section - 1][indexPath.row]
         
         let cell = tableView.dequeueReusableCellWithIdentifier("standard", forIndexPath: indexPath) as! JotTableViewCell
         cell.jot = jot

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
   
   // Custom action for row slide
   override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
      
      let delete = UITableViewRowAction(style: .Default, title: "⨯") { (action, index) -> Void in
         self.tableView(self.tableView, commitEditingStyle: .Delete, forRowAtIndexPath: index)
         // quit editing after action
         self.setEditing(false, animated: true)
      }
      
      let tick = UITableViewRowAction(style: .Normal, title: "☑︎") { action, index in
         self.toggleJotType(self.jots[index.row])
         tableView.reloadData()
      }
      tick.backgroundColor = UIColor.orangeColor()
      
      let red = UITableViewRowAction(style: .Normal, title: "  ") { action, index in
         self.setRedTag(self.jots[index.row])
         tableView.reloadData()
      }
      red.backgroundColor = Jot.ColorPalette.Red
      
      let green = UITableViewRowAction(style: .Normal, title: "  ") { action, index in
         self.setGreenTag(self.jots[index.row])
         tableView.reloadData()
      }
      green.backgroundColor = Jot.ColorPalette.Green
      
      let blue = UITableViewRowAction(style: .Normal, title: "  ") { action, index in
         self.setBlueTag(self.jots[index.row])
         tableView.reloadData()
      }
      blue.backgroundColor = Jot.ColorPalette.Blue
      
      let none = UITableViewRowAction(style: .Normal, title: "  ") { action, index in
         self.setTagToNone(self.jots[index.row])
         tableView.reloadData()
      }
      none.backgroundColor = UIColor.lightGrayColor()
      
      return [delete, tick, red, green, blue, none]
   }
   
   // Helper functions for row actions
   func toggleJotType(jot: Jot) {
      if jot.type == .Normal {
         jot.type = .Checkmark
      } else {
         jot.type = .Normal
      }
   }
   
   func setRedTag(jot: Jot) {
      jot.tagColor = .Red
   }
   
   func setGreenTag(jot: Jot) {
      jot.tagColor = .Green
   }
   
   func setBlueTag(jot: Jot) {
      jot.tagColor = .Blue
   }
   
   func setTagToNone(jot: Jot) {
      jot.tagColor = .None
   }
   
   
   
   // Prohibit editing for first row
   override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      if indexPath.section == 0 {
         return false
      } else {
         return true
      }
   }
   
   
   // Override to support editing the table view
   override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      if editingStyle == .Delete {
         let cell = tableView.cellForRowAtIndexPath(indexPath) as! JotTableViewCell
         jots.removeAtIndex(jots.indexOf(cell.jot!)!)
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
      tableView.beginUpdates()
      tableView.endUpdates()
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
      
      // TODO: Find proper animation
      // modify view
      tableView.deleteRowsAtIndexPaths(selectedPaths, withRowAnimation: .Automatic)
      
      // Delay
      let seconds = 0.2
      let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
      let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
      
      dispatch_after(dispatchTime, dispatch_get_main_queue(), {
         
         // quit editing mode
         self.setEditing(false, animated: true)
         
      })
      
      
   }
   
   // Override to support rearranging the table view.
   override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
      
      let jotToBeMoved = jots[fromIndexPath.row]
      jots.removeAtIndex(fromIndexPath.row)
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
      
      tableView.beginUpdates()
      tableView.endUpdates()
      
   }
   
   func addJot(cell: JotInputCell) {
      let jot = Jot(string: cell.textView.text, title: nil)
      jot.tagColor = cell.colorSelector
      
      if cell.tickboxSwitch.on {
         jot.type = .Checkmark
         cell.tickboxSwitch.setOn(false, animated: true)
      }
      
      jots.insert(jot, atIndex: 0)
      let indexPath = NSIndexPath(forRow: 0, inSection: 1)
      tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
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
   
}
