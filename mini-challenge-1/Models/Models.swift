//
//  Models.swift
//  mini-challenge-1
//
//  Created by Dicky Geraldi on 05/04/20.
//  Copyright © 2020 Dicky Geraldi. All rights reserved.
//

import Foundation

struct Goals {
    var date: String
    var goalName: String
    var id: String
    var status: Bool
    
    init(date: String, goalName: String, id: String, status: Bool) {
        self.date = date
        self.goalName = goalName
        self.id = id
        self.status = status
    }
}

struct Tasks {
    var distraction: Int
    var duration: Int
    var goalId: String
    var id: String
    var start: String
    var status: Bool
    var taskName: String
    
    init(distraction: Int, duration: Int, goalId: String, id: String, start: String, status: Bool, taskName: String) {
        self.duration = duration
        self.distraction = distraction
        self.goalId = goalId
        self.id = id
        self.start = start
        self.status = status
        self.taskName = taskName
    }
}

    struct ReportData {
    var totalGoalsCompleted: Int
    var totalTaskCompleted: Int
    var productiveTime: Int
    var totalTimeDistraction: Int
    
    init(totalGoalsCompleted: Int, totalTaskCompleted: Int, productivetime: Int, totalTimeDistraction: Int) {
        self.productiveTime = productivetime
        self.totalGoalsCompleted = totalGoalsCompleted
        self.totalTaskCompleted = totalTaskCompleted
        self.totalTimeDistraction = totalTimeDistraction
    }
    
    
}
