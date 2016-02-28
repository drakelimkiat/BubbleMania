//
//  GameBubble.swift
//  BubbleMania
//
//  Created by Lim Kiat on 2/2/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import Foundation

class GameBubble: NSObject, NSCoding {
    
    // MARK: Properties
    
    private(set) var xPosition: Int
    private(set) var yPosition: Int
    
    // MARK: Types
    
    struct PropertyKey {
        static let xPositionKey = "xPosition"
        static let yPositionKey = "yPosition"
    }
    
    // MARK: Initialization
    
    init (xPosition: Int, yPosition: Int) {
        self.xPosition = xPosition
        self.yPosition = yPosition
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder (aCoder: NSCoder) {
        aCoder.encodeInteger(xPosition, forKey: PropertyKey.xPositionKey)
        aCoder.encodeInteger(yPosition, forKey: PropertyKey.yPositionKey)
    }
    
    required convenience init (coder aDecoder: NSCoder) {
        let xPosition = aDecoder.decodeIntegerForKey(PropertyKey.xPositionKey)
        let yPosition = aDecoder.decodeIntegerForKey(PropertyKey.yPositionKey)
        
        // Must call designated initializer.
        self.init(xPosition: xPosition, yPosition: yPosition)
    }
}