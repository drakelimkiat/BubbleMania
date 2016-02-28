//
//  GameViewController.swift
//  BubbleMania
//
//  Created by Lim Kiat on 13/2/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameArea: UIView!
    @IBOutlet weak var gameCannon: UIView!
    @IBOutlet weak var cannonBase: UIView!
    var bubbleViewArray = [[BubbleView]]()
    var projectileBubble: ProjectileBubbleView?
    var projectileBubbleAngle = CGFloat(0)
    var bubbleIsLaunched = false
    var physicsEngine: PhysicsEngine?
    var renderer: Renderer?
    var currentView: UIView?
    var bubbleRemoved = true
    var bubbleDiameter: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Setting up cannon view, and class properties
        bubbleDiameter = gameArea.frame.size.width / Constants.numbers.maxNumOfBubblesInRow
        setUpCannon()
        addNewProjectileBubble()
        physicsEngine = PhysicsEngine(leftWall: 0.0, rightWall: gameArea.frame.width, ceiling: 0.0,
            floor: gameArea.frame.height)
        
        // Adding the first frame of UIView
        renderer = Renderer(bubbleViewArray: bubbleViewArray, gameAreaFrame: gameArea.frame)
        currentView = renderer!.render()
        self.view.addSubview(currentView!)
        self.view.bringSubviewToFront(gameCannon)
        self.view.bringSubviewToFront(cannonBase)
        self.view.bringSubviewToFront(projectileBubble!)
        
        // Timer that will be called every 1/60 seconds to update the UIView
        let _ = NSTimer.scheduledTimerWithTimeInterval(1/60, target: self, selector: "getNewView", userInfo: nil, repeats: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUpCannon() {
        let cannonImage = UIImage(named: "cannon_1.png")
        let cannon = UIImageView(image: cannonImage)
        let cannonWidth = gameCannon.frame.size.width
        let cannonHeight = gameCannon.frame.size.height
        cannon.frame = CGRectMake(0, 0, cannonWidth, cannonHeight)
        setAnchorPoint(CGPointMake(0.5, 1), view: gameCannon)
        self.gameCannon.addSubview(cannon)
        
        let cannonBaseImage = UIImage(named: "cannon-base.png")
        let base = UIImageView(image: cannonBaseImage)
        let baseWidth = cannonBase.frame.size.width
        let baseHeight = cannonBase.frame.size.height
        base.frame = CGRectMake(0, 0, baseWidth, baseHeight)
        self.cannonBase.addSubview(base)
    }
    
    // This method is used to set the anchor point of a UIView which it rotates at
    private func setAnchorPoint(anchorPoint: CGPoint, view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position : CGPoint = view.layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    // Adds a new bubble to be launched at the cannon (current implementation is a default green color)
    // Color can be changed by tapping on the cannon
    private func addNewProjectileBubble() {
        let intBubbleDiameter = Int(bubbleDiameter!)
        let x = gameArea.frame.size.width / 2 - bubbleDiameter! / 2
        let y = CGFloat(940)
        
        let bubblePoint = CGPoint(x: x, y: y)
        let bubbleSize = CGSize(width: intBubbleDiameter, height: intBubbleDiameter)
        let bubbleRect = CGRect(origin: bubblePoint, size: bubbleSize)
        let projectileBubbleView = ProjectileBubbleView(frame: bubbleRect)
        
        projectileBubbleView.setBubbleColor("green")
        self.view.addSubview(projectileBubbleView)
        projectileBubble = projectileBubbleView
    }

    
    // Method to call to update the UIView
    func getNewView() {
        currentView?.removeFromSuperview()
        var bubblesToRemove = [BubbleView]()
        
        // Only check for floating clusters when a bubble has been removed
        // bubbleRemoved set to true at the start to remove and floating cluster at the start of the game
        if (bubbleRemoved) {
            let floatingCluster = findFloatingCluster()
            bubblesToRemove.appendContentsOf(floatingCluster)
            bubbleRemoved = false
        }
        
        // Only detect collisions when a bubble is launched, and check if we need to remove
        // bubbles when a collision happen
        if (bubbleIsLaunched) {
            getNewProjectileBubblePosition()
            if (collision()) {
                let (row, col) = addNewBubble()
                let bubbleClusterWithSameColor = findCluster(row, col: col, matchColor: true, reset: true)
                if (bubbleClusterWithSameColor.count > 2) {
                    bubblesToRemove.appendContentsOf(bubbleClusterWithSameColor)
                    bubbleRemoved = true
                }
                bubbleIsLaunched = false
                addNewProjectileBubble()
            }
        }
        
        if (!bubblesToRemove.isEmpty) {
            removeBubblesFromArray(bubblesToRemove)
        }
        
        // Update the UIView with the new properties
        renderer!.updateRendererProperties(bubbleViewArray, projectileBubble: projectileBubble!, bubbleIsLaunched: bubbleIsLaunched, bubblesToRemove: bubblesToRemove)
        currentView = renderer!.render()
        self.view.addSubview(currentView!)
        self.view.bringSubviewToFront(gameCannon)
        self.view.bringSubviewToFront(cannonBase)
        if let projectileBubble = projectileBubble {
            self.view.bringSubviewToFront(projectileBubble)
        }
    }
    
    // Uses the physicsEngine to calculate next position
    private func getNewProjectileBubblePosition() {
        let xPosition = projectileBubble!.xPosition
        let yPosition = projectileBubble!.yPosition
        let vector = physicsEngine!.getNextPosition(xPosition, y: yPosition, width: bubbleDiameter!, height: bubbleDiameter!,
            angle: Double(projectileBubbleAngle), velocity: Constants.numbers.bubbleVelocity)
        
        projectileBubble?.xPosition = vector.xPosition
        projectileBubble?.yPosition = vector.yPosition
        projectileBubbleAngle = CGFloat(vector.angle)
    }
    
    private func collision() -> Bool {
        // A collision happens if the bubble hits the ceiling
        if (projectileBubble?.yPosition <= 0.0) {
            return true
        }
        
        let radius = bubbleDiameter! / 2
        
        // For each bubbleView, check if the projectile bubble and the bubbles intersect using physicsEngine
        for bubbleViewRow in bubbleViewArray {
            for bubbleView in bubbleViewRow {
                
                if (bubbleView.color != "empty") {
                    let bubbleViewX = Double(bubbleView.frame.origin.x + radius)
                    let bubbleViewY = Double(bubbleView.frame.origin.y + radius)
                    let projectileBubbleViewX = Double(projectileBubble!.xPosition + radius)
                    let projectileBubbleViewY = Double(projectileBubble!.yPosition + radius)
                    
                    if (physicsEngine!.circleIntersection(bubbleViewX, y1: bubbleViewY, r1: Double(radius), x2: projectileBubbleViewX, y2: projectileBubbleViewY, r2: Double(radius))) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    // Add new bubble to BubbleViewArray when a collision happens
    private func addNewBubble() -> (Int, Int) {
        let projectileBubbleViewX = projectileBubble!.xPosition + bubbleDiameter! / 2
        let projectileBubbleViewY = projectileBubble!.yPosition + bubbleDiameter! / 2
        let row = Int(floor(projectileBubbleViewY / (bubbleDiameter! - CGFloat(Constants.numbers.overlappingPixelsPerRow))))
        var col = 0
        
        if (row % 2 == 0) {
            col = Int(floor(projectileBubbleViewX / bubbleDiameter!))
        } else {
            col = Int(floor((projectileBubbleViewX - (bubbleDiameter! / 2)) / bubbleDiameter!))
        }
        
        var numberOfRows = bubbleViewArray.count
        
        while (row >= numberOfRows) {
            let bubbleViewRow = addNewRow(row)
            bubbleViewArray.append(bubbleViewRow)
            numberOfRows++
        }
        
        let bubbleView = bubbleViewArray[row][col]
        bubbleView.setBubbleColor((projectileBubble?.color)!)
        return (row, col)
    }
    
    // Additional rows have to be added to BubbleViewArray if the row that the new bubble snaps to is greater than 9
    private func addNewRow(row: Int) -> [BubbleView] {
        let intBubbleDiameter = Int(bubbleDiameter!)
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
    
    // This method allows us to find a cluster of bubbles near a specified bubble
    // Can be of same color or different depending on bool value given
    private func findCluster(row: Int, col: Int, matchColor: Bool, reset: Bool) -> [BubbleView] {
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
            
            if (currentBubbleView.color == "empty") {
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
    private func findFloatingCluster() -> [BubbleView] {
        var floatingBubbles = [BubbleView]()
        
        for bubbleRowArray in bubbleViewArray {
            for bubble in bubbleRowArray {

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
        return floatingBubbles
    }
    
    // Neighbour offset table to use in calculating the rows and cols of neighbouring bubbles
    var neighboursOffsets = [[[-1, -1], [-1, 0], [0, -1], [0, 1], [1, 0], [1, -1]], // Even row
        [[-1, 0], [-1, 1], [0, -1], [0, 1], [1, 0], [1, 1]]]  // Odd row
    
    private func getNeighbouringBubbles(targetBubbleView: BubbleView) -> [BubbleView] {
        let row = targetBubbleView.row!
        let col = targetBubbleView.col!
        var neighbours = [BubbleView]()
        var neighboursOffset = [[Int]]()
        
        if (row % 2 == 0) {
            neighboursOffset = neighboursOffsets[0]
        } else {
            neighboursOffset = neighboursOffsets[1]
        }
        
        for offset in neighboursOffset {
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
    
    // "Removes" a bubble from BubbleViewArray by setting the color as "empty"
    private func removeBubblesFromArray(bubbleArray: [BubbleView]) {
        for bubble in bubbleArray {
            let row = bubble.row!
            let col = bubble.col!
            bubbleViewArray[row][col].setBubbleColor("empty")
        }
    }
    
    // Angle is calculated here by using the point touched on the screen
    // More detailed explantion in answers.txt
    @IBAction func handleTap(tapRecognizer: UITapGestureRecognizer) {
        let tapRecognizerView = tapRecognizer.view
        let tapPoint = tapRecognizer.locationInView(tapRecognizerView)
            
        let x = tapPoint.x - gameCannon.center.x
        let y = tapPoint.y - gameCannon.center.y
        let angle = atan2(y, x)
        gameCannon.transform = CGAffineTransformMakeRotation(angle + CGFloat(M_PI_2))
        
        if (!bubbleIsLaunched) {
            projectileBubble!.removeFromSuperview()
            bubbleIsLaunched = true
            
            let deltaX = tapPoint.x - gameArea.center.x
            let deltaY = gameArea.frame.size.height - tapPoint.y
            
            projectileBubbleAngle = atan2(deltaY, deltaX)
            
            if projectileBubbleAngle < 0 {
                projectileBubbleAngle += CGFloat(M_PI)
            }
        }
    }
    
    // Pan handler has not been fully implemented due to time constraints
    @IBAction func handlePan(panRecognizer: UIPanGestureRecognizer) {
        let panRecognizerView = panRecognizer.view
        let dragPoint = panRecognizer.locationInView(panRecognizerView)
        let x = dragPoint.x - gameCannon.center.x
        let y = dragPoint.y - gameCannon.center.y
        let angle = atan2(y, x)
        gameCannon.transform = CGAffineTransformMakeRotation(angle + CGFloat(M_PI_2))
    }
    
    // Tap on the cannon to change color
    @IBAction func handleTapOnCannon(tapRecognizer: UITapGestureRecognizer) {
        if (!bubbleIsLaunched) {
            projectileBubble!.cycleBubbleColor()
        }
    }
}
