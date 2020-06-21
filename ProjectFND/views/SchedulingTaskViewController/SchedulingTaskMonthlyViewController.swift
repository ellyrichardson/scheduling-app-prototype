//
//  ScheduleTaskMonthlyViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/29/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import SwiftEntryKit
import UIKit

class SchedulingTaskMonthlyViewController: UIViewController {

    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var acceptButton: LongOvalButton!
    @IBOutlet weak var cancelButton: LongOvalButton!
    
    private var observableDueDateController = ObservableDateController()
    
    // MARK: - Unsaved Changes Trackers
    private var changedDateTo: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Due Date" // THIS IS THE DUE DATE VIEW
        // Do any additional setup after loading the view.
        setDueDatePickerValue()
        setButtonColors()
    }

    @IBAction func dueDatePickerValueChanged(_ sender: UIDatePicker) {
        self.changedDateTo = sender.date
    }
    
    @IBAction func acceptButton(_ sender: UIButton) {
        
        self.observableDueDateController.updateDate(updatedDate: ToDoDate(dateValue: self.changedDateTo, assigned: true))
        SwiftEntryKit.dismiss()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
    
    func setObservableDueDateController(observableDueDateController: ObservableDateController) {
        self.observableDueDateController = observableDueDateController
    }
    
    private func setButtonColors() {
        //self.acceptButton =
        self.acceptButton.backgroundColor = ColorUtils.classicGreen()
        self.cancelButton.backgroundColor =  ColorUtils.classicOrange()
    }
    
    private func setDueDatePickerValue() {
        let dateReceived: ToDoDate = self.observableDueDateController.getDueDate()
        if !dateReceived.assigned {
            self.dueDatePicker.date = Date()
        } else {
            self.dueDatePicker.date = dateReceived.dateValue!
        }
    }
}
