//
//  LevelDesignViewController.swift
//  BubbleMania
//
//  Created by Lim Kiat on 27/2/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import UIKit

class LevelDesignViewController: UIViewController {

    @IBOutlet weak var gameArea: UIView!
    @IBOutlet weak var blueBubble: UIButton!
    @IBOutlet weak var redBubble: UIButton!
    @IBOutlet weak var orangeBubble: UIButton!
    @IBOutlet weak var greenBubble: UIButton!
    @IBOutlet weak var bombBubble: UIButton!
    @IBOutlet weak var indestructibleBubble: UIButton!
    @IBOutlet weak var lightningBubble: UIButton!
    @IBOutlet weak var starBubble: UIButton!
    @IBOutlet weak var eraser: UIButton!
    
    // MARK: Properties
    
    // selected palette button
    private var selectedButton: UIButton?
    private var bubbleGrid: BubbleGrid?
    // indicates if current file is a loaded LevelDesign
    private var isLoadedLevelDesign = false
    // indicates the index of current LevelDesign if it is a loaded one
    var selectedLevelDesignIndex: Int?
    var persistentData: PersistentData?
    // indicates if LevelDesignViewController was presented from Main Menu
    var loadedFromMenu = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpBackground()
        let bubbleViewArray = setUpGrid()
        bubbleGrid = BubbleGrid(bubbleViewArray: bubbleViewArray)
        selectedButton = blueBubble
        persistentData = PersistentData()
        
        if (loadedFromMenu) {
            let selectedLevelDesign = persistentData?.levelDesignArray[selectedLevelDesignIndex!]
            loadSelectedLevelDesign(selectedLevelDesign!)
            isLoadedLevelDesign = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUpBackground() {
        let backgroundImage = UIImage(named: "background.png")
        let background = UIImageView(image: backgroundImage)
        
        let gameViewHeight = gameArea.frame.size.height
        let gameViewWidth = gameArea.frame.size.width
        
        background.frame = CGRectMake(0, 0, gameViewWidth, gameViewHeight)
        
        self.gameArea.addSubview(background)
        self.view.sendSubviewToBack(gameArea)
    }
    
    // Populates grid by adding 9 rows of BubbleViews
    private func setUpGrid() -> [[BubbleView]] {
        var bubbleViewArray = [[BubbleView]]()
        let bubbleDiameter = gameArea.frame.size.width / Constants.numbers.maxNumOfBubblesInRow
        let intBubbleDiameter = Int(bubbleDiameter)
        
        for row in 0..<9 {
            var bubbleArray = [BubbleView]()
            let even = (row % 2) == 0
            var startingXPosition = 0
            let yPosition = (row * intBubbleDiameter) - (row * Constants.numbers.overlappingPixelsPerRow)
            
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
                self.gameArea.addSubview(bubbleView)
                bubbleArray.append(bubbleView)
            }
            bubbleViewArray.append(bubbleArray)
        }
        return bubbleViewArray
    }

    // All palette buttons are associated with this IBAction
    @IBAction func paletteButtonPressed(sender: AnyObject) {
        selectedButton?.alpha = Constants.numbers.paletteUnselectedAlphaValue
        let button = sender as! UIButton
        button.alpha = Constants.numbers.paletteSelectedAlphaValue
        selectedButton = button
    }
    
