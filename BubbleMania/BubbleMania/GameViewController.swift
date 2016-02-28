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
    var bubbleGrid: BubbleGrid?
    var projectileBubble: ProjectileBubbleView?
    var projectileBubbleAngle = CGFloat(0)
    var bubbleIsLaunched = false
    var gameEngine: GameEngine?
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
        gameEngine = GameEngine(gameAreaWidth: gameArea.frame.size.width, gameAreaHeight: gameArea.frame.size.height, bubbleGrid: bubbleGrid!, bubbleDiameter: bubbleDiameter!)
        
        // Adding the first frame of UIView
        renderer = Renderer(bubbleGrid: bubbleGrid!, gameAreaFrame: gameArea.frame)
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
            let floatingCluster = bubbleGrid!.findFloatingCluster()
            bubblesToRemove.appendContentsOf(floatingCluster)
            bubbleRemoved = false
        }
        
        // Only detect collisions when a bubble is launched, and check if we need to remove
        // bubbles when a collision happen
        if (bubbleIsLaunched) {
            let (newProjectileBubble, newProjectileBubbleAngle) = gameEngine!.getNewProjectileBubblePosition(projectileBubble!, projectileBubbleAngle: projectileBubbleAngle)
            projectileBubble = newProjectileBubble
            projectileBubbleAngle = newProjectileBubbleAngle
            
            if (gameEngine!.collision(projectileBubble!)) {
                
                let (row, col) = gameEngine!.addNewBubble(projectileBubble!)
                let bubbleClusterWithSameColor = bubbleGrid!.findCluster(row, col: col, matchColor: true, reset: true)
                if (bubbleClusterWithSameColor.count > 2) {
                    bubblesToRemove.appendContentsOf(bubbleClusterWithSameColor)
                    bubbleRemoved = true
                }
                bubbleIsLaunched = false
                addNewProjectileBubble()
            }
        }
        
        if (!bubblesToRemove.isEmpty) {
            gameEngine!.removeBubblesFromArray(bubblesToRemove)
        }
        
        // Update the UIView with the new properties
        renderer!.updateRendererProperties(bubbleGrid!, projectileBubble: projectileBubble!, bubbleIsLaunched: bubbleIsLaunched, bubblesToRemove: bubblesToRemove)
        currentView = renderer!.render()
        self.view.addSubview(currentView!)
        self.view.bringSubviewToFront(gameCannon)
        self.view.bringSubviewToFront(cannonBase)
        if let projectileBubble = projectileBubble {
            self.view.bringSubviewToFront(projectileBubble)
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
