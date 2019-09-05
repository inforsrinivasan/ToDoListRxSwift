//
//  TaskListViewController.swift
//  ToDoListRxSwift
//
//  Created by Srinivas on 05/09/19.
//  Copyright © 2019 Srinivasan Rajendran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController:UIViewController{
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var myTableView: UITableView!
    
    let taskBehaviour = BehaviorRelay<[Task]>.init(value: [])
    var filteredTasks = [Task]()
    
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "To Do List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        let priority = Priority.init(rawValue: sender.selectedSegmentIndex-1)
        self.filterTasks(priority: priority)
    }
    
}

extension TaskListViewController:UITableViewDelegate,UITableViewDataSource{
    
    func reloadTable(){
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        cell.textLabel?.text = filteredTasks[indexPath.row].task
        return cell
    }
    
}

extension TaskListViewController{
    // Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController{
            if let addTaskController = nav.viewControllers.first as? AddTaskViewController{
                addTaskController.taskObservable.subscribe(onNext: { [unowned self] task in
                    let priority = Priority(rawValue: self.segmentedControl.selectedSegmentIndex-1)
                    var newArr = [Task]()
                     let prevTasks = self.taskBehaviour.value
                    newArr.append(contentsOf: prevTasks)
                    newArr.append(task)
                    self.taskBehaviour.accept(newArr)
                    self.filterTasks(priority: priority)
                }).disposed(by: disposeBag)
                
            }
        }
    }
    
    // filter feature
    
    func filterTasks(priority:Priority?){
        if priority == nil{
            filteredTasks = taskBehaviour.value
            self.reloadTable()
        }
        else{
            self.taskBehaviour.map{ tasks in
                return tasks.filter { $0.priority == priority! }
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
                self?.reloadTable()
            }).disposed(by: disposeBag)
        }
    }
}
