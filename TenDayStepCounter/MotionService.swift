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
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        return calendar
    }
    
    var dataArr: Array<CMPedometerData> = []
    let pedometer = CMPedometer()
    let queue = DispatchQueue(label: "StepCounterQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    func getDailyStepDataUntilToday(numberOfDays:Int, dispatchGroup:DispatchGroup)
    {
        
        for numberOfDaysInLoop in 0...(numberOfDays-1)
        {
            
            guard let endDate = self.getEndDateForQueryRange(numDaysAgo: numberOfDaysInLoop) else
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
    
    private func getEndDateForQueryRange(numDaysAgo:Int) -> Date?
    {
        guard let endDate = self.calendar.date(byAdding: .day, value: -numDaysAgo, to: Date()) else
        {
            NSLog("\(#function): Failed to get end date for query range")
            return nil
        }
        
        let toDateFormatted = self.calendar.startOfDay(for: endDate)
        return toDateFormatted
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
