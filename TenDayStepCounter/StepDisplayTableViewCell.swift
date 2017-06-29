//
//  StepDisplayTableViewCell.swift
//  TenDayStepCounter
//
//  Created by Zach Lockett-Streiff on 6/27/17.
//  Copyright © 2017 Swingaroo2. All rights reserved.
//

import UIKit
import CoreMotion

class StepDisplayTableViewCell: UITableViewCell
{
    
    @IBOutlet weak private var stepsLabel: UILabel?
    @IBOutlet weak private var distanceLabel: UILabel?
    @IBOutlet weak private var dateLabel: UILabel?
    
    private var stepData:CMPedometerData?
    private var simulatedStepData:Any?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func prepareForReuse()
    {
        self.stepData = nil
        self.simulatedStepData = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCellWithData(_ data:CMPedometerData?)
    {
        guard let data = data else
        {
            NSLog("Invalid pedometer data")
            return
        }
        self.stepData = data
        self.stepsLabel?.text = self.getStepsLabel(MotionService.formatNumberForLabel(data.numberOfSteps)!)
        self.distanceLabel?.text = self.getFormattedDistance(data.distance)
        self.dateLabel?.text = self.getFormattedStartDate(data.endDate)
    }
    
    func configureCellWithSimulatedData(_ data:MotionService.SimulatedData)
    {
        self.simulatedStepData = data
        self.stepsLabel?.text = self.getStepsLabel(MotionService.formatNumberForLabel(data.numberOfSteps)!)
        self.distanceLabel?.text = self.getFormattedDistance(data.distance)
        self.dateLabel?.text = self.getFormattedStartDate(data.endDate)
    }
    
    func getStepsLabel(_ steps:String) -> String
    {
        let fullString = (steps == "1") ? "1 step" : steps + " Steps"
        return fullString
    }
    
    func getFormattedDistance(_ distance:NSNumber?) -> String?
    {
        guard let distance = distance else
        {
            return nil
        }
        
        let formattedDistance = Int(floor(distance.doubleValue))
        guard let distanceString = MotionService.formatNumberForLabel(formattedDistance as NSNumber) else
        {
            NSLog("\(#function) Invalid distance string")
            return nil
        }
        
        let fullString = distanceString + "m"
        return fullString
    }
    
    func getFormattedStartDate(_ date:Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func getStepData() -> Any?
    {
        if MotionService.needToSimulateData
        {
            return self.simulatedStepData
        } else {
            return self.stepData
        }
    }
}
