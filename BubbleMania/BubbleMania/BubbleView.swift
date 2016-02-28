//
//  BubbleView.swift
//  BubbleMania
//
//  Created by Lim Kiat on 31/1/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import UIKit

class BubbleView: UIView {
    
    // MARK: Properties
    
    private var blueBubbleColor: UIColor?
    private var redBubbleColor: UIColor?
    private var orangeBubbleColor: UIColor?
    private var greenBubbleColor: UIColor?
    private var bombBubble: UIColor?
    private var indestructibleBubble: UIColor?
    private var lightningBubble: UIColor?
    private var starBubble: UIColor?
    private(set) var color: String
    private(set) var power: String
    private var checked = false
    private(set) var row: Int?
    private(set) var col: Int?
    
    // MARK: Initialization
    
    override init (frame: CGRect) {
        self.color = Constants.bubbleColorString.empty
        self.power = Constants.specialBubbleString.noPower
        super.init(frame: frame)
        initBorderStyle()
        setUpBubblesUIColors()
    }
    
    init (frame: CGRect, row: Int, col: Int) {
        self.color = Constants.bubbleColorString.empty
        self.power = Constants.specialBubbleString.noPower
        self.row = row
        self.col = col
        super.init(frame: frame)
        initBorderStyle()
        setUpBubblesUIColors()
    }
    
    required init? (coder aDecoder: NSCoder) {
        self.color = Constants.bubbleColorString.empty
        self.power = Constants.specialBubbleString.noPower
        super.init(coder: aDecoder)
    }
    
    // MARK: Private functions
    
