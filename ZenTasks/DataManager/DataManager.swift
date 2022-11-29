//
//  DataManager.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/15/22.
//

import UIKit
import SwiftUI
import CoreData
import Foundation

/// Main data manager for the app
class DataManager: NSObject, ObservableObject {
    
    /// Dynamic properties that the UI will react to
    @Published var fullScreenMode: FullScreenMode?
    @Published var projects: [ProjectModel] = [ProjectModel]()
    @Published var tasks: [TaskModel] = [TaskModel]()
    @Published var projectBackgroundName: String = AppConfig.projectBackgrounds[0]
    @Published var projectName: String = ""
    @Published var projectDescription: String = ""
    @Published var projectDueDate: Date = Date()
    @Published var enableDueDate: Bool = false
    @Published var avatarImage: UIImage?
    @Published var taskTitle: String = ""
    @Published var taskDescription: String = ""
    @Published var taskStartDate: Date = Date()
    @Published var taskEndDate: Date = Date()
    @Published var taskProjectId: String = ""
    @Published var showAddTaskOverlay: Bool = false
    @Published var selectedProject: ProjectModel?
    
    /// Dynamic properties that the UI will react to AND store values in UserDefaults
    @AppStorage("didShowTaskDeleteAlert") var didShowTaskDeleteAlert: Bool = false
    @AppStorage(AppConfig.premiumVersion) var isPremiumUser: Bool = false {
        didSet { Interstitial.shared.isPremiumUser = isPremiumUser }
    }
    
    /// Core Data container with the database model
    let container: NSPersistentContainer = NSPersistentContainer(name: "Database")
    
    /// Default init method. Load the Core Data container
    override init() {
        super.init()
        container.loadPersistentStores { _, _ in }
        avatarImage = UIImage.cached(key: "avatar")
    }
}

// MARK: - Get Tasks data
extension DataManager {
    /// Get all tasks based on filters
    func tasks(forFilter filter: TaskFilterType, todayOnly: Bool = true, projectId: String? = nil) -> [TaskModel] {
        var filteredTasks = tasks
        if let projectIdentifier = projectId {
            filteredTasks = tasks.filter { $0.projectId == projectIdentifier }
        }
        if todayOnly {
            filteredTasks = filteredTasks.filter { $0.startDate.monthDate == Date().monthDate }
        }
        switch filter {
        case .all: return filteredTasks
        case .open: return filteredTasks.filter { $0.completed == false }
        case .closed: return filteredTasks.filter { $0.completed == true }
        }
    }
    
    /// Get project model for a given task
    func project(forTask task: TaskModel) -> ProjectModel? {
        projects.first(where: { $0.id == task.projectId })
    }
    
    /// Get time remaining for a task
    func timeRemaining(forTask task: TaskModel) -> String {
        let startDate = task.startDate > Date() ? task.startDate : Date()
        return Calendar.current.timeRemaining(startDate: startDate, endDate: task.endDate)
    }
}

// MARK: - Get Projects/Tasks data
extension DataManager {
    /// Get project completion progress based on tasks
    func progress(forProject project: ProjectModel) -> Double {
        let projectTasks = tasks.filter { $0.projectId == project.id }
        let completedTasks = projectTasks.filter { $0.completed }
        return Double(completedTasks.count)/Double(projectTasks.count) * 100.0
    }
    
    /// Fetch all projects from Core Data
    func fetchAllProjects() {
        Interstitial.shared.loadInterstitial()
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date < %@)",
                                             Calendar.current.startOfYear as NSDate, Calendar.current.endOfYear as NSDate)
        if let results = try? container.viewContext.fetch(fetchRequest) {
            var allProjects = [ProjectModel]()
            results.forEach { project in
                if let projectModel = ProjectModel.build(entity: project) {
                    allProjects.append(projectModel)
                }
            }
            DispatchQueue.main.async { self.projects = allProjects }
        }
    }
    
    /// Fetch all tasks from Core Data
    func fetchAllTasks(completion: (() -> Void)? = nil) {
        Interstitial.shared.loadInterstitial()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date < %@)",
                                             Calendar.current.startOfYear as NSDate, Calendar.current.endOfYear as NSDate)
        if let results = try? container.viewContext.fetch(fetchRequest) {
            var allTasks = [TaskModel]()
            results.forEach { project in
                if let taskModel = TaskModel.build(entity: project) {
                    allTasks.append(taskModel)
                }
            }
            DispatchQueue.main.async {
                self.tasks = allTasks.sorted(by: { $0.createdAt ?? Date() > $1.createdAt ?? Date() })
                completion?()
            }
        }
    }
    
    /// Fetch task for a given identifier
    func fetchTask(id: String) -> Task? {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        return try? container.viewContext.fetch(fetchRequest).first
    }
    
    /// Fetch project for a given identifier
    func fetchProject(id: String) -> Project? {
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        return try? container.viewContext.fetch(fetchRequest).first
    }
}

// MARK: - Update avatar image
extension DataManager {
    /// Save avatar image to documents folder
    func updateAvatar(image: UIImage?) {
        DispatchQueue.main.async {
            self.avatarImage = image
            self.avatarImage?.cache(key: "avatar")
        }
    }
}

// MARK: - Save project
extension DataManager {
    /// Save project to Core Data
    func saveProject() {
        if !isPremiumUser && projects.count >= AppConfig.freeProjectsCount {
            presentAlert(title: "Pro Feature", message: "To add unlimited projects, you must upgrade to the Pro Version")
        } else {
            if projectName.isValid && projectDescription.isValid {
                let project = Project(context: container.viewContext)
                project.id = UUID().uuidString
                project.name = projectName
                project.details = projectDescription
                project.background = projectBackgroundName
                project.date = Date()
                if enableDueDate {
                    project.dueDate = projectDueDate
                }
                try? container.viewContext.save()
                fetchAllProjects()
                fullScreenMode = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.resetProjectDetails()
//                    Interstitial.shared.showInterstitialAds()
                }
            } else {
                presentAlert(title: "Missing Fields", message: "Make sure you have a project name and description")
            }
        }
    }
    
    /// Reset project details
    func resetProjectDetails() {
        projectBackgroundName = AppConfig.projectBackgrounds[0]
        projectName = ""
        projectDescription = ""
        projectDueDate = Date()
        enableDueDate = false
    }
}

// MARK: - Save task
extension DataManager {
    /// Save current task data
    func saveTask() {
        if !isPremiumUser && tasks.count >= AppConfig.freeTasksCount {
            presentAlert(title: "Pro Feature", message: "To add unlimited tasks, you must upgrade to the Pro Version")
        } else {
            if taskTitle.isValid && taskDescription.isValid {
                let task = Task(context: container.viewContext)
                task.id = UUID().uuidString
                task.name = taskTitle
                task.details = taskDescription
                task.start = taskStartDate
                task.end = taskEndDate
                task.date = Date()
                task.project = taskProjectId
                try? container.viewContext.save()
                fetchAllTasks()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.resetTaskDetails()
//                    Interstitial.shared.showInterstitialAds()
                    if self.didShowTaskDeleteAlert == false {
                        self.didShowTaskDeleteAlert = true
                        presentAlert(title: "Want to delete a task?", message: "Simply triple tap on a task to delete it")
                    }
                }
            } else {
                presentAlert(title: "Missing Fields", message: "Make sure you have a task name and description")
            }
        }
    }
    
    /// Reset task details
    func resetTaskDetails() {
        taskTitle = ""
        taskDescription = ""
        taskStartDate = Date()
        taskEndDate = Date()
        taskProjectId = ""
    }
}

// MARK: - Update task status
extension DataManager {
    /// Update task state
    func updateTaskState(task: TaskModel) {
        guard let taskEntity = fetchTask(id: task.id) else { return }
        taskEntity.completed = !taskEntity.completed
        try? container.viewContext.save()
        fetchAllTasks {
            let notCompletedTasks = self.tasks.filter { $0.projectId == task.projectId }.filter { !$0.completed }
            if notCompletedTasks.count == 0 {
                ConfettiView.showConfettiOverlay()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    Interstitial.shared.showInterstitialAds()
                }
            } else {
                Interstitial.shared.showInterstitialAds()
            }
        }
    }
}

// MARK: - Delete task/project
extension DataManager {
    /// Delete task
    func deleteTask(task: TaskModel, refresh: Bool = true) {
        guard let taskEntity = fetchTask(id: task.id) else { return }
        container.viewContext.delete(taskEntity)
        try? container.viewContext.save()
        if refresh { fetchAllTasks() }
    }
    
    /// Delete an entire project with all associated tasks
    func deleteProject(project: ProjectModel) {
        guard let projectEntity = fetchProject(id: project.id) else { return }
        container.viewContext.delete(projectEntity)
        try? container.viewContext.save()
        tasks.filter { $0.projectId == project.id }.forEach { task in
            deleteTask(task: task, refresh: false)
        }
        fetchAllTasks()
        fetchAllProjects()
        fullScreenMode = nil
    }
}
