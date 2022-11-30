//
//  TasksSectionView.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/14/22.
//

import SwiftUI

/// Shows a list of tasks for dashboard or based on project
struct TasksSectionView: View {
    
    @EnvironmentObject var manager: DataManager
    @State private var taskFilter: TaskFilterType = .all
    @State var allProjectTasks: Bool = false
    @State var project: ProjectModel?
    
    // MARK: - Main rendering function
    var body: some View {
        VStack {
            CustomHeaderView
            TasksFilterView
            TasksListView
        }.background(Color.backgroundColor)
    }
    
    /// Custom header view
    private var CustomHeaderView: some View {
        HStack {
            VStack(alignment: .center,spacing: 2) {
                Text(allProjectTasks ? "Project Tasks" : "Tasks")
                    .font(.system(size: 30, weight: .semibold))
                ZStack{
                    Rectangle()
                        .frame(height: 1)
                    HeaderButton(title: allProjectTasks ? "New Task" : "Add", image: allProjectTasks ? "plus" : nil) {
                        manager.showAddTaskOverlay = true
                        exitFlow()
                    }
                }
            }
            Spacer()
        }
        .padding().padding(.top, -5).foregroundColor(.extraDarkGrayColor)
    }
    
    /// Exit project details flow
    private func exitFlow() {
        manager.fullScreenMode = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            manager.selectedProject = nil
        }
    }
    
    /// Tasks filter view
    private var TasksFilterView: some View {
        HStack {
//            Text("Filter:")
//                .font(.system(size: 15, weight: .light))
//                .foregroundColor(.extraDarkGrayColor)
//            Spacer()
            ForEach(TaskFilterType.allCases) { filter in
                TaskFilter(type: filter)
                if filter == .all {
                    Color.lightGrayColor.frame(width: 1.5, height: 20)
                        .padding(.leading, 5)
                }
            }
            Spacer()
            Image(systemName: "line.3.horizontal.decrease.circle")
                .font(.title)
                .foregroundColor(.customBlue)
        }.padding(.horizontal)
    }
    
    /// Task filter item for filter type
    private func TaskFilter(type: TaskFilterType) -> some View {
        let count = filteredTasks(filter: type).count
        let color = taskFilter == type ? Color.customBlue : Color.lightGrayColor
        return Button {
            taskFilter = type
        } label: {
            HStack {
                Text(type.rawValue.capitalized)
                    .font(.system(size: 16, weight: .semibold))
                Text("\(count)").font(.system(size: 12, weight: .medium))
                    .padding(.horizontal, 10).padding(.vertical, 2)
                    .background(color.cornerRadius(10))
                    .foregroundColor(.lightColor)
            }
            .foregroundColor(color).lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.leading, 8)
        }
    }
    
    /// No tasks for today view
    private var EmptyTasksView: some View {
        VStack {
            Image(systemName: "checkmark.seal.fill").font(.system(size: 25))
            Text("No Tasks").bold()
            Text("You don't have any tasks matching this filter").font(.system(size: 15))
        }.foregroundColor(.extraDarkGrayColor).padding(.top, 40)
    }
    
    /// Tasks list view
    private var TasksListView: some View {
        ZStack {
            if filteredTasks(filter: taskFilter).count > 0 {
                LazyVStack(spacing: 20) {
                    ForEach(0..<filteredTasks(filter: taskFilter).count, id: \.self) { index in
                        TaskTileView(task: filteredTasks(filter: taskFilter)[index]).environmentObject(manager)
                    }
                }.padding(.top, 10)
            } else {
                EmptyTasksView
            }
        }
    }
    
    /// Filtered tasks
    private func filteredTasks(filter: TaskFilterType) -> [TaskModel] {
        let tasks = manager.tasks(forFilter: filter, todayOnly: !allProjectTasks, projectId: project?.id)
        return allProjectTasks ? tasks.sorted(by: { $0.endDate < $1.endDate }) : tasks
    }
}

// MARK: - Preview UI
struct TasksSectionView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        manager.projects = PreviewData.projects
        manager.tasks = PreviewData.tasks
        return TasksSectionView().environmentObject(manager)
    }
}
