//
//  AllJotsController.swift
//  Jot It Down
//
//  Created by Andrey Baranov on 01/02/2016.
//  Copyright © 2016 PaPaPanda. All rights reserved.
//

import UIKit

//TODO: Refactor navbar drawing code!

class AllJotsController: UITableViewController {
   
   
   var jots = [Jot]() {
      didSet {
         // Re-draw toolbar to update count, make sure we're not in editing mode
         if !editing {
            self.toolbarItems = normalToolbar()
         }
         
         // TODO: DRY
         // UI changes for empty state
         if jots.isEmpty {
            self.navigationItem.rightBarButtonItem = nil
         } else {
            self.navigationItem.rightBarButtonItem = self.editButtonItem()
         }
      }
   }
   
   var filteredJots = [Jot]()
   
   // Create a search controller
   let searchController = UISearchController(searchResultsController: nil)
   

   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Uncomment to build a test array:
      buildTestArray()
   
      // register JotInputCell's nib
      tableView.registerNib(UINib(nibName: "JotInputCell", bundle: nil), forCellReuseIdentifier: "JotInputCell")
      
      
      // Resizable row height
      tableView.estimatedRowHeight = tableView.rowHeight
      tableView.rowHeight = UITableViewAutomaticDimension
      
      // Show toolbar
      navigationController?.toolbarHidden = false
      
      // Toolbar for a normal table state
      self.toolbarItems = normalToolbar()
      
      // Put a search icon into navbar
      drawSearchButton()
      
      // TODO: DRY! (jots property observer)
      switch jots.isEmpty {
      case true: self.navigationItem.rightBarButtonItem = nil
      case false: self.navigationItem.rightBarButtonItem = self.editButtonItem()
      }
      
      // Multiple selection checkmarks during editing
      tableView.allowsMultipleSelectionDuringEditing = true
      
