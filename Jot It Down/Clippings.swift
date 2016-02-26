//
//  Clippings.swift
//  Jot It Down
//
//  Created by Andrey Baranov on 26/02/16.
//  Copyright © 2016 PaPaPanda. All rights reserved.
//

import Foundation

   /* // TO BE DEPRECATED
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
   */