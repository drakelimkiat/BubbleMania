//
//  BasicBubble.swift
//  BubbleMania
//
//  Created by Lim Kiat on 7/2/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import Foundation

class BasicBubble: GameBubble {
    
    // MARK: Properties
    
    private(set) var bubbleColor: String
    private(set) var bubblePower: String
    
    // MARK: Types
    
    struct PropertyKey {
        static let bubbleColorKey = "bubbleColor"
        static let bubblePowerKey = "bubblePower"
    }
    
    // MARK: Initialization
    
    init (xPosition: Int, yPosition: Int, bubbleColor: String, bubblePower: String) {
        self.bubbleColor = bubbleColor
        self.bubblePower = bubblePower
        super.init(xPosition: xPosition, yPosition: yPosition)
    }
    
    // MARK: NSCoding
    
    override func encodeWithCoder (aCoder: NSCoder) {
        aCoder.encodeInteger(xPosition, forKey: PropertyKey.xPositionKey)
        aCoder.encodeInteger(yPosition, forKey: PropertyKey.yPositionKey)
        aCoder.encodeObject(bubbleColor, forKey: PropertyKey.bubbleColorKey)
        aCoder.encodeObject(bubblePower, forKey: PropertyKey.bubblePowerKey)
    }
    
    required convenience init (coder aDecoder: NSCoder) {
        let xPosition = aDecoder.decodeIntegerForKey(PropertyKey.xPositionKey)
        let yPosition = aDecoder.decodeIntegerForKey(PropertyKey.yPositionKey)
        let bubbleColor = aDecoder.decodeObjectForKey(PropertyKey.bubbleColorKey) as! String
        let bubblePower = aDecoder.decodeObjectForKey(PropertyKey.bubblePowerKey) as! String
        
        // Must call designated initializer.
        self.init(xPosition: xPosition, yPosition: yPosition, bubbleColor: bubbleColor, bubblePower: bubblePower)
    }
}