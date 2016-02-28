//
//  MainMenuViewController.swift
//  BubbleMania
//
//  Created by Lim Kiat on 28/2/16.
//  Copyright © 2016 NUS CS3217. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    private var persistentData = PersistentData()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Passes the array of saved level designs to LevelDesignTableViewController if selectLevel button is pressed
        if (segue.identifier == "selectLevel") {
            let vc = segue.destinationViewController as! LevelDesignTableViewController
            vc.levelDesignsArray = persistentData.loadLevelDesignArray()
        }
        
        // Passes the array of saved level designs to LevelDesignViewController if designLevel button is pressed
        if (segue.identifier == "designLevel") {
            let vc = segue.destinationViewController as! LevelDesignViewController
            vc.persistentData = persistentData
        }
    }
    
    // Once a file has been selected to load, we will load the selectedLevelDesign and store its index
    @IBAction func unwindToLevelDesigner(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? LevelDesignTableViewController {
                if let levelDesignViewController = storyboard!.instantiateViewControllerWithIdentifier("LevelDesign") as? LevelDesignViewController {
                    dispatch_async(dispatch_get_main_queue(), {
                        levelDesignViewController.loadedFromMenu = true
                        levelDesignViewController.selectedLevelDesignIndex = sourceViewController.selectedLevelDesignIndex
                        self.presentViewController(levelDesignViewController, animated: true, completion: nil)
                    })
                    
                }
        }
    }
}
