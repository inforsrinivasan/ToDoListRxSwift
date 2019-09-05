//
//  AddTaskViewController.swift
//  ToDoListRxSwift
//
//  Created by Srinivas on 05/09/19.
//  Copyright © 2019 Srinivasan Rajendran. All rights reserved.
//

import UIKit
import RxSwift

class AddTaskViewController:UIViewController{
    
    private let taskPublishSubject = PublishSubject<Task>()
    
    var taskObservable:Observable<Task>{
        return taskPublishSubject.asObservable()
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var taskTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        guard  let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex),
            let taskText = taskTextField.text else{
                return
        }
        let task = Task.init(task: taskText, priority: priority)
        taskPublishSubject.onNext(task)
        self.dismiss(animated: true, completion: nil)
    }
    
}
