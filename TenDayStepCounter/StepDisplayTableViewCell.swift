//
//  StepDisplayTableViewCell.swift
//  TenDayStepCounter
//
//  Created by Zach Lockett-Streiff on 6/27/17.
//  Copyright © 2017 Swingaroo2. All rights reserved.
//

import UIKit
import CoreMotion

class StepDisplayTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var stepsLabel: UILabel?
    @IBOutlet weak private var distanceLabel: UILabel?
    @IBOutlet weak private var dateLabel: UILabel?
    
    private var stepData:CMPedometerData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
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
        self.distanceLabel?.text = data.distance?.description
        self.dateLabel?.text = self.getFormattedStartDate(data.startDate)
        print("\(#function): Configured step data cell")
    }
    
    func getFormattedStartDate(_ date:Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let dateString = formatter.string(from: date)
        return dateString
    }
}