    // Trims the rectangular frame to a circle
    private func initBorderStyle() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 2.0
        self.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.3)
    }
    
    // Converts all the images to UIColors for easy use in other functions
    private func setUpBubblesUIColors() {
        let blueBubbleImage = UIImage(named: "bubble-blue.png")
        let scaledBlueBubbleImage = scaleUIImageToSize(blueBubbleImage!)
        blueBubbleColor = UIColor(patternImage: scaledBlueBubbleImage)
        
        let redBubbleImage = UIImage(named: "bubble-red.png")
        let scaledRedBubbleImage = scaleUIImageToSize(redBubbleImage!)
        redBubbleColor = UIColor(patternImage: scaledRedBubbleImage)
        
        let orangeBubbleImage = UIImage(named: "bubble-orange.png")
        let scaledOrangeBubbleImage = scaleUIImageToSize(orangeBubbleImage!)
        orangeBubbleColor = UIColor(patternImage: scaledOrangeBubbleImage)
        
        let greenBubbleImage = UIImage(named: "bubble-green.png")
        let scaledGreenBubbleImage = scaleUIImageToSize(greenBubbleImage!)
        greenBubbleColor = UIColor(patternImage: scaledGreenBubbleImage)
        
        let bombBubbleImage = UIImage(named: "bubble-bomb.png")
        let scaledBombBubbleImage = scaleUIImageToSize(bombBubbleImage!)
        bombBubble = UIColor(patternImage: scaledBombBubbleImage)
        
        let indestructibleBubbleImage = UIImage(named: "bubble-indestructible.png")
        let scaledIndestructibleBubbleImage = scaleUIImageToSize(indestructibleBubbleImage!)
        indestructibleBubble = UIColor(patternImage: scaledIndestructibleBubbleImage)
        
        let lightningBubbleImage = UIImage(named: "bubble-lightning.png")
        let scaledLightningBubbleImage = scaleUIImageToSize(lightningBubbleImage!)
        lightningBubble = UIColor(patternImage: scaledLightningBubbleImage)
        
        let starBubbleImage = UIImage(named: "bubble-star.png")
        let scaledStarBubbleImage = scaleUIImageToSize(starBubbleImage!)
        starBubble = UIColor(patternImage: scaledStarBubbleImage)
    }
    
    // Scales the bubble images to correct size
    private func scaleUIImageToSize(image: UIImage) -> UIImage {
        let size = self.frame.size
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    // MARK: Public functions
    
    func clearBubble() {
        self.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.3)
        self.color = Constants.bubbleColorString.empty
        self.power = Constants.specialBubbleString.noPower
    }
    
    func setBubble(selectedBubbleTitle: String) {
        
        switch selectedBubbleTitle {
            
        case Constants.bubbleColorString.blue:
            self.backgroundColor = blueBubbleColor
            self.color = selectedBubbleTitle
            self.power = Constants.specialBubbleString.noPower
            
        case Constants.bubbleColorString.red:
            self.backgroundColor = redBubbleColor
            self.color = selectedBubbleTitle
            self.power = Constants.specialBubbleString.noPower
            
        case Constants.bubbleColorString.orange:
            self.backgroundColor = orangeBubbleColor
            self.color = selectedBubbleTitle
            self.power = Constants.specialBubbleString.noPower
            
        case Constants.bubbleColorString.green:
            self.backgroundColor = greenBubbleColor
            self.color = selectedBubbleTitle
            self.power = Constants.specialBubbleString.noPower
            
        case Constants.specialBubbleString.bomb:
            self.backgroundColor = bombBubble
            self.color = Constants.bubbleColorString.power
            self.power = Constants.specialBubbleString.bomb
            
        case Constants.specialBubbleString.indestructible:
            self.backgroundColor = indestructibleBubble
            self.color = Constants.bubbleColorString.power
            self.power = Constants.specialBubbleString.indestructible
            
        case Constants.specialBubbleString.lightning:
            self.backgroundColor = lightningBubble
            self.color = Constants.bubbleColorString.power
            self.power = Constants.specialBubbleString.lightning
            
        case Constants.specialBubbleString.star:
            self.backgroundColor = starBubble
            self.color = Constants.bubbleColorString.power
            self.power = Constants.specialBubbleString.star
            
        case Constants.bubbleColorString.empty:
            clearBubble()
            
        default:
             break
        }
    }
    
    // Bubble cycles between blue -> red -> orange -> green ->
    // bomb -> indestructible -> lightning -> star and back to blue
    func cycleBubble() {
        let bubbleBackground = self.backgroundColor!
        
        switch bubbleBackground {
            
        case blueBubbleColor!:
            self.backgroundColor = redBubbleColor
            self.color = Constants.bubbleColorString.red
            self.power = Constants.specialBubbleString.noPower
            
        case redBubbleColor!:
            self.backgroundColor = orangeBubbleColor
            self.color = Constants.bubbleColorString.orange
            self.power = Constants.specialBubbleString.noPower
            
        case orangeBubbleColor!:
            self.backgroundColor = greenBubbleColor
            self.color = Constants.bubbleColorString.green
            self.power = Constants.specialBubbleString.noPower
            
        case greenBubbleColor!:
            self.backgroundColor = bombBubble
            self.color = Constants.bubbleColorString.power
            self.power = Constants.specialBubbleString.bomb
            
        case bombBubble!:
            self.backgroundColor = indestructibleBubble
            self.color = Constants.bubbleColorString.power
            self.power = Constants.specialBubbleString.indestructible
            
        case indestructibleBubble!:
            self.backgroundColor = lightningBubble
            self.color = Constants.bubbleColorString.power
            self.power = Constants.specialBubbleString.lightning
            
        case lightningBubble!:
            self.backgroundColor = starBubble
            self.color = Constants.bubbleColorString.power
            self.power = Constants.specialBubbleString.star
            
        case starBubble!:
            self.backgroundColor = blueBubbleColor
            self.color = Constants.bubbleColorString.blue
            self.power = Constants.specialBubbleString.noPower
            
        default:
            break
        }
    }
    
    func setCheck() {
        self.checked = true
    }
    
    func isChecked() -> Bool {
        return self.checked
    }
    
    func resetCheck() {
        self.checked = false
    }
}
