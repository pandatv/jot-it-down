//
//  SectionBuilder.swift
//  Jot It Down
//
//  Created by Andrey Baranov on 22/02/2016.
//  Copyright © 2016 PaPaPanda. All rights reserved.
//

import Foundation

class SectionBuilder {
    
    //MARK: - Public
    
    // Returns number of sections for UITableView, incremented by 1 if the input row is present
    class func numberOfSections(jots: [Jot], accountForInputRow: Bool) -> Int {
        return self.arraysForSections(jots).count + (accountForInputRow ? 1 : 0)
    }
    
    // Returns number of rows in section for UITableView, decrement by 1 if the input row is present
    class func numberOfRowsInSection(jots: [Jot], section: Int, accountForInputRow: Bool) -> Int {
        return self.arraysForSections(jots)[section - (accountForInputRow ? 1 : 0)].interval.count
    }
    
    // Returns headers for rows in section for UITableView, decrement by 1 if the input row is present
    class func titleForHeaderInSection(jots: [Jot], section: Int, accountForInputRow: Bool) -> String {
        return self.arraysForSections(jots)[section - (accountForInputRow ? 1 : 0)].name
    }
    
    // Returns data for certain row in UITableView
    class func jotForRowAtIndexPath(jots: [Jot], indexPath: NSIndexPath, accountForInputRow: Bool) -> Jot {
        return self.arraysForSections(jots)[indexPath.section - (accountForInputRow ? 1 : 0)].interval[indexPath.row]
    }
    
    // Checks if today's section has been generated
    class func checkIfThereIsToday(jots: [Jot]) -> Bool {
        for tuple in arraysForSections(jots) {
            if tuple.name == SectionNames.today {
                return true
            }
        }
        
        return false
    }
    
    // TODO:
    class func namesForSections(jots: [Jot]) -> (full: [String], short: [String]) {
        
        var fullNames = [String]()
        var shortNames = [String]()
        
        for section in self.arraysForSections(jots) {
            fullNames.append(section.name)
        }
        
        for _ in fullNames {
            shortNames.append("*")
        }
        
        return (fullNames, shortNames)
    }
    
    //MARK: - Private

    // Forbid instance creation
    private init() {}
    
    // Set up current date
    private static let now = NSDate()
    private static let calendar = NSCalendar.currentCalendar()
    
    // Week starts on Monday, but we can change it with this public method
    static func setFirstDay(day: Int = 2) {
        calendar.firstWeekday = day
    }
    
    // Store names for section intervals
    private struct SectionNames {
        
        static let today = "Today"
        
        static let thisWeek = "This Week"
        
        static var thisMonth: String {
            return previousMonthsNames()[0]
        }
        
        static var monthAgo: String {
            return previousMonthsNames()[1]
        }
        
        static var twoMonthsAgo: String {
            return previousMonthsNames()[2]
        }
        
        static var threeMonthsAgo: String {
            return previousMonthsNames()[3]
        }
        
        static let earlier = "Earlier"
        
        private static func previousMonthsNames() -> [String] {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMMM"
            let currentMonthString = formatter.stringFromDate(SectionBuilder.calculatePreviousMonth(0)!)
            let monthAgoString = formatter.stringFromDate(SectionBuilder.calculatePreviousMonth(1)!)
            let twoMonthsAgoString = formatter.stringFromDate(SectionBuilder.calculatePreviousMonth(2)!)
            let threeMonthsAgoString = formatter.stringFromDate(SectionBuilder.calculatePreviousMonth(3)!)
            
            return [currentMonthString, monthAgoString, twoMonthsAgoString, threeMonthsAgoString]
        }
        
    }
    
    // Method to go back in time, month by month
    private class func calculatePreviousMonth(monthsBack: Int) -> NSDate? {
        let todayComps = calendar.components([.Month, .Year], fromDate: now)
        todayComps.month -= monthsBack
        return calendar.dateFromComponents(todayComps)
    }
    
    // TODO: Re-write with flatMap()! 
    // Uses tuples to generate relevant section names
    private class func arraysForSections(jots: [Jot]) -> [(name: String, interval: [Jot])] {
        
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
    
}