    // Checks if current level design is one loaded from a previously saved file
    // If so, we will invoke saveLoadedFile(), if not, saveNewFile() will be invoked
    @IBAction func saveButtonPressed(sender: AnyObject) {
        var alertController: UIAlertController
        
        if (isLoadedLevelDesign) {
            alertController = saveLoadedFile()
        } else {
            alertController = saveNewFile()
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Returns UIAlertController to save a new file using a unique name
    private func saveNewFile() -> UIAlertController {
        var alertController: UIAlertController
        
        alertController = UIAlertController(title: "Enter File Name",
            message: "Please enter a unique name to save the level design as",
            preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = "Enter unique name"
        })
        
        let saveAction = UIAlertAction(title: "Submit",
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                
                if let textFields = alertController.textFields{
                    let theTextFields = textFields as [UITextField]
                    let enteredText = theTextFields[0].text
                    if let name = enteredText {
                        // The file will only be saved if entered name is unique
                        if (self!.isUniqueName(name)) {
                            self!.persistentData!.saveLevelDesign(name, bubbleGrid: self!.bubbleGrid!,
                                selectedLevelDesignIndex: -1)
                            self!.isLoadedLevelDesign = true
                            self!.selectedLevelDesignIndex = self!.persistentData!.levelDesignArray.count - 1
                        } else { // else we will call errorSavingFile()
                            self!.errorSavingFile()
                        }
                    }
                }
            })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Default,
            handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    // Returns UIAlertController when saving an existing file
    private func saveLoadedFile() -> UIAlertController {
        var alertController: UIAlertController
        
        alertController = UIAlertController(title: "Saving existing file",
            message: "Please choose to overwrite saved file or save as new file",
            preferredStyle: .Alert)
        
        // The levelDesign in the stored index will be replaced
        let overwriteSaveAction = UIAlertAction(title: "Overwrite saved file",
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                self!.persistentData!.saveLevelDesign("dummyName", bubbleGrid: self!.bubbleGrid!,
                    selectedLevelDesignIndex: self!.selectedLevelDesignIndex!)
            })
        
        // saveNewFile() is called to present another UIAlertController if user
        // decides to save as a new file
        let saveAsNewFileAction = UIAlertAction(title: "Save as new file",
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                let saveAlertController = self!.saveNewFile()
                self!.presentViewController(saveAlertController, animated: true, completion: nil)
            })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Default,
            handler: nil)
        
        alertController.addAction(overwriteSaveAction)
        alertController.addAction(saveAsNewFileAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    // Checks through the array of levelDesigns to see if name is unique
    // Empty string is not allowed
    private func isUniqueName(name: String) -> Bool {
        if (name == "") {
            return false
        }
        
        for levelDesign in persistentData!.levelDesignArray {
            if (levelDesign.name == name) {
                return false
            }
        }
        return true
    }
    
    // Displays an UIAlertController mentioning an error saving file
    private func errorSavingFile() {
        var alertController: UIAlertController
        
        alertController = UIAlertController(title: "Error saving file",
            message: "Specified file name is empty or already in use",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Default,
            handler: nil)
        
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func resetButtonPressed(sender: AnyObject) {
        for row in 0..<9 {
            let even = (row % 2) == 0
            
            for col in 0..<12 {
                if (!even && col == 11) {
                    break
                }
                
                let bubbleView = bubbleGrid![row, col]
                bubbleView.clearBubble()
                bubbleGrid![row, col] = bubbleView
            }
        }
    }
    
    @IBAction func handlePan(panRecognizer: UIPanGestureRecognizer) {
        let panRecognizerView = panRecognizer.view
        let dragPoint = panRecognizer.locationInView(panRecognizerView)
        let hitTest = UIView.hitTest(panRecognizerView!)
        let possibleBubbleView = hitTest(dragPoint, withEvent: nil) as? BubbleView
        
        if let bubbleView = possibleBubbleView {
            if let selectedButtonTitle = selectedButton?.currentTitle {
                bubbleView.setBubble(selectedButtonTitle)
            }
        }
    }
    
    @IBAction func handleTap(tapRecognizer: UITapGestureRecognizer) {
        let tapRecognizerView = tapRecognizer.view
        let tapPoint = tapRecognizer.locationInView(tapRecognizerView)
        let hitTest = UIView.hitTest(tapRecognizerView!)
        let possibleBubbleView = hitTest(tapPoint, withEvent: nil) as? BubbleView
        
        if let bubbleView = possibleBubbleView {
            if let selectedButtonTitle = selectedButton?.currentTitle {
                let emptyColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.3)
                
                if (selectedButtonTitle == "empty") {
                    bubbleView.clearBubble()
                } else if (bubbleView.backgroundColor == emptyColor) {
                    bubbleView.setBubble(selectedButtonTitle)
                } else {
                    bubbleView.cycleBubble()
                }
            }
        }
    }
    
    @IBAction func handleLongPress(longPressRecognizer: UILongPressGestureRecognizer) {
        let longPressRecognizerView = longPressRecognizer.view
        let longPressPoint = longPressRecognizer.locationInView(longPressRecognizerView)
        let hitTest = UIView.hitTest(longPressRecognizerView!)
        let possibleBubbleView = hitTest(longPressPoint, withEvent: nil) as? BubbleView
        
        if let bubbleView = possibleBubbleView {
            bubbleView.clearBubble()
        }
    }
    
    // Loads a LevelDesign that the user has specified to load
    private func loadSelectedLevelDesign(selectedLevelDesign: LevelDesign) {
        let gameBubbleArray = selectedLevelDesign.gameBubbleArray
        
        for row in 0..<9 {
            let even = (row % 2) == 0
            
            for col in 0..<12 {
                if (!even && col == 11) {
                    break
                }
                
                let basicBubble = gameBubbleArray[row][col] as! BasicBubble
                let bubbleView = bubbleGrid![row, col]
                
                if (basicBubble.bubblePower == Constants.specialBubbleString.noPower) {
                    bubbleView.setBubble(basicBubble.bubbleColor)
                } else {
                    bubbleView.setBubble(basicBubble.bubblePower)
                }
                bubbleGrid![row, col] = bubbleView
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Passes the array of saved level designs to LevelDesignTableViewController if Load button is pressed
        if (segue.identifier == "load") {
            let vc = segue.destinationViewController as! LevelDesignTableViewController
            vc.levelDesignsArray = persistentData!.loadLevelDesignArray()
        }
        // Passes the bubbleGrid to GameViewController if Start button is pressed
        if (segue.identifier == "start") {
            let vc = segue.destinationViewController as! GameViewController
            vc.bubbleGrid = bubbleGrid
        }
    }
    
    // Once a file has been selected to load, we will load the selectedLevelDesign and store its index
    @IBAction func unwindToLevelDesigner(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? LevelDesignTableViewController,
            selectedLevelDesign = sourceViewController.selectedLevelDesign {
            selectedLevelDesignIndex = sourceViewController.selectedLevelDesignIndex
            loadSelectedLevelDesign(selectedLevelDesign)
            isLoadedLevelDesign = true
        }
    }
}

