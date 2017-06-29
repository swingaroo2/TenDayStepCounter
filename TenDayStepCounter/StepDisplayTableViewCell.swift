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
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
        // Initialization code
    }
    
    override func prepareForReuse()
    {
        self.stepData = nil
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
        self.stepsLabel?.text = data.numberOfSteps.description
        self.distanceLabel?.text = self.getFormattedDistance(data.distance)
        self.dateLabel?.text = self.getFormattedStartDate(data.endDate)
    }
    
    func getFormattedDistance(_ distance:NSNumber?) -> String?
    {
        guard let distance = distance else
        {
            return nil
        }
        
        let formattedDistance = Int(floor(distance.doubleValue)).description
        let fullString = "\(formattedDistance) m"
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
    
    func getStepData() -> CMPedometerData?
    {
        return self.stepData
    }
}
