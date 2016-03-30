//
//  AJC+Sharing.swift
//  Jot It Down
//
//  Created by Andrey Baranov on 30/03/2016.
//  Copyright © 2016 PaPaPanda. All rights reserved.
//

import UIKit

extension AllJotsController {
    
    func presentSharingOptions() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let shareLastAction = UIAlertAction(title: "Export last entry", style: .Default, handler: { _ in self.shareLastAdded() })
        let shareTodayAction = UIAlertAction(title: "Export all from today", style: .Default, handler: { _ in self.shareTodayJots() })
        let shareSelectedAction = UIAlertAction(title: "Select and export", style: .Default, handler: { _ in self.setEditing(true, animated: false) })
        
        ac.addAction(cancelAction)
        ac.addAction(shareLastAction)
        
        if SectionBuilder.checkIfThereIsToday(jots) {
            ac.addAction(shareTodayAction)
        }
        
        ac.addAction(shareSelectedAction)
        
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func shareLastAdded() {
        if !jots.isEmpty {
            let path = NSIndexPath(forRow: 0, inSection: 1)
            tableView.selectRowAtIndexPath(path, animated: true, scrollPosition: UITableViewScrollPosition.Top)
            shareSelected(tableView.indexPathsForSelectedRows)
        }
        
    }
    
    func shareTodayJots() {
        if SectionBuilder.checkIfThereIsToday(jots) {
            var paths = [NSIndexPath]()
            for path in tableView.indexPathsForVisibleRows! {
                if path.section == 1 {
                    paths.append(path)
                }
            }
            shareSelected(paths)
        }
    }
    
    func shareSelectedPaths() {
        shareSelected(tableView.indexPathsForSelectedRows)
    }
    
    func shareSelected(selected: [NSIndexPath]?) {
        if let selJots = stringFromSelectedJots(selected) {
            let vc = UIActivityViewController(activityItems: [selJots], applicationActivities: [])
            
            // Need this line for an iPad
            vc.popoverPresentationController?.barButtonItem = toolbarItems![3]
            
            presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    // Makes unique string by concatenating all selected jot's strings
    func stringFromSelectedJots(paths: [NSIndexPath]?) -> String? {
        if paths == nil {
            return nil
        } else {
            var stringsFromSelectedJots = [String]()
            let sortedPaths = paths!.sort {$0.row < $1.row }
            for path in sortedPaths {
                stringsFromSelectedJots.append(jots[path.row].body)
            }
            return stringsFromSelectedJots.joinWithSeparator("\n")
        }
    }
}