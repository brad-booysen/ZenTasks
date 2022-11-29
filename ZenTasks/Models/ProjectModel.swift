//
//  ProjectModel.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/15/22.
//

import Foundation

/// A project model
struct ProjectModel {
    let id: String
    let name: String
    let description: String
    let backgroundName: String
    let dueDate: Date?
    var createdAt: Date?
}

// MARK: - Build the ProjectModel from Core Data entity
extension ProjectModel {
    /// Build the model from entity
    static func build(entity: Project) -> ProjectModel? {
        if let id = entity.id, let name = entity.name, let details = entity.details, let background = entity.background {
            return ProjectModel(id: id, name: name, description: details,
                                backgroundName: background, dueDate: entity.dueDate, createdAt: entity.date)
        }
        return nil
    }
}
