//
//  ItemInfoTableViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/4/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import UIKit
import os.log

class ItemInfoTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var taskNameDescriptionLabel: UILabel!
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var taskDescriptionView: UITextView!
    @IBOutlet weak var estTimeLabel: UILabel!
    @IBOutlet weak var estTimeField: UITextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private var taskItemCells = [StaticTableCell]()
    var toDo: ToDo?
    private var finished: Bool
    private var chosenWorkDate: Date
    private var chosenDueDate: Date
    
    required init?(coder aDecoder: NSCoder) {
        self.chosenWorkDate = Date()
        self.chosenDueDate = Date()
        self.finished = false
        
        // If workDate already exist, then don't set replace chosenWorkDate to the actual toDo date
        if toDo?.workDate != nil {
            self.chosenWorkDate = (toDo?.workDate)!
        }
        // If dueDate already exist, then don't set replace chosenDueDate to the actual toDo date
        if toDo?.dueDate != nil {
            self.chosenDueDate = (toDo?.dueDate)!
        }
        // If item edited is already finished
        if toDo?.finished != false {
            self.finished = !self.finished
        }
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy, h:mm a"
        
        taskItemCells = [
            StaticTableCell(name: "Task Details"),
            StaticTableCell(name: "Work Date"),
            StaticTableCell(name: "Estimated Time"),
            StaticTableCell(name: "Due Date"),
        ]

        taskNameField.delegate = self
        taskDescriptionView.delegate = self
        estTimeField.delegate = self
        
        // Set up views if editing an existing ToDo.
        if let toDo = toDo {
            navigationItem.title = toDo.taskName
            taskNameField.text = toDo.taskName
            taskDescriptionView.text = toDo.taskDescription
            taskNameDescriptionLabel.text = "Task Details: " + toDo.taskName
            startDateLabel.text = "Work Date: " + dateFormatter.string(from: toDo.workDate)
            startDatePicker.date = toDo.workDate
            estTimeLabel.text = "Estmated Time: " + toDo.estTime
            estTimeField.text = toDo.estTime
            endDateLabel.text = "Due Date: " + dateFormatter.string(from: toDo.dueDate)
            endDatePicker.date = toDo.dueDate
        }
        
        updateSaveButtonState()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Determines which of the textfield is it working
        if textField == taskNameField {
            taskNameDescriptionLabel.text = "Task Details: " + textField.text!
        }
        else if textField == estTimeField {
            estTimeLabel.text = "Estimated Time: " + textField.text!
        }
        
        updateSaveButtonState()
    }

    // MARK: - Actions
    
    @IBAction func startDatePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        chosenWorkDate = sender.date
        let strDate = dateFormatter.string(from: chosenWorkDate)
        startDateLabel.text = "Start Date: " + strDate
    }
    
    @IBAction func endDatePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        
        chosenDueDate = sender.date
        let strDate = dateFormatter.string(from: chosenDueDate)
        endDateLabel.text = "Endr  Date: " + strDate
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if taskItemCells[0].collapsed {
                taskItemCells[0].collapsed = false
            } else {
                taskItemCells[0].collapsed = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if indexPath.row == 1 {
            if taskItemCells[1].collapsed {
                taskItemCells[1].collapsed = false
            } else {
                taskItemCells[1].collapsed = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if indexPath.row == 2 {
            if taskItemCells[2].collapsed {
                taskItemCells[2].collapsed = false
            } else {
                taskItemCells[2].collapsed = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if indexPath.row == 3 {
            if taskItemCells[3].collapsed {
                taskItemCells[3].collapsed = false
            } else {
                taskItemCells[3].collapsed = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if taskItemCells[0].collapsed {
                return 210
            }
        }
        if indexPath.row == 1 {
            if taskItemCells[1].collapsed {
                return 100
            }
        }
        if indexPath.row == 2 {
            if taskItemCells[2].collapsed {
                return 170
            }
        }
        if indexPath.row == 3 {
            if taskItemCells[3].collapsed {
                return 170
            }
        }
        return 50
    }
    
    // MARK: - Navigation
    
    // Prepares view controller before it gets presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Only prepare view controller when the save button is pressed
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling new item", log: OSLog.default,
                   type: .debug)
            return
        }
        
        let taskName = taskNameField.text
        let taskDescription = taskDescriptionView.text
        let workDate = chosenWorkDate
        let estTime = estTimeField.text
        let dueDate = chosenDueDate
        
        updateSaveButtonState()
        navigationItem.title = taskName
        
        // Set the ToDo to be passed to ToDoListTableViewController after pressing save with unwind segue
        toDo = ToDo(taskName: taskName!, taskDescription: taskDescription!, workDate: workDate, estTime: estTime!, dueDate: dueDate, finished: finished)
        //toDoDate = ToDoDate(toDoDate: workDate)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddToDoMode = presentingViewController is UINavigationController
        
        if isPresentingInAddToDoMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ItemInfoTableViewController is not inside a navigation controller.")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    // Disable the save button if the text field is empty
    private func updateSaveButtonState() {
        saveButton.isEnabled = false
        
        // Only allow saveButton if textFields are not empty
        taskNameField.addTarget(self, action: #selector(textFieldsAreNotEmpty), for: .editingChanged)
        estTimeField.addTarget(self, action: #selector(textFieldsAreNotEmpty), for: .editingChanged)
    }
    
    // MARK: - Observers
    
    // Only allow saveButton if textFields are not empty
    @objc func textFieldsAreNotEmpty(sender: UITextField) {
        guard
            let taskName = taskNameField.text, !taskName.isEmpty,
            let estTime = estTimeField.text, !estTime.isEmpty
            else {
                self.saveButton.isEnabled = false
                return
        }
        // Enable save button if all conditions are met
        saveButton.isEnabled = true
    }

}
