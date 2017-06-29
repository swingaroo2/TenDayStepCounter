//
//  MotionService.swift
//  TenDayStepCounter
//
//  Created by Zach Lockett-Streiff on 6/26/17.
//  Copyright © 2017 Swingaroo2. All rights reserved.
//

import Foundation
import CoreMotion

class MotionService
{
    var calendar:Calendar {
        var calendar = Calendar.current
        calendar.timeZone = .current
        return calendar
    }
    
    var dataArr: Array<CMPedometerData> = []
    let pedometer = CMPedometer()
    let queue = DispatchQueue(label: "StepCounterQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    func getDailyStepDataUntilToday(_ numberOfDays:Int, dispatchGroup:DispatchGroup)
    {
        let date = Date()
        for numberOfDaysInLoop in 0...(numberOfDays-1)
        {
            guard let endDate = self.getEndDateForQueryRange(numDaysAgo: numberOfDaysInLoop, currentDate: date) else
            {
                NSLog("\(#function): Failed to get end date for query")
                return
            }
            
            guard let startDate = self.getStartDateForQueryRange(endDate) else
            {
                NSLog("\(#function): Failed to get start date for query")
                return
            }
            
            self.getStepDataForDates(startDate, end: endDate, dispatchGroup: dispatchGroup)
        }
    }
    
    static func getStringForStepsLabel(_ steps:NSNumber?) -> String?
    {
        guard let steps = steps else
        {
            NSLog("\(#function): Attempted to use invalid number of steps")
            return nil
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let stepsFormatted = formatter.string(from: steps)
        return stepsFormatted
    }
    
    static func getStringForDistanceLabel(_ meters:NSNumber?) -> String?
    {
        guard let meters = meters else
        {
            NSLog("\(#function): Attempted to convert invalid distance in meters to miles")
            return nil
        }
        
        let metersFormatted = String(format: "%.2f meters",meters.floatValue)
        return metersFormatted
    }
    
    static func getStringForPaceLabel(_ metersPerHour:NSNumber?) -> String?
    {
        guard let metersPerHour = metersPerHour else
        {
            NSLog("\(#function): Attempted to convert invalid distance in meters to miles")
            return nil
        }
        
        let metersPerHourFormatted = String(format: "%.2f mph",metersPerHour.floatValue)
        return metersPerHourFormatted
    }
    
    private func getStepDataForDates(_ start:Date, end:Date, dispatchGroup:DispatchGroup)
    {
        dispatchGroup.enter()
        self.pedometer.queryPedometerData(from: end, to: start, withHandler: { [weak self] (data, error) -> Void in
            guard let data = data else
            {
                if let error = error
                {
                    NSLog("\(#function): Error: \(error.localizedDescription)")
                }
                return
            }
            
            self?.dataArr.append(data)
            dispatchGroup.leave()
        })
    }
    
    private func getEndDateForQueryRange(numDaysAgo:Int, currentDate:Date) -> Date?
    {
        guard let endDate = self.calendar.date(byAdding: .day, value: -numDaysAgo, to: currentDate) else
        {
            NSLog("\(#function): Failed to get end date for query range")
            return nil
        }
        
        let endDateFormatted = self.calendar.startOfDay(for: endDate)
        return endDateFormatted
    }
    
    private func getStartDateForQueryRange(_ date:Date) -> Date?
    {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let startDate = self.calendar.date(byAdding: components, to: date)
        return startDate
    }
}
