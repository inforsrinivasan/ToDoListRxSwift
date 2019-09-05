//
//  Task.swift
//  ToDoListRxSwift
//
//  Created by Srinivas on 05/09/19.
//  Copyright © 2019 Srinivasan Rajendran. All rights reserved.
//

import Foundation

enum Priority:Int{
    case low
    case medium
    case high
}

struct Task{
    var task:String
    var priority:Priority
}
