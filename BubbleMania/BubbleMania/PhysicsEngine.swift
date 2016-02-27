//
//  PhysicsEngine.swift
//  BubbleMania
//
//  Created by Lim Kiat on 14/2/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import Foundation

class PhysicsEngine {
    
    private var leftWall = 0.0
    private var rightWall = 0.0
    private var ceiling = 0.0
    private var floor = 0.0
    
    init(leftWall: Double, rightWall: Double, ceiling: Double, floor: Double) {
        self.leftWall = leftWall
        self.rightWall = rightWall
        self.ceiling = ceiling
        self.floor = floor
    }
    
    // Gives next position of a bubble travelling in the specified velocity and angle
    func getNextPosition(x: Double, y: Double, width: Double, height: Double, angle: Double, velocity: Double) -> Vector {
        let nextXPosition = velocity * cos(angle) + x
        let nextYPosition = y - velocity * sin(angle)
        var nextAngle = angle
        
        if (hitLeftWall(nextXPosition) || hitRightWall(nextXPosition, width: width)) {
            nextAngle = M_PI - angle
        } else if (hitFloor(nextYPosition, height: height)) {
            nextAngle = -angle
        }
        return Vector(x: nextXPosition, y: nextYPosition, angle: nextAngle)
    }
    
    func hitLeftWall(x: Double) -> Bool {
        return x <= leftWall
    }
    
    func hitRightWall(x: Double, width: Double) -> Bool {
        return x + width >= rightWall
    }

    func hitCeiling(y: Double) -> Bool {
        return y <= ceiling
    }

    func hitFloor(y: Double, height: Double) -> Bool {
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
    let xPosition: Double
    let yPosition: Double
    let angle: Double
    
    init (x: Double, y: Double, angle: Double) {
        self.xPosition = x
        self.yPosition = y
        self.angle = angle
    }
}
func == (lhs: Vector, rhs: Vector) -> Bool {
    return lhs.xPosition == rhs.xPosition && lhs.yPosition == rhs.yPosition && lhs.angle == rhs.angle
}