//
//  TaskModel.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/15/22.
//

import Foundation

/// A task model
struct TaskModel {
    let id: String
    let name: String
    let description: String
    let projectId: String
    let startDate: Date
    let endDate: Date
    let completed: Bool
    var createdAt: Date?
}

// MARK: - Build the TaskModel from Core Data entity
extension TaskModel {
    /// Build the model from entity
    static func build(entity: Task) -> TaskModel? {
        if let id = entity.id, let name = entity.name, let details = entity.details,
           let startDate = entity.start, let endDate = entity.end {
            return TaskModel(id: id, name: name, description: details, projectId: entity.project ?? "",
                             startDate: startDate, endDate: endDate, completed: entity.completed, createdAt: entity.date)
        }
        return nil
    }
}
