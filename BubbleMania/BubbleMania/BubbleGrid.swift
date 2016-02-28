//
//  BubbleGrid.swift
//  BubbleMania
//
//  Created by Lim Kiat on 28/2/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import UIKit

class BubbleGrid {
    
    var bubbleViewArray: [[BubbleView]]
    
    init (bubbleViewArray: [[BubbleView]]) {
        self.bubbleViewArray = bubbleViewArray
    }
    
    subscript(row: Int, col: Int) -> BubbleView {
        get {
            return bubbleViewArray[row][col]
        }
        
        set {
            bubbleViewArray[row][col] = newValue
        }
    }
    
    // This method allows us to find a cluster of bubbles near a specified bubble
    // Can be of same color or different depending on bool value given
    func findCluster(row: Int, col: Int, matchColor: Bool, reset: Bool) -> [BubbleView] {
        if (reset) {
            resetBubbleViews()
        }
        
        // Uses a stack of unvisitedBubbles and search in a DFS manner
        let targetBubbleView = bubbleViewArray[row][col]
        var unvisitedBubbles = [targetBubbleView]
        targetBubbleView.setCheck()
        var bubbleCluster = [BubbleView]()
        
        while (unvisitedBubbles.count > 0) {
            let currentBubbleView = unvisitedBubbles.removeLast()
            var neighbouringBubbles = [BubbleView]()
            
            if (currentBubbleView.color == Constants.bubbleColorString.empty) {
                continue
            }
            
            if (matchColor) {
                neighbouringBubbles = getBubblesOfSameColor(currentBubbleView)
            } else {
                neighbouringBubbles = getNeighbouringBubbles(currentBubbleView)
            }
            
            for bubble in neighbouringBubbles {
                if (!unvisitedBubbles.contains(bubble) && !bubble.isChecked()) {
                    unvisitedBubbles.append(bubble)
                    bubble.setCheck()
                }
            }
            bubbleCluster.append(currentBubbleView)
        }
        return bubbleCluster
    }
    
    // findFloatingCluster makes use of findCluster method
    func findFloatingCluster() -> [BubbleView] {
        var floatingBubbles = [BubbleView]()
        resetBubbleViews()
        
        for bubbleRowArray in bubbleViewArray {
            for bubble in bubbleRowArray {
                if (!bubble.isChecked()) {
                    if (bubble.color != "empty") {
                        let bubbleCluster = findCluster(bubble.row!, col: bubble.col!, matchColor: false, reset: true)
                        var touchingTop = false
                        
                        for clusterBubble in bubbleCluster {
                            if (clusterBubble.row! == 0) {
                                touchingTop = true
                            }
                        }
                        if (!touchingTop) {
                            floatingBubbles.append(bubble)
                        }
                    }
                }
            }
        }
        return floatingBubbles
    }
    
    func findPowerCluster(row: Int, col: Int) -> [BubbleView] {
        resetBubbleViews()
        
        var bubblesAffected = [BubbleView]()
        var newPowerBubblesFound = [BubbleView]()
        let targetBubbleView = bubbleViewArray[row][col]
        let targetBubbleViewNeighbours = getNeighbouringBubbles(targetBubbleView)
        
        for bubbleView in targetBubbleViewNeighbours {
            if (bubbleView.power != Constants.specialBubbleString.noPower &&
                bubbleView.power != Constants.specialBubbleString.indestructible) {
                newPowerBubblesFound.append(bubbleView)
                bubblesAffected.append(bubbleView)
                bubbleView.setCheck()
            }
        }
        
        if (bubblesAffected.count > 0) {
            bubblesAffected.append(targetBubbleView)
            targetBubbleView.setCheck()
        }
        
        while (!newPowerBubblesFound.isEmpty) {
            let currentPowerBubble = newPowerBubblesFound[0]
            var newBubblesAffected = [BubbleView]()
            
            if (currentPowerBubble.power == Constants.specialBubbleString.bomb) {
                newBubblesAffected.appendContentsOf(getNeighbouringBubbles(currentPowerBubble))
            } else if (currentPowerBubble.power == Constants.specialBubbleString.lightning) {
                newBubblesAffected.appendContentsOf(bubbleViewArray[currentPowerBubble.row!])
            } else if (currentPowerBubble.power == Constants.specialBubbleString.star) {
                let bubblesOfSameColorArray = getBubblesOfSameColorInGrid(targetBubbleView)
                newBubblesAffected.appendContentsOf(bubblesOfSameColorArray)
            }
            
            for bubble in newBubblesAffected {
                if (!bubblesAffected.contains(bubble) && !bubble.isChecked()) {
                    bubblesAffected.append(bubble)
                    bubble.setCheck()
                    if (bubble.power != Constants.specialBubbleString.noPower &&
                        bubble.power != Constants.specialBubbleString.indestructible) {
                            newPowerBubblesFound.append(bubble)
                    }
                }
            }
            newPowerBubblesFound.removeFirst()
        }
        
        return bubblesAffected
    }
    
