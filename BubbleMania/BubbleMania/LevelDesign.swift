//
//  LevelDesign.swift
//  BubbleMania
//
//  Created by Lim Kiat on 2/2/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import Foundation

class LevelDesign: NSObject, NSCoding {
    
    // MARK: Properties
    
    private var name: String
    private var gameBubbleArray: [[GameBubble]]
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("levelDesigns")
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey = "name"
        static let gameBubbleArrayKey = "gameBubbleArray"
    }
    
    // MARK: Initialization
    
    init (name: String, gameBubbleArray: [[GameBubble]]) {
        self.name = name
        self.gameBubbleArray = gameBubbleArray
        
        super.init()
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(gameBubbleArray, forKey: PropertyKey.gameBubbleArrayKey)
    }
    
    required convenience init (coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let gameBubbleArray = aDecoder.decodeObjectForKey(PropertyKey.gameBubbleArrayKey) as! [[GameBubble]]
        
        // Must call designated initializer.
        self.init(name: name, gameBubbleArray: gameBubbleArray)
    }
    
    func getGameBubbleArray() -> [[GameBubble]] {
        return gameBubbleArray
    }
    
    func getName() -> String {
        return name
    }

}