//
//  AJC+JotTableViewCellDelegate.swift
//  Jot It Down
//
//  Created by Andrey Baranov on 04/05/16.
//  Copyright © 2016 PaPaPanda. All rights reserved.
//

import UIKit

extension AllJotsController: JotTableViewCellDelegate {
    
    // TODO: Move to a proper place in code. Should we return something from this func?
    func JotTableViewCellDidReportPath(sender: JotTableViewCell) -> NSIndexPath {
        let path = tableView.indexPathForCell(sender)!
        
        guard !editing else {
            return path
        }
        
        tableView.beginUpdates()
        sectionedJots[path.section - 1].removeAtIndex(path.row)
        tableView.deleteRowsAtIndexPaths([path], withRowAnimation: .Automatic)
        tableView.endUpdates()
        
        
        if sectionedJots[path.section - 1].isEmpty {
            jots = sectionedJots.flatMap { $0 }
            tableView.reloadData()
            return path
        }
        
        jots = sectionedJots.flatMap { $0 }
        
        return path
    }
    
}