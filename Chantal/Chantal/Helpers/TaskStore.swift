//
//  TasksStore.swift
//  Chantal
//
//  Created by Monte with Pillow on 9/15/18.
//  Copyright © 2018 Monte Thakkar. All rights reserved.
//

import Foundation

class TaskStore {
    var tasks = [Task]()
    
    func add(_ task: Task, at index: Int) {
        tasks.insert(task, at: index)
    }
    
    func replace(_ task: Task, at index: Int) {
        tasks[index] = task
    }

    @discardableResult func removeTask(at index: Int) -> Task {
        return tasks.remove(at: index)
    }
}
