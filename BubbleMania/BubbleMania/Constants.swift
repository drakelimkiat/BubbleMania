//
//  Constants.swift
//  BubbleMania
//
//  Created by Lim Kiat on 27/2/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import UIKit

struct Constants {
    
    struct numbers {
        static let paletteUnselectedAlphaValue = CGFloat(0.6)
        static let paletteSelectedAlphaValue = CGFloat(1.0)
        static let maxNumOfBubblesInRow = CGFloat(12)
        static let overlappingPixelsPerRow = 9
        static let bubbleVelocity = 20.0
    }
    
    struct bubbleColorString {
        static let blue = "blue"
        static let red = "red"
        static let orange = "orange"
        static let green = "green"
        static let empty = "empty"
        static let power = "power"
    }
    
    struct specialBubbleString {
        static let bomb = "bomb"
        static let indestructible = "indestructible"
        static let lightning = "lightning"
        static let star = "star"
        static let noPower = "noPower"
    }
    
    struct preloadedLevels {
        static let easy = 1
        static let medium = 4
        static let hard = 9
    }
}