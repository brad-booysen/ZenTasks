//
//  PreviewData.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/17/22.
//

import Foundation

/// Preview data for rendering/testing purposes
class PreviewData {
    
    /// Projects
    static let projects: [ProjectModel] = [
        .init(id: "1", name: "Food Planner App", description: "Show meal planners and diet plans", backgroundName: AppConfig.projectBackgrounds[0], dueDate: nil),
        .init(id: "2", name: "Dividends Tracker", description: "Create dividend portfolio using some free API if possible", backgroundName: AppConfig.projectBackgrounds[1], dueDate: nil),
        .init(id: "3", name: "Dating App", description: "The next generation of online dating", backgroundName: AppConfig.projectBackgrounds[2], dueDate: Calendar.current.endOfYear)
    ]
    
    /// Tasks
    static let tasks: [TaskModel] = [
        .init(id: "1", name: "Food App Design", description: "Create the app design for the food planner app", projectId: "1", startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, completed: true),
        .init(id: "2", name: "SwiftUI App Development", description: "Develop the main app components once the design is finalized", projectId: "1", startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())!, completed: false),
        .init(id: "3", name: "Booysenberry Product Webpage", description: "Create the webpage for the Food Planner app", projectId: "1", startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 12, to: Date())!, completed: true),
        
        .init(id: "4", name: "Research UI Designs", description: "Find the best UI design for a dividend tracker app", projectId: "2", startDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, endDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, completed: false),
        .init(id: "5", name: "Find Dividends API", description: "Research dividends data API that can be used for free in the app", projectId: "2", startDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!, completed: false)
    ]
}