    private func getNeighbouringBubbles(targetBubbleView: BubbleView) -> [BubbleView] {
        let row = targetBubbleView.row!
        let col = targetBubbleView.col!
        var neighbours = [BubbleView]()
        
        // Neighbour offset table to use in calculating the rows and cols of neighbouring bubbles
        let neighboursOffset = [[[-1, -1], [-1, 0], [0, -1], [0, 1], [1, 0], [1, -1]], // Even rowIndex
            [[-1, 0], [-1, 1], [0, -1], [0, 1], [1, 0], [1, 1]]]  // Odd rowIndex
        var targetNeighboursOffset = [[Int]]()
        
        if (row % 2 == 0) {
            targetNeighboursOffset = neighboursOffset[0]
        } else {
            targetNeighboursOffset = neighboursOffset[1]
        }
        
        for offset in targetNeighboursOffset {
            let currentRow = row + offset[0]
            let currentCol = col + offset[1]
            
            if (currentRow > -1 && currentRow < bubbleViewArray.count) {
                let bubbleRowArray = bubbleViewArray[currentRow]
                if (currentCol > -1 && currentCol < bubbleRowArray.count) {
                    let currentBubbleView = bubbleRowArray[currentCol]
                    if (currentBubbleView.color != "empty") {
                        neighbours.append(currentBubbleView)
                    }
                }
            }
        }
        return neighbours
    }
    
    // Makes use of getNeighbouringBubbles and takes out the bubbles with the same color
    private func getBubblesOfSameColor(targetBubbleView: BubbleView) -> [BubbleView] {
        let neighbouringBubbles = getNeighbouringBubbles(targetBubbleView)
        var neighbouringBubblesOfSameColor = [BubbleView]()
        
        for bubble in neighbouringBubbles {
            if (bubble.color == targetBubbleView.color) {
                neighbouringBubblesOfSameColor.append(bubble)
            }
        }
        return neighbouringBubblesOfSameColor
    }
    
    private func getBubblesOfSameColorInGrid(targetBubbleView: BubbleView) -> [BubbleView] {
        var bubbleArray = [BubbleView]()
        
        for bubbleRowArray in bubbleViewArray {
            for bubble in bubbleRowArray {
                if (bubble.color == targetBubbleView.color) {
                    bubbleArray.append(bubble)
                }
            }
        }
        return bubbleArray
    }
    
    // Resets the isChecked boolean for all bubbles in BubbleViewArray
    private func resetBubbleViews() {
        
        for (var i = 0; i < bubbleViewArray.count; i++) {
            let even = (i % 2) == 0
            
            for (var j = 0; j < 12; j++) {
                // Odd rows only have 11 BubbleViews
                if (!even && j == 11) {
                    break
                }
                let bubbleView = bubbleViewArray[i][j]
                bubbleView.resetCheck()
            }
        }
    }
}