      // Experimenting with tap recognizer to dismiss keyboard on tap out of the cell
      let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AllJotsController.handleSingleTap(_:)))
      // !!!
      tapRecognizer.cancelsTouchesInView = false
      view.addGestureRecognizer(tapRecognizer)
      
      // Remove separators for empty rows (hacky way)
      tableView.tableFooterView = UIView(frame: CGRectZero)
      
      // Remove separators altogether
      tableView.separatorStyle = .None
      
      configureSearchController()
      
   }
   
   func handleSingleTap(recognizer: UITapGestureRecognizer) {
      if !editing {
         dismissKeyboard(self)
      }
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
      
      if searchController.active && searchController.searchBar.text == "" {
         return 0
      } else if searchController.active && searchController.searchBar.text != "" {
         return 1
      }
      
      
      if !editing {
         return SectionBuilder.numberOfSections(jots, accountForInputRow: true)
      } else {
         return 2
      }
   }
   
   
   // NUMBER OF ROWS IN SECTION
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      if searchController.active && searchController.searchBar.text != "" {
         return filteredJots.count
      }
   
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
   
   // TODO:
   /*
   // SECTION INDEX
   override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
      if !editing {
         return SectionBuilder.namesForSections(jots).short
      } else {
         return nil
      }
      
   }
   */
   
   //DISPATCH CELLS
   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      
      var cellToReturn: UITableViewCell
      
      // We're searching and displaying results in the same VC
      if searchController.active && searchController.searchBar.text != "" {
         var jot: Jot
         let cell = tableView.dequeueReusableCellWithIdentifier("standard") as! JotTableViewCell
         jot = filteredJots[indexPath.row]
         cell.jot = jot
         return cell
      }
      
      
      // We're not searching, first section is reserved for input row
      if indexPath.section == 0 {
         
         let cell = tableView.dequeueReusableCellWithIdentifier("JotInputCell") as! JotInputCell
         cell.delegate = self
         cellToReturn = cell
         
         // Disable selection
         cell.selectionStyle = UITableViewCellSelectionStyle.None
         
      
      // Other section's behavior depends on the model
      } else {
         
         var jot: Jot
         
         if !editing {
            jot = SectionBuilder.jotForRowAtIndexPath(jots, indexPath: indexPath, accountForInputRow: true)
         } else {
            jot = jots[indexPath.row]
         }
         
         
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
      
      // TODO: make sure it works with a swipe 
      // Disable cell selection in normal mode
      if editing {
         cellToReturn.selectionStyle = .Blue
      } else {
         cellToReturn.selectionStyle = .None
      }
      
      return cellToReturn
      
   }
   
   override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
      if !editing {
         return nil
      } else {
         return indexPath
      }
   }
   
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
      // Account for editing mode
      if !editing {
         tableView.deselectRowAtIndexPath(indexPath, animated: true)
         
         //TODO: DRY!
         // Clicked on row when a search result is presnted
         if searchController.active {
            searchController.active = false
            navigationItem.titleView = nil
            navigationItem.rightBarButtonItem = editButtonItem()
            drawSearchButton()
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
   
   // TODO: Move closer to toolbar set-up function
   // Possible bugs
   func updateToolbarOnMultipleSelection() {
      
      if editing && tableView.indexPathsForSelectedRows?.count > 1 {
         toolbarItems![2].title = "Merge (\(tableView.indexPathsForSelectedRows!.count))"
      } else {
         toolbarItems![2].title = nil
      }
      
      if editing && tableView.indexPathsForSelectedRows?.count > 0 {
         toolbarItems![0].title = "Delete"
         toolbarItems![4].tintColor = nil
      } else {
         toolbarItems![0].title = nil
         toolbarItems![4].tintColor = UIColor.clearColor()
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
   
   // MARK: Set editing
   // Toggles editing mode
   override func setEditing(editing: Bool, animated: Bool) {
      super.setEditing(editing, animated: animated)
      
      // Makes sure cells are selectable in editing mode
      // TODO: Make sure that's not stupid
      for cell in tableView.visibleCells {
         if editing {
            cell.selectionStyle = UITableViewCellSelectionStyle.Blue
         } else {
            cell.selectionStyle = UITableViewCellSelectionStyle.None
         }
      }
      
      
      toggleSearchButtonOnEditing(editing)
      modifyToolbarsOnEditing(editing)
      toggleInputRowOnEditing(editing)
      
     // MAGIC. Smooth transition between table modes. Prevents default swipes in main mode!
      UIView.transitionWithView(tableView,
         duration:0.2,
         options:.TransitionCrossDissolve,
         animations:
         { () -> Void in
            self.tableView.reloadData()
         },
         completion: nil);
   }
   
   // TODO: Bug: Button re-appears on select row in editing mode
   func toggleSearchButtonOnEditing(editing: Bool) {
      if editing {
         navigationItem.leftBarButtonItem = nil
      } else {
         drawSearchButton()
      }
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
      let sharingIcon = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(presentSharingOptions))
      
      return [flexSpace, jotCount, flexSpace, sharingIcon]
      
   }
   
   // return toolbar items for editing state
   func editToolbar() -> [UIBarButtonItem] {
      
      
      let shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(shareSelectedPaths))
      shareButton.tintColor = UIColor.clearColor()
      
      // TODO: disable actions until placeholders are set
      // Create placeholders for "Merge" and "Delete" buttons that will appear on multiple row selection
      return [UIBarButtonItem(title: nil, style: .Plain, target: self, action: #selector(deleteSelectedRows)),
         UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil),
         UIBarButtonItem(title: nil, style: .Plain, target: self, action: #selector(mergeAndDelete)),
         UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil),
         shareButton]
   }
   
   func mergeAndDelete() {
      mergeSelected(andDelete: true)
   }
   
   // Not used for a moment. Consider adding to UI
   func mergeAndLeaveinPlace() {
      mergeSelected(andDelete: false)
   }
   
   // TODO: Figure out line breaks. Re-write with .joinWithSeparator
   // Merge selected rows and insert above the uppermost selected
   func mergeSelected(andDelete delete: Bool) {
      if let selectedRows = tableView.indexPathsForSelectedRows {
         let sortedRows = selectedRows.sort({$0.row < $1.row})
         var mergedJotString = ""
         for indexPath in sortedRows {
            mergedJotString += jots[indexPath.row].body
            mergedJotString += "\n"
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
}

