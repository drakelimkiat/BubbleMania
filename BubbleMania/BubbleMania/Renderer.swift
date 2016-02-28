//
//  Renderer.swift
//  BubbleMania
//
//  Created by Lim Kiat on 14/2/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import UIKit

class Renderer {
    
    private var gameAreaFrame: CGRect
    private var bubbleViewArray: [[BubbleView]]
    private var gameArea: UIView?
    private var projectileBubble: ProjectileBubbleView?
    private var projectileBubbleAngle: CGFloat?
    private var bubbleIsLaunched = false
    private var bubblesToRemove: [BubbleView]?
    
    init(bubbleViewArray: [[BubbleView]], gameAreaFrame: CGRect) {
        self.gameAreaFrame = gameAreaFrame
        self.bubbleViewArray = bubbleViewArray
    }
    
    // Allows you to update the properties of the renderer, so they can be used in render()
    func updateRendererProperties(bubbleViewArray: [[BubbleView]], projectileBubble: ProjectileBubbleView,
        bubbleIsLaunched: Bool, bubblesToRemove: [BubbleView]) {
        self.bubbleViewArray = bubbleViewArray
        self.projectileBubble = projectileBubble
        self.bubbleIsLaunched = bubbleIsLaunched
        self.bubblesToRemove = bubblesToRemove
    }
    
    // Draws the new frame using the updated BubbleViewArray, and updated position of a projectileBubble if there is one
    func render() -> UIView {
        gameArea = UIView(frame: gameAreaFrame)
        
        setUpGameArea()
        setUpGrid()
        
        if let projectileBubble = self.projectileBubble {
            if (bubbleIsLaunched) {
                let x = CGFloat(projectileBubble.xPosition)
                let y = CGFloat(projectileBubble.yPosition)
                let bubbleDiameter = gameArea!.frame.size.width / Constants.numbers.maxNumOfBubblesInRow
                let intBubbleDiameter = Int(bubbleDiameter)
                let bubblePoint = CGPoint(x: x, y: y)
                let bubbleSize = CGSize(width: intBubbleDiameter, height: intBubbleDiameter)
                let bubbleRect = CGRect(origin: bubblePoint, size: bubbleSize)
                let projectileBubbleView = ProjectileBubbleView(frame: bubbleRect)
                
                projectileBubbleView.setBubbleColor(projectileBubble.color)
                gameArea?.addSubview(projectileBubbleView)
            }
        }

        return gameArea!
    }
    
    // Methods for setting up game area and grid (similar to ViewController)
    private func setUpGameArea() {
        let backgroundImage = UIImage(named: "background.png")
        let background = UIImageView(image: backgroundImage)
        
        let gameViewHeight = gameArea!.frame.size.height
        let gameViewWidth = gameArea!.frame.size.width
        
        background.frame = CGRectMake(0, 0, gameViewWidth, gameViewHeight)
        
        gameArea!.addSubview(background)
    }
    
    private func setUpGrid() {
        for row in 0..<bubbleViewArray.count {
            let even = (row % 2) == 0
            
            for col in 0..<12 {
                // Odd rows only have 11 BubbleViews
                if (!even && col == 11) {
                    break
                }
                let bubbleView = bubbleViewArray[row][col]
                // We will not draw the bubble if its an empty one
                if (bubbleView.color != "empty") {
                    gameArea!.addSubview(bubbleView)
                }
            }
        }
    }

}