//
//  PhysicsEngine.swift
//  BubbleMania
//
//  Created by Lim Kiat on 14/2/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class PhysicsEngine {
    
    private var leftWall: CGFloat
    private var rightWall: CGFloat
    private var ceiling: CGFloat
    private var floor: CGFloat
    
    init(leftWall: CGFloat, rightWall: CGFloat, ceiling: CGFloat, floor: CGFloat) {
        self.leftWall = leftWall
        self.rightWall = rightWall
        self.ceiling = ceiling
        self.floor = floor
    }
    
    // Gives next position of a bubble travelling in the specified velocity and angle
    func getNextPosition(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, angle: Double, velocity: Double) -> Vector {
        let nextXPosition = CGFloat(velocity * cos(angle)) + x
        let nextYPosition = y - CGFloat(velocity * sin(angle))
        var nextAngle = angle
        
        if (hitLeftWall(nextXPosition) || hitRightWall(nextXPosition, width: width)) {
            nextAngle = M_PI - angle
        } else if (hitFloor(nextYPosition, height: height)) {
            nextAngle = -angle
        }
        return Vector(x: nextXPosition, y: nextYPosition, angle: nextAngle)
    }
    
    private func hitLeftWall(x: CGFloat) -> Bool {
        return x <= leftWall
    }
    
    private func hitRightWall(x: CGFloat, width: CGFloat) -> Bool {
        return x + width >= rightWall
    }

    private func hitCeiling(y: CGFloat) -> Bool {
        return y <= ceiling
    }

    private func hitFloor(y: CGFloat, height: CGFloat) -> Bool {
        return y + height >= floor
    }
    
    func circleIntersection(x1: Double, y1: Double, r1: Double, x2: Double, y2: Double, r2: Double) -> Bool {
        let dx = x1 - x2;
        let dy = y1 - y2;
        let distance = sqrt(dx * dx + dy * dy);
        
        if distance <= (r1 + r2) {
            return true
        } else {
            return false
        }
    }

}

struct Vector: Equatable {
    let xPosition: CGFloat
    let yPosition: CGFloat
    let angle: Double
    
    init (x: CGFloat, y: CGFloat, angle: Double) {
        self.xPosition = x
        self.yPosition = y
        self.angle = angle
    }
}

func == (lhs: Vector, rhs: Vector) -> Bool {
    return lhs.xPosition == rhs.xPosition && lhs.yPosition == rhs.yPosition && lhs.angle == rhs.angle
}