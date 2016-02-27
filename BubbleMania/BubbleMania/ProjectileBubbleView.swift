//
//  ProjectileBubbleView.swift
//  BubbleMania
//
//  Created by Lim Kiat on 14/2/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import UIKit

class ProjectileBubbleView: BubbleView {
    
    private var xPosition: CGFloat
    private var yPosition: CGFloat
    
    override init(frame: CGRect) {
        xPosition = frame.origin.x
        yPosition = frame.origin.y
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        xPosition = CGFloat(0)
        yPosition = CGFloat(0)
        super.init(coder: aDecoder)
    }
    
    func setXPosition(xPosition: CGFloat) {
        self.xPosition = xPosition
    }
    
    func setYPosition(yPosition: CGFloat) {
        self.yPosition = yPosition
    }
    
    func getXPosition() -> CGFloat {
        return xPosition
    }
    
    func getYPosition() -> CGFloat {
        return yPosition
    }
    
}