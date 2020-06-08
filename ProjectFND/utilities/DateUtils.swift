//
//  DateOperationsHelper.swift
//  ProjectFND
//
//  Created by Elly Richardson on 1/18/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import CoreData
import UIKit
import os.log

class DateUtils{
    func changeDateFormatToMDYY(dateToChange: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy"
        let dateString = dateFormatter.string(from: dateToChange)
        return dateFormatter.date(from: dateString)!
    }
    
    func addMinutesToDate(date: Date, minutes: Double) -> Date {
        // Adds minutes (minutes * 60) to the date that needs to increase
        return date.addingTimeInterval(minutes * 60.0)
    }
    
    func addHoursToDate(date: Date, hours: Double) -> Date {
        // Adds hours (hours * (60 * 60)) to the date that needs to increase
        return date.addingTimeInterval(hours * (60.0 * 60.0))
    }
    
    func addDayToDate(date: Date, days: Double) -> Date {
        // Adds days (day * (60 * 60 * 24)) to the date that needs to increase
        return date.addingTimeInterval(days * (60.0 * 60.0 * 24.0))
    }
}
