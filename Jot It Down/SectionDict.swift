//
//  SectionDict.swift
//  Jot It Down
//
//  Created by Andrey Baranov on 22/02/2016.
//  Copyright © 2016 PaPaPanda. All rights reserved.
//

import Foundation

// Building dict
var sectionDict = [String:[Jot]]()


private struct SectionNames {
    static let Today = "Today"
    static let ThisWeek = "This Week"
    static let ThisMonth = "This Month"
    
    static var MonthAgo: String {
        return generatePreviousMonths()[0]
    }
    
    static var TwoMonthsAgo: String {
        return generatePreviousMonths()[1]
    }
    
    static var ThreeMonthsAgo: String {
        return generatePreviousMonths()[2]
    }
    
    static let Earlier = "Earlier"
    
    private static func generatePreviousMonths() -> [String] {
        let calendar = NSCalendar.currentCalendar()
        
        // SYSTEM DEFAULT DEPENDENT!
        calendar.firstWeekday = 2
        let now = NSDate()
        let todayComps = calendar.components([.Month, .Year], fromDate: now)
        todayComps.month -= 1
        let monthAgo = calendar.dateFromComponents(todayComps)
        todayComps.month -= 1
        let twoMonthsAgo = calendar.dateFromComponents(todayComps)
        todayComps.month -= 1
        let threeMonthsAgo = calendar.dateFromComponents(todayComps)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM"
        let monthAgoString = formatter.stringFromDate(monthAgo!)
        let twoMonthsAgoString = formatter.stringFromDate(twoMonthsAgo!)
        let threeMonthsAgoString = formatter.stringFromDate(threeMonthsAgo!)
        
        let returnArray = [monthAgoString, twoMonthsAgoString, threeMonthsAgoString]
        
        return returnArray
    }
    
}


// TODO:
func buildSectionDict(var jots: [Jot]) -> [String: [Jot]] {
    
    
    let now = NSDate()
    let calendar = NSCalendar.currentCalendar()
    
    
    // That's the way!
    for jot in jots {
        
        if calendar.compareDate(jot.createdAt, toDate: now, toUnitGranularity: .Day) == NSComparisonResult.OrderedSame {
            if sectionDict[SectionNames.Today] == nil {
               sectionDict[SectionNames.Today] = [Jot]()
            }
            
            jots.removeAtIndex(jots.indexOf(jot)!)
            sectionDict[SectionNames.Today]?.append(jot)
        }
        
        /*
        if calendar.compareDate(jot.createdAt, toDate: now, toUnitGranularity: .WeekOfYear) == NSComparisonResult.OrderedSame && !sectionDict[SectionNames.Today]!.contains(jot) {
            if sectionDict[SectionNames.Today] == nil {
                sectionDict[SectionNames.Today] = [Jot]()
            }
            
            sectionDict[SectionNames.Today]?.append(jot)
        }
        
        if calendar.compareDate(jot.createdAt, toDate: now, toUnitGranularity: .Month) == NSComparisonResult.OrderedSame && !sectionDict["This Week"]!.contains(jot) && !sectionDict["Today"]!.contains(jot) {
            sectionDict["This Month"]?.append(jot)
        }
        
        if calendar.compareDate(jot.createdAt, toDate: monthAgo!, toUnitGranularity: .Month) == NSComparisonResult.OrderedSame {
            sectionDict["\(monthAgoString)"]?.append(jot)
        }
        
        if calendar.compareDate(jot.createdAt, toDate: twoMonthsAgo!, toUnitGranularity: .Month) == NSComparisonResult.OrderedSame {
            sectionDict["\(twoMonthsAgoString)"]?.append(jot)
        }
        
        if calendar.compareDate(jot.createdAt, toDate: threeMonthsAgo!, toUnitGranularity: .Month) == NSComparisonResult.OrderedSame {
            sectionDict["\(threeMonthsAgoString)"]?.append(jot)
        }
        
        if calendar.compareDate(jot.createdAt, toDate: threeMonthsAgo!, toUnitGranularity: .Month) == NSComparisonResult.OrderedAscending {
            sectionDict["Earlier"]?.append(jot)
        }
        
        */
    }
    
    
    return sectionDict
    
}