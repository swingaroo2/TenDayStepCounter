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
    static var needToSimulateData:Bool {
        return !CMPedometer.isStepCountingAvailable()
    }
    
    var calendar:Calendar {
        var calendar = Calendar.current
        calendar.timeZone = .current
        return calendar
    }
    
    var dataArr: Array<CMPedometerData> = []
    var simulatedDataArr: Array<SimulatedData> = []
    let pedometer = CMPedometer()
    let queue = DispatchQueue(label: "StepCounterQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    struct SimulatedData {
        var startDate:Date
        var endDate:Date
        var distance:NSNumber?
        var numberOfSteps:NSNumber?
        var averageActivePace:NSNumber?
        var floorsAscended:NSNumber?
        var floorsDescended:NSNumber?
    }

    func getDailyStepDataUntilToday(_ numberOfDays:Int, dispatchGroup:DispatchGroup)
    {
        if MotionService.needToSimulateData
        {
            NSLog("Step Counting not available on this device/simulator. Simulating data.")
        }
        
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
        let stepsString = MotionService.addCommaToNumber(steps)
        return stepsString
    }
    
    static func addCommaToNumber(_ number:NSNumber?) -> String?
    {
        guard let number = number else
        {
            NSLog("\(#function): Attempted to add comma to invalid number")
            return nil
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let numberFormatted = formatter.string(from: number)
        return numberFormatted
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
    
    static func getStringForPaceLabel(_ secondsPerMeter:NSNumber?) -> String?
    {
        guard let secondsPerMeter = secondsPerMeter else
        {
            NSLog("\(#function): Attempted to convert invalid distance in meters to miles")
            return nil
        }
        
        let secondsPerMeterFormatted = String(format: "%.2f seconds/meter",secondsPerMeter.floatValue)
        return secondsPerMeterFormatted
    }
    
    private func getStepDataForDates(_ start:Date, end:Date, dispatchGroup:DispatchGroup)
    {
        if MotionService.needToSimulateData
        {
            self.simulateStepDataForQueryRange(from: start, to: end)
            return
        }
        
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
    
    private func simulateStepDataForQueryRange(from:Date, to:Date)
    {
        let simulatedData_steps = Int(arc4random_uniform(8000)) + 2000
        let simulatedData_distance = Double(simulatedData_steps) * 1.38 // arbitrary conversion constant
        let simulatedData_pace = (from.timeIntervalSince(to)) / simulatedData_distance
        let simulatedData_floorsUp = Int(arc4random_uniform(4))
        let simulatedData_floorsDown = Int(arc4random_uniform(4))
        
        let simulatedData:SimulatedData = SimulatedData.init(startDate: from,
                                                             endDate: to,
                                                             distance: NSNumber(value:simulatedData_distance),
                                                             numberOfSteps: NSNumber(value:simulatedData_steps),
                                                             averageActivePace: NSNumber(value:simulatedData_pace),
                                                             floorsAscended: NSNumber(value:simulatedData_floorsUp),
                                                             floorsDescended: NSNumber(value:simulatedData_floorsDown))
        
        self.simulatedDataArr.append(simulatedData)
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
