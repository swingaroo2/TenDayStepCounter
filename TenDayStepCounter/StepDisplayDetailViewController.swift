//
//  StepDisplayDetailViewController.swift
//  TenDayStepCounter
//
//  Created by Zach Lockett-Streiff on 6/28/17.
//  Copyright © 2017 Swingaroo2. All rights reserved.
//

import UIKit
import CoreMotion

class StepDisplayDetailViewController: UIViewController
{
    private var data:CMPedometerData?
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setUpViewController()
    }
    
    func setUpViewController()
    {
        self.navigationItem.title = self.getNavigationControllerTitle()
    }
    
    func getNavigationControllerTitle() -> String?
    {
        guard let date = self.data?.endDate else
        {
            NSLog("\(#function): Can't set navigation controller with invalid date")
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func setPedometerData(_ pedData:CMPedometerData?)
    {
        self.data = pedData
    }
}
