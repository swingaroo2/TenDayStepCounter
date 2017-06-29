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
    
    @IBOutlet weak var stepsLabel: UILabel?
    @IBOutlet weak var distanceLabel: UILabel?
    @IBOutlet weak var paceLabel: UILabel?
    @IBOutlet weak var floorsUpLabel: UILabel?
    @IBOutlet weak var floorsDownLabel: UILabel?
    
    private var data:CMPedometerData?
    
    struct Conversions {
        static let metersToMiles = 0.000621371
    }
    
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
        self.setLabelsWithData(self.data)
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
 
    func setLabelsWithData(_ data:CMPedometerData?)
    {
        // TODO: Data conversions
        self.stepsLabel?.text      = MotionService.getStringForStepsLabel(data?.numberOfSteps)
        self.distanceLabel?.text   = MotionService.getStringForDistanceLabel(data?.distance)
        self.paceLabel?.text       = MotionService.getStringForPaceLabel(data?.averageActivePace)
        self.floorsUpLabel?.text   = data?.floorsAscended?.description
        self.floorsDownLabel?.text = data?.floorsDescended?.description
    }
    
    func setPedometerData(_ pedData:CMPedometerData?)
    {
        self.data = pedData
    }
}
