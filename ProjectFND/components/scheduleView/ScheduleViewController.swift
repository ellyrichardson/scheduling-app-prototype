//
//  ViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/3/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//
//  Parts of this code was taken from CalendarControlUsingJTAppleCalenader
//  project by anoop4real.
//

import UIKit
import JTAppleCalendar

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var toDoListTableView: UITableView!
    
    var toDos = [ToDo]()
    
    let formatter = DateFormatter()
    let numberOfRows = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.toDoListTableView.delegate = self
        self.toDoListTableView.dataSource = self
        
        //toDoListTableView.delegate = self
        
        if let savedToDos = loadToDos() {
            setToDoItems(toDoItems: savedToDos)
        }
        
        configureCalendarView()
        //toDoListTableView.dataSource = self as! UITableViewDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTableViewData()
    }
    
    func configureCalendarView(){
        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.register(UINib(nibName: "CalendarHeader", bundle: Bundle.main),
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: "CalendarHeader")
        self.calendarView.scrollToDate(Date(),animateScroll: false)
        self.calendarView.selectDates([ Date() ])
        
    }
    
    // Configure the cell
    func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let currentCell = cell as? CalendarCell else {
            return
        }
        
        currentCell.dateLabel.text = cellState.text
        print("Cell State")
        print(cellState.text)
        print(cellState.date)
        print(cellState.dateBelongsTo.rawValue)
        //configureSelectedStateFor(cell: currentCell, cellState: cellState)
        configureTextColorFor(cell: currentCell, cellState: cellState)
        let cellHidden = cellState.dateBelongsTo != .thisMonth
        currentCell.isHidden = cellHidden
    }
    
    // Configure text colors
    func configureTextColorFor(cell: JTAppleCell?, cellState: CellState){
        
        guard let currentCell = cell as? CalendarCell else {
            return
        }
        
        if cellState.isSelected {
            currentCell.dateLabel.textColor = UIColor.red
        } else {
            if cellState.dateBelongsTo == .thisMonth && cellState.date > Date()  {
                currentCell.dateLabel.textColor = UIColor.black
            } else {
                currentCell.dateLabel.textColor = UIColor.gray
            }
        }
    }
    
    func configureSelectedStateFor(cell: JTAppleCell?, cellState: CellState){
        
        guard let currentCell = cell as? CalendarCell else {
            return
        }
        
        if cellState.isSelected{
            currentCell.selectedView.isHidden = false
            currentCell.bgView.isHidden = true
        } else {
            currentCell.selectedView.isHidden = true
            currentCell.bgView.isHidden = true
        }
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let toDoItems = getToDoItems()
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateCellIdentifier = "ScheduleTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: dateCellIdentifier, for: indexPath) as? ScheduleTableViewCell else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        var toDoItems = getToDoItems()
        
        for toDo in toDoItems {
            print("-----")
            print(toDo.taskName)
            print("1321")
        }
        
        cell.taskNameLabel.text = toDoItems[indexPath.row].taskName
        //cell.startDateLabel.text = toDos[indexPath.row].workDate
        //cell.estTimeLabel.text = toDos[indexPath.row].estTime
        //cell.dueDateLabel.text = toDos[indexPath.row].dueDate
        
        return cell
    }
    
    // MARK: - Actions
    
    @IBAction func unwindToScheduleView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ItemInfoTableViewController, let toDo = sourceViewController.toDo {
            
            //print(toDo.taskName)
            
            addToDoItem(toDoItem: toDo)
            
            /*for toDo in toDos {
                print(toDo.taskName)
            }*/
            
            /*if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing ToDo
                // TODO: NEED FIXING?
                //toDos.append(toDo)
                //toDoDateGroup[selectedIndexPath.row] = dateFormatter.string(from: toDo.workDate)
                //toDoSections[selectedIndexPath.section].toDos[selectedIndexPath.row] = toDo
                //toDoSections[selectedIndexPath.section].toDos[selectedIndexPath.row] = toDo
                //tableView.reloadRows(at: [selectedIndexPath], with: .none)
                //tableView.reloadSections(IndexSet(selectedIndexPath), with: UITableView.RowAnimation.automatic)
                /*if let delToDo = toDoSections[selectedIndexPath.section].toDos.index(of: toDo) {
                 toDos.remove(at: delToDo)
                 }*/
                //toDos.remove(at: editedRow)
                //toDos.append(toDo)
                //tableView.reloadSections(IndexSet(selectedIndexPath), with: UITableView.RowAnimation.automatic)
                //print("Selected INDEX PATH")
                //print(IndexSet(selectedIndexPath).count)
            }*/ /*else {
                //toDos.append(toDo)
            }*/
            
            // Save the ToDos
            //saveToDos()
        }
    }
    
    // MARK: - Setters
    
    func setToDoItems(toDoItems: [ToDo]) {
        self.toDos = toDoItems
    }
    
    // MARK: - Getters
    
    func getToDoItems() -> [ToDo] {
        return self.toDos
    }
    
    // MARK: - Private Methods
    
    private func loadToDos() -> [ToDo]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ToDo.ArchiveURL.path) as? [ToDo]
    }
    
    private func reloadTableViewData() {
        DispatchQueue.main.async {
            self.toDoListTableView.reloadData()
        }
    }
    
    private func addToDoItem(toDoItem: ToDo) {
        self.toDos.append(toDoItem )
    }
}

extension ScheduleViewController: JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        configureCell(cell: cell, cellState: cellState)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "dd MM yy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        calendar.scrollingMode = .stopAtEachSection
        
        let startDate = formatter.date(from: "01 01 18")!
        let endDate = formatter.date(from: "31 12 20")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: numberOfRows,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfRow,
                                                 firstDayOfWeek: .sunday,
                                                 hasStrictBoundaries: true)
        return parameters
    }
}

extension ScheduleViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        configureCell(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "CalendarHeader", for: indexPath)
        let date = range.start
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        (header as! CalendarHeader).title.text = formatter.string(from: date)
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 40)
    }
}


