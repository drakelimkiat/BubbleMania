//
//  PreloadedLevels.swift
//  BubbleMania
//
//  Created by Lim Kiat on 28/2/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import UIKit

class PreloadedLevels {
    
    let gameAreaWidth: CGFloat
    
    init (gameAreaWidth: CGFloat) {
        self.gameAreaWidth = gameAreaWidth
    }
    
    func getEasyLevel() -> BubbleGrid {
        let bubbleViewArray = setUpGrid()
        let bubbleGrid = BubbleGrid(bubbleViewArray: bubbleViewArray)
        return bubbleGrid
    }
    
    func getMediumLevel() -> BubbleGrid {
        let bubbleViewArray = setUpGrid()
        let bubbleGrid = BubbleGrid(bubbleViewArray: bubbleViewArray)
        return bubbleGrid
    }
    
    func getHardLevel() -> BubbleGrid {
        let bubbleViewArray = setUpGrid()
        let bubbleGrid = BubbleGrid(bubbleViewArray: bubbleViewArray)
        return bubbleGrid
    }
    
    // Populates grid by adding 9 rows of BubbleViews
    private func setUpGrid() -> [[BubbleView]] {
        var bubbleViewArray = [[BubbleView]]()
        let bubbleDiameter = gameAreaWidth / Constants.numbers.maxNumOfBubblesInRow
        let intBubbleDiameter = Int(bubbleDiameter)
        
        for row in 0..<9 {
            var bubbleArray = [BubbleView]()
            let even = (row % 2) == 0
            var startingXPosition = 0
            let yPosition = (row * intBubbleDiameter) - (row * Constants.numbers.overlappingPixelsPerRow)
            
            if (even) {
                startingXPosition = 0
            } else {
                startingXPosition = intBubbleDiameter / 2
            }
            
            for col in 0..<12 {
                // Odd rowIndexes only have 11 BubbleViews
                if (!even && col == 11) {
                    break
                }
                
                let bubblePoint = CGPoint(x: startingXPosition + (col * intBubbleDiameter), y: yPosition)
                let bubbleSize = CGSize(width: intBubbleDiameter, height: intBubbleDiameter)
                let bubbleRect = CGRect(origin: bubblePoint, size: bubbleSize)
                let bubbleView = BubbleView(frame: bubbleRect, row: row, col: col)
                bubbleArray.append(bubbleView)
            }
            bubbleViewArray.append(bubbleArray)
        }
        return bubbleViewArray
    }
}