//
//  GameEngine.swift
//  BubbleMania
//
//  Created by Lim Kiat on 28/2/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import UIKit
import Darwin

class GameEngine {
    
    private var bubbleGrid: BubbleGrid
    private var physicsEngine: PhysicsEngine
    private var bubbleDiameter: CGFloat
    
    init (gameAreaWidth: CGFloat, gameAreaHeight: CGFloat, bubbleGrid: BubbleGrid,
        bubbleDiameter: CGFloat) {
        self.physicsEngine = PhysicsEngine(leftWall: 0.0, rightWall: gameAreaWidth, ceiling: 0.0,
            floor: gameAreaHeight)
        self.bubbleGrid = bubbleGrid
        self.bubbleDiameter = bubbleDiameter
    }
    
    func getNextProjectileBubbleColor() -> String {
        var colorArray = [String]()
        let bubbleViewArray = bubbleGrid.bubbleViewArray
        
        for bubbleViewRow in bubbleViewArray {
            for bubbleView in bubbleViewRow {
                if (bubbleView.color != Constants.bubbleColorString.empty) {
                    colorArray.append(bubbleView.color)
                }
            }
        }
        
        let randomColor: String
        
        if (colorArray.count == 0) {
            randomColor = Constants.bubbleColorString.empty
        } else {
            randomColor = colorArray[Int(arc4random_uniform(UInt32(colorArray.count)))]
        }
        
        return randomColor
    }
    
    // Uses the physicsEngine to calculate next position
    func getNewProjectileBubblePosition(projectileBubble: ProjectileBubbleView, projectileBubbleAngle: CGFloat)
        -> (ProjectileBubbleView, CGFloat) {
        let xPosition = projectileBubble.xPosition
        let yPosition = projectileBubble.yPosition
        let vector = physicsEngine.getNextPosition(xPosition, y: yPosition, width: bubbleDiameter, height: bubbleDiameter,
            angle: Double(projectileBubbleAngle), velocity: Constants.numbers.bubbleVelocity)
        
        projectileBubble.xPosition = vector.xPosition
        projectileBubble.yPosition = vector.yPosition
        let newProjectileBubbleAngle = CGFloat(vector.angle)
        
        return (projectileBubble, newProjectileBubbleAngle)
    }
    
    func collision(projectileBubble: ProjectileBubbleView) -> Bool {
        // A collision happens if the bubble hits the ceiling
        if (projectileBubble.yPosition <= 0.0) {
            return true
        }
        
        let radius = bubbleDiameter / 2
        
        let bubbleViewArray = bubbleGrid.bubbleViewArray
        
        // For each bubbleView, check if the projectile bubble and the bubbles intersect using physicsEngine
        for bubbleViewRow in bubbleViewArray {
            for bubbleView in bubbleViewRow {
                
                if (bubbleView.color != Constants.bubbleColorString.empty) {
                    let bubbleViewX = Double(bubbleView.frame.origin.x + radius)
                    let bubbleViewY = Double(bubbleView.frame.origin.y + radius)
                    let projectileBubbleViewX = Double(projectileBubble.xPosition + radius)
                    let projectileBubbleViewY = Double(projectileBubble.yPosition + radius)
                    
                    if (physicsEngine.circleIntersection(bubbleViewX, y1: bubbleViewY, r1: Double(radius), x2: projectileBubbleViewX, y2: projectileBubbleViewY, r2: Double(radius))) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    // Add new bubble to BubbleViewArray when a collision happens
    func addNewBubble(projectileBubble: ProjectileBubbleView) -> (Int, Int) {
        let projectileBubbleViewX = projectileBubble.xPosition + bubbleDiameter / 2
        let projectileBubbleViewY = projectileBubble.yPosition + bubbleDiameter / 2
        let row = Int(floor(projectileBubbleViewY / (bubbleDiameter - CGFloat(Constants.numbers.overlappingPixelsPerRow))))
        var col = 0
        
        if (row % 2 == 0) {
            col = Int(floor(projectileBubbleViewX / bubbleDiameter))
        } else {
            col = Int(floor((projectileBubbleViewX - (bubbleDiameter / 2)) / bubbleDiameter))
        }
        
        var bubbleViewArray = bubbleGrid.bubbleViewArray
        var rowCount = bubbleViewArray.count
        
        while (row >= rowCount) {
            let bubbleViewRow = addNewRow(row)
            bubbleViewArray.append(bubbleViewRow)
            rowCount++
        }
        
        let bubbleView = bubbleViewArray[row][col]
        bubbleView.setBubbleColor(projectileBubble.color)
        bubbleGrid.bubbleViewArray = bubbleViewArray
        return (row, col)
    }
    
    // Additional rows have to be added to BubbleViewArray if the row that the new bubble snaps to is greater than 9
    private func addNewRow(row: Int) -> [BubbleView] {
        let intBubbleDiameter = Int(bubbleDiameter)
        var bubbleArray = [BubbleView]()
        let even = (row % 2) == 0
        var startingXPosition = 0
        let yPosition = (row * intBubbleDiameter) - (row * 9)
        
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
        return bubbleArray
    }
    
    // "Removes" a bubble from BubbleGrid by setting the color as "empty"
    func removeBubblesFromGrid(bubbleArray: [BubbleView]) {
        let bubbleViewArray = bubbleGrid.bubbleViewArray
        
        for bubble in bubbleArray {
            let row = bubble.row!
            let col = bubble.col!
            bubbleViewArray[row][col].setBubbleColor("empty")
        }
    }
}