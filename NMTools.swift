//
//  NMTools.swift
//  ParkClub
//
//  Created by Nicolas Manzini on 05.11.15.
//  Copyright © 2015 Nicolas Manzini. All rights reserved.
//

import Foundation
import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func dispatch_main(function:()->Void) {
    dispatch_after(0, dispatch_get_main_queue(), function)
}


extension String: RegularExpressionMatchable {
    /** Return the number of character composing the string.*/
    var length: Int {
        return self.characters.count
    }
    /** Return a Swift Range struct from an Objective-C NSRange struct */
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
                return from ..< to
        }
        return nil
    }
    func NSRangeFromRange(range : Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        let from = String.UTF16View.Index(range.startIndex, within: utf16view)
        let to = String.UTF16View.Index(range.endIndex, within: utf16view)
        return NSMakeRange(utf16view.startIndex.distanceTo(from), from.distanceTo(to))
    }
    
    func stringByRemovingCharactersInSet(characterSet: Set<String>) -> String {
        var aString = self
        for char in characterSet {
            aString = aString.stringByReplacingOccurrencesOfString(char, withString: "")
        }
        return aString
    }
    
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
    
    var isEmail: Bool {
        return self =~ "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,15}$"
    }
    
    func match(pattern: String, options: NSRegularExpressionOptions = []) throws -> Bool {
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        return regex.numberOfMatchesInString(self, options: [], range: NSRange(location: 0, length: 0.distanceTo(utf16.count))) != 0
    }
}

infix operator =~ { associativity left precedence 130 }
func =~<T: RegularExpressionMatchable> (left: T, right: String) -> Bool {
    return try! left.match(right, options: [])
}

protocol RegularExpressionMatchable {
    func match(pattern: String, options: NSRegularExpressionOptions) throws -> Bool
}

extension Bool {
    var stringValue: String {
        if self {
            return "true"
        }
        return "false"
    }
    var intValue: Int {
        if self {
            return 1
        }
        return 0
    }
}

extension NSDate {
    static var currentYear: String {
        let formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy"
        return formatter.stringFromDate(NSDate())
    }
}

class UIStoryboardSegueInanimated: UIStoryboardSegue {
    override func perform() {
        if self.destinationViewController.parentViewController == self.sourceViewController {
            // push
            self.sourceViewController.presentViewController(self.destinationViewController, animated: false, completion: nil)
        } else {
            self.destinationViewController.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}

extension UITableView {
    func  indexPathForView(view: UIView) -> NSIndexPath? {
        var superview = view.superview
        while superview != nil  {
            if superview is UITableViewCell {
                return self.indexPathForCell(superview as! UITableViewCell)
            }
            superview = superview?.superview
        }
        return nil
    }
}
