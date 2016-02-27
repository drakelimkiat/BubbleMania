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
    private var color: String
    private var checked = false
    private var row: Int?
    private var col: Int?
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        self.color = "empty"
        super.init(frame: frame)
        initBorderStyle()
        setUpBubbleColors()
    }
    
    init(frame: CGRect, row: Int, col: Int) {
        self.color = "empty"
        self.row = row
        self.col = col
        super.init(frame: frame)
        initBorderStyle()
        setUpBubbleColors()
    }
    
    required init? (coder aDecoder: NSCoder) {
        self.color = "empty"
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
    private func setUpBubbleColors() {
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
        self.color = "empty"
    }
    
    func setBubbleColor(selectedBubbleTitle: String) {
        if (selectedBubbleTitle == "blue") {
            self.backgroundColor = blueBubbleColor
            self.color = selectedBubbleTitle
        }
        if (selectedBubbleTitle == "red") {
            self.backgroundColor = redBubbleColor
            self.color = selectedBubbleTitle
        }
        if (selectedBubbleTitle == "orange") {
            self.backgroundColor = orangeBubbleColor
            self.color = selectedBubbleTitle
        }
        if (selectedBubbleTitle == "green") {
            self.backgroundColor = greenBubbleColor
            self.color = selectedBubbleTitle
        }
        if (selectedBubbleTitle == "empty") {
            clearBubble()
        }
    }
    
    // Bubble color cycles between blue -> red -> orange -> green and back to blue
    func cycleBubbleColor() {
        let bubbleColor = self.backgroundColor
        if (bubbleColor! == blueBubbleColor) {
            self.backgroundColor = redBubbleColor
            self.color = "red"
        } else if (bubbleColor! == redBubbleColor) {
            self.backgroundColor = orangeBubbleColor
            self.color = "orange"
        } else if (bubbleColor! == orangeBubbleColor) {
            self.backgroundColor = greenBubbleColor
            self.color = "green"
        } else if (bubbleColor! == greenBubbleColor) {
            self.backgroundColor = blueBubbleColor
            self.color = "blue"
        }
    }
    
    func getColor() -> String {
        return self.color
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
    
    func getRow() -> Int {
        return self.row!
    }
    
    func getCol() -> Int {
        return self.col!
    }
}
