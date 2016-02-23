//
//  SectionBuilder.swift
//  Jot It Down
//
//  Created by Andrey Baranov on 22/02/2016.
//  Copyright © 2016 PaPaPanda. All rights reserved.
//

import Foundation

class SectionBuilder {

    private struct SectionNames {
        static let Today = "Today"
        static let ThisWeek = "This Week"
        static let ThisMonth = "This Month"
        
        static var MonthAgo: String {
            return previousMonthsNames()[0]
        }
        
        static var TwoMonthsAgo: String {
            return previousMonthsNames()[1]
        }
        
        static var ThreeMonthsAgo: String {
            return previousMonthsNames()[2]
        }
        
        static let Earlier = "Earlier"
        
        static func calculatePreviousMonth(monthsBack: Int) -> NSDate? {
            let now = NSDate()
            let calendar = NSCalendar.currentCalendar()
            // calendar.firstWeekday = 2
            let todayComps = calendar.components([.Month, .Year], fromDate: now)
            todayComps.month -= monthsBack
            return calendar.dateFromComponents(todayComps)
        }
        
        private static func previousMonthsNames() -> [String] {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMMM"
            let monthAgoString = formatter.stringFromDate(calculatePreviousMonth(1)!)
            let twoMonthsAgoString = formatter.stringFromDate(calculatePreviousMonth(2)!)
            let threeMonthsAgoString = formatter.stringFromDate(calculatePreviousMonth(3)!)
            
            let returnArray = [monthAgoString, twoMonthsAgoString, threeMonthsAgoString]
            
            return returnArray
        }
        
    }
    
    class func namesForSections() -> [String] {
        return [SectionNames.Today, SectionNames.ThisWeek, SectionNames.ThisMonth, SectionNames.MonthAgo, SectionNames.TwoMonthsAgo, SectionNames.ThreeMonthsAgo, SectionNames.Earlier]
    }
    
    class func arraysForSections(jots: [Jot]) -> [[Jot]] {
        
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        var todayJots: [Jot]?
        var thisWeekJots: [Jot]?
        var thisMonthJots: [Jot]?
        var oneMonthAgoJots: [Jot]?
        var twoMonthsAgoJots: [Jot]?
        var threeMonthsAgoJots: [Jot]?
        var earlierJots: [Jot]?
        
        // That's the way!
        for jot in jots {
            
            if calendar.compareDate(jot.createdAt, toDate: now, toUnitGranularity: .Day) == NSComparisonResult.OrderedSame {
                if todayJots == nil {
                    todayJots = [Jot]()
                }
                todayJots?.append(jot)
                continue
            }
            
            
            
            if calendar.compareDate(jot.createdAt, toDate: now, toUnitGranularity: .WeekOfYear) == NSComparisonResult.OrderedSame {
                if thisWeekJots == nil {
                    thisWeekJots = [Jot]()
                }
                thisWeekJots?.append(jot)
                continue
            }
            
            
            if calendar.compareDate(jot.createdAt, toDate: now, toUnitGranularity: .Month) == NSComparisonResult.OrderedSame {
                if thisMonthJots == nil {
                    thisMonthJots = [Jot]()
                }
                thisMonthJots?.append(jot)
                continue
            }
            
            
            if calendar.compareDate(jot.createdAt, toDate: SectionNames.calculatePreviousMonth(1)!, toUnitGranularity: .Month) == NSComparisonResult.OrderedSame {
                if oneMonthAgoJots == nil {
                    oneMonthAgoJots = [Jot]()
                }
                oneMonthAgoJots?.append(jot)
                continue
            }
            
            if calendar.compareDate(jot.createdAt, toDate: SectionNames.calculatePreviousMonth(2)!, toUnitGranularity: .Month) == NSComparisonResult.OrderedSame {
                if twoMonthsAgoJots == nil {
                    twoMonthsAgoJots = [Jot]()
                }
                twoMonthsAgoJots?.append(jot)
                continue
            }
            
            if calendar.compareDate(jot.createdAt, toDate: SectionNames.calculatePreviousMonth(3)!, toUnitGranularity: .Month) == NSComparisonResult.OrderedSame {
                if threeMonthsAgoJots == nil {
                    threeMonthsAgoJots = [Jot]()
                }
                threeMonthsAgoJots?.append(jot)
                continue
            }
            
            if calendar.compareDate(jot.createdAt, toDate: SectionNames.calculatePreviousMonth(3)!, toUnitGranularity: .Month) == NSComparisonResult.OrderedAscending {
                if earlierJots == nil {
                    earlierJots = [Jot]()
                }
                earlierJots?.append(jot)
                continue
            }
            

        }
        
        let allSections: [[Jot]?] = [todayJots, thisWeekJots, thisMonthJots, oneMonthAgoJots, twoMonthsAgoJots, threeMonthsAgoJots, earlierJots]
        
        
        var sectionsToReturn = [[Jot]]()
        
        for section in allSections {
            if section != nil {
                sectionsToReturn.append(section!)
            }
        }
        

        
        return sectionsToReturn
    }
    
}

