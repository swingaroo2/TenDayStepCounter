//
//  ViewController.swift
//  TenDayStepCounter
//
//  Created by Zach Lockett-Streiff on 6/26/17.
//  Copyright © 2017 Swingaroo2. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    let numPreviousDays = 10
    let motionService = MotionService()
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Note: use simulated data for unsupported devices
        // Check if current device is supported
        
        self.motionService.getDailyStepDataUntilToday(numberOfPreviousDays: self.numPreviousDays, dispatchGroup: self.dispatchGroup)
        
        self.dispatchGroup.notify(queue: DispatchQueue.main, execute:{
            print("===Refresh table view===")
        })
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

