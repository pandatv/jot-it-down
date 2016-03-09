//
//  Clippings.swift
//  Jot It Down
//
//  Created by Andrey Baranov on 26/02/16.
//  Copyright © 2016 PaPaPanda. All rights reserved.
//

import Foundation

/*
// TODO: KISS!
// Uses tuples to generate relevant section names
class func arraysForSections(jots: [Jot]) -> [(name: String, interval: [Jot])] {
    
    var todayJots: [Jot]?
    var thisWeekJots: [Jot]?
    var thisMonthJots: [Jot]?
    var oneMonthAgoJots: [Jot]?
    var twoMonthsAgoJots: [Jot]?
    var threeMonthsAgoJots: [Jot]?
    var earlierJots: [Jot]?
    
    var names = [String]()
    
    // That's the way!
    for jot in jots {
        
        if calendar.compareDate(jot.createdAt, toDate: now, toUnitGranularity: .Day) == NSComparisonResult.OrderedSame {
            if todayJots == nil {
                todayJots = [Jot]()
                names.append(SectionNames.today)
            }
            
            todayJots?.append(jot)
            continue
        }
        
        if calendar.compareDate(jot.createdAt, toDate: now, toUnitGranularity: .WeekOfYear) == NSComparisonResult.OrderedSame {
            if thisWeekJots == nil {
                thisWeekJots = [Jot]()
                names.append(SectionNames.thisWeek)
            }
            thisWeekJots?.append(jot)
            continue
        }
        
        if calendar.compareDate(jot.createdAt, toDate: now, toUnitGranularity: .Month) == NSComparisonResult.OrderedSame {
            if thisMonthJots == nil {
                thisMonthJots = [Jot]()
                names.append(SectionNames.thisMonth)
            }
            thisMonthJots?.append(jot)
            continue
        }
        
        if calendar.compareDate(jot.createdAt, toDate: SectionBuilder.calculatePreviousMonth(1)!, toUnitGranularity: .Month) == NSComparisonResult.OrderedSame {
            if oneMonthAgoJots == nil {
                oneMonthAgoJots = [Jot]()
                names.append(SectionNames.monthAgo)
            }
            oneMonthAgoJots?.append(jot)
            continue
        }
        
        if calendar.compareDate(jot.createdAt, toDate: SectionBuilder.calculatePreviousMonth(2)!, toUnitGranularity: .Month) == NSComparisonResult.OrderedSame {
            if twoMonthsAgoJots == nil {
                twoMonthsAgoJots = [Jot]()
                names.append(SectionNames.twoMonthsAgo)
            }
            twoMonthsAgoJots?.append(jot)
            continue
        }
        
        if calendar.compareDate(jot.createdAt, toDate: SectionBuilder.calculatePreviousMonth(3)!, toUnitGranularity: .Month) == NSComparisonResult.OrderedSame {
            if threeMonthsAgoJots == nil {
                threeMonthsAgoJots = [Jot]()
                names.append(SectionNames.threeMonthsAgo)
            }
            threeMonthsAgoJots?.append(jot)
            continue
        }
        
        if calendar.compareDate(jot.createdAt, toDate: SectionBuilder.calculatePreviousMonth(3)!, toUnitGranularity: .Month) == NSComparisonResult.OrderedAscending {
            if earlierJots == nil {
                earlierJots = [Jot]()
                names.append(SectionNames.earlier)
            }
            earlierJots?.append(jot)
            continue
        }
    }
    
    let allSections: [[Jot]?] = [todayJots, thisWeekJots, thisMonthJots, oneMonthAgoJots, twoMonthsAgoJots, threeMonthsAgoJots, earlierJots]
    
    
    var sectionsToReturn = [[Jot]]()
    var tuplesToReturn = [(name: String, interval: [Jot])]()
    
    
    
    for section in allSections {
        if section != nil {
            sectionsToReturn.append(section!)
        }
    }
    
    
    for name in names {
        tuplesToReturn.append((name, sectionsToReturn[names.indexOf(name)!]))
    }
    
    return tuplesToReturn
}
*/


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