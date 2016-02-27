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
    
    private var bubbleColor: String
    
    // MARK: Types
    
    struct PropertyKey {
        static let bubbleColorKey = "bubbleColor"
    }
    
    // MARK: Initialization
    
    init (xPosition: Int, yPosition: Int, bubbleColor: String) {
        self.bubbleColor = bubbleColor
        super.init(xPosition: xPosition, yPosition: yPosition)
    }
    
    // MARK: Getter functions
    
    func getBubbleColor() -> String {
        return bubbleColor
    }
    
    // MARK: NSCoding
    
    override func encodeWithCoder (aCoder: NSCoder) {
        aCoder.encodeInteger(xPosition, forKey: PropertyKey.xPositionKey)
        aCoder.encodeInteger(yPosition, forKey: PropertyKey.yPositionKey)
        aCoder.encodeObject(bubbleColor, forKey: PropertyKey.bubbleColorKey)
    }
    
    required convenience init (coder aDecoder: NSCoder) {
        let xPosition = aDecoder.decodeIntegerForKey(PropertyKey.xPositionKey)
        let yPosition = aDecoder.decodeIntegerForKey(PropertyKey.yPositionKey)
        let bubbleColor = aDecoder.decodeObjectForKey(PropertyKey.bubbleColorKey) as! String
        
        // Must call designated initializer.
        self.init(xPosition: xPosition, yPosition: yPosition, bubbleColor: bubbleColor)
    }
}