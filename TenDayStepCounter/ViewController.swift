//
//  ViewController.swift
//  TenDayStepCounter
//
//  Created by Zach Lockett-Streiff on 6/26/17.
//  Copyright © 2017 Swingaroo2. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController
{

    let pedometer = CMPedometer()
    
    var currentDate: Date {
        return Date()
    }
    
    var oldestDate: Date? {
        var timeInterval = DateComponents()
        timeInterval.day = -10
        let dateTenDaysAgo = Calendar.current.date(byAdding: timeInterval, to: Date())
        return dateTenDaysAgo
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print()
        
        self.pedometer.queryPedometerData(from: self.oldestDate!, to: self.currentDate, withHandler: { (data, error) -> Void in
            if let data = data
            {
                print("Data: \(data)")
            } else if let error = error {
                print("Error: \(error)")
            }
        })
        
        // Note: use simulated data for unsupported devices
        
        // Check if current device is supported
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

}

