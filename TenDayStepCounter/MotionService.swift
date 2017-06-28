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
    let calendar  = Calendar.current
    let pedometer = CMPedometer()
    var dataArr: Array<CMPedometerData> = []
    let queue = DispatchQueue(label: "StepCounterQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    func getDailyStepDataUntilToday(numberOfPreviousDays:Int, dispatchGroup:DispatchGroup)
    {
        guard let date = self.getDateForPastDay(numDaysAgo: numberOfPreviousDays) else
        {
            NSLog("\(#function): Failed to query data with nil Date")
            return
        }
        
        var fromDate = date
        let yesterday = self.calendar.date(byAdding: .day, value: -1, to: Date())!
        
        while fromDate < yesterday
        {
            guard let toDate = self.calendar.date(byAdding: .day, value: 1, to: fromDate) else
            {
                NSLog("\(#function): Failed to get previous day's date")
                return
            }
            self.getStepDataForDates(fromDate, end: toDate, dispatchGroup: dispatchGroup)
            
            fromDate = toDate
        }
    }
    
    private func getStepDataForDates(_ start:Date, end:Date, dispatchGroup:DispatchGroup)
    {
        dispatchGroup.enter()
        self.pedometer.queryPedometerData(from: start, to: end, withHandler: { [weak self] (data, error) -> Void in
            guard let data = data else
            {
                if let error = error
                {
                    NSLog(error.localizedDescription)
                }
                NSLog("\(#function): Failed to get step data with error")
                return
            }
            self?.dataArr.insert(data, at: 0)
            dispatchGroup.leave()
        })
    }
    
    private func getDateForPastDay(numDaysAgo:Int) -> Date?
    {
        let date = Date()
        let pastDate = self.calendar.date(byAdding: .day, value: -numDaysAgo, to: date)
        return pastDate
    }
}
