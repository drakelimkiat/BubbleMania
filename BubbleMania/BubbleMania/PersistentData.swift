//
//  PersistentData.swift
//  BubbleMania
//
//  Created by Lim Kiat on 28/2/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import Foundation

class PersistentData {
    
    private(set) var levelDesignArray = [LevelDesign]()
    
    init () {
        // If there are any saved LevelDesigns, we load and append it to levelDesignArray
        if let savedLevelDesigns = loadLevelDesigns() {
            levelDesignArray += savedLevelDesigns
        }
    }
    
    func saveLevelDesign(name: String, bubbleGrid: BubbleGrid, selectedLevelDesignIndex: Int) {
        if (selectedLevelDesignIndex >= 0) {
            let selectedLevelDesignName = levelDesignArray[selectedLevelDesignIndex].getName()
            let levelDesign = makeLevelDesign(selectedLevelDesignName, bubbleGrid: bubbleGrid)
            levelDesignArray[selectedLevelDesignIndex] = levelDesign
        } else {
            let levelDesign = makeLevelDesign(name, bubbleGrid: bubbleGrid)
            levelDesignArray.append(levelDesign)
        }
        saveLevelDesigns(levelDesignArray)
    }
    
    func loadLevelDesignArray() -> [LevelDesign] {
        if let savedLevelDesigns = loadLevelDesigns() {
            return savedLevelDesigns
        } else {
            return levelDesignArray
        }
    }
    
    // Makes a LevelDesign object with the current grid status, only gets called when user
    // wants to save the current design
    private func makeLevelDesign(name: String, bubbleGrid: BubbleGrid) -> LevelDesign {
        var gameBubbleArray = [[GameBubble]]()
        
        for row in 0..<9 {
            let even = (row % 2) == 0
            var rowGameBubbleArray = [GameBubble]()
            
            for col in 0..<12 {
                if (!even && col == 11) {
                    break
                }
                
                let bubbleView = bubbleGrid[row, col]
                let bubbleXPosition = Int(bubbleView.frame.origin.x)
                let bubbleYPosition = Int(bubbleView.frame.origin.y)
                let bubbleColor = bubbleView.color
                let basicBubble = BasicBubble(xPosition: bubbleXPosition,
                    yPosition: bubbleYPosition, bubbleColor: bubbleColor)
                rowGameBubbleArray.append(basicBubble)
            }
            gameBubbleArray.append(rowGameBubbleArray)
        }
        
        let levelDesign = LevelDesign(name: name, gameBubbleArray: gameBubbleArray)
        return levelDesign
    }
    
    // MARK: NSCoding
    
    private func saveLevelDesigns(levelDesignArray: [LevelDesign]) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(levelDesignArray, toFile: LevelDesign.ArchiveURL.path!)
        if (!isSuccessfulSave) {
            print("Failed to save level design...")
        }
    }
    
    private func loadLevelDesigns() -> [LevelDesign]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(LevelDesign.ArchiveURL.path!) as? [LevelDesign]
    }
}