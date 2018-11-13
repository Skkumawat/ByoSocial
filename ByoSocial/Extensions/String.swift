//
//  String.swift
//  ByoSocial
//
//  Created by Sharvan Kumawat on 11/12/18.
//  Copyright © 2018 Sharvan. All rights reserved.
//

import Foundation
import UIKit


public extension String {
    public static func format(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        if duration >= 3600 {
            formatter.allowedUnits.insert(.hour)
        }
        return formatter.string(from: duration)!
    }
    
    public func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    public static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    public func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    public func startWith(_ find: String) -> Bool {
        return self.hasPrefix(find)
    }
    
    public func equals(_ find: String) -> Bool {
        return self == find
    }
    
    public func contains(_ find: String) -> Bool {
        if let _ = self.range(of: find) {
            return true
        }
        return false
    }
    
    public var length: Int {
        return self.characters.count
    }
    
    public var str: NSString {
        return self as NSString
    }
    public var pathExtension: String {
        return str.pathExtension 
    }
    public var lastPathComponent: String {
        return str.lastPathComponent 
    }
    
    public func boolValue() -> Bool? {
        var returnValue:Bool = false
        let falseValues = ["false", "no", "0"]
        let lowerSelf = self.lowercased()
        
        if falseValues.contains(lowerSelf) {
            returnValue =  false
        } else {
            returnValue = true
        }
        return returnValue
    }
    
    public var floatValue: Float {
        return (self as NSString).floatValue
    }
    public var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
    func URLEncodedString() -> String {
        let customAllowedSet =  CharacterSet.urlQueryAllowed
        let escapedString = self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
        return escapedString ?? ""
    }
    
    public func makeURL() -> URL? {
        
        let trimmed = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let url = URL(string: trimmed ?? "") else {
            return nil
        }
        return url
    }
    
    static func heightForText(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        
        let rect = NSString(string: text).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(rect.height)
    }
    
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: String.CompareOptions.literal, range: nil)
    }
    static func widthForText(_ text: String, font: UIFont, height: CGFloat) -> CGFloat {
        
        let rect = NSString(string: text).boundingRect(with: CGSize(width:  CGFloat(MAXFLOAT), height:height), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(rect.width)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }

    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined(separator: "")
    }
}
