//
//  TaskTileView.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/17/22.
//

import SwiftUI

/// Shows a task tile on the tasks list
struct TaskTileView: View {
    
    @EnvironmentObject var manager: DataManager
    let task: TaskModel
    
    // MARK: - Main rendering function
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(task.name).font(.system(size: 18))
                    Text(manager.project(forTask: task)?.name ?? "N/A").font(.system(size: 14, weight: .light))
                }
                Spacer()
                Button {
                    manager.updateTaskState(task: task)
                } label: {
                    Image(systemName: task.completed ? "checkmark.circle.fill" : "circle").font(.system(size: 26))
                        .overlay(
                            LinearGradient(colors: [.accentColor, .customBlue], startPoint: .top, endPoint: .bottom)
                                .mask(Image(systemName: task.completed ? "checkmark.circle.fill" : "circle").font(.system(size: 26)))
                        )
                }
            }.lineLimit(1)
            Divider()
            if task.description.isValid {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Description:").font(.system(size: 13, weight: .medium))
                        Text(task.description).font(.system(size: 12, weight: .light))
                    }
                    Spacer()
                }
                Divider()
            }
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("DUE:").bold() + Text(" ") + Text(task.endDate.string(format: "MMM d, hh:m a"))
                }.font(.system(size: 12))
                Spacer()
                VStack {
                    Text(manager.timeRemaining(forTask: task))
                        .font(.system(size: 12, weight: .medium))
                    Text(manager.timeRemaining(forTask: task) == "- -" ? "overdue" : "remaining")
                        .font(.system(size: 10))
                }.padding(.horizontal, 12).padding(.vertical, 5).background(
                    LinearGradient(colors: manager.timeRemaining(forTask: task) == "- -" ? [.redStartColor, .redEndColor] : [.darkGrayColor, .extraDarkGrayColor], startPoint: .top, endPoint: .bottom).cornerRadius(8).opacity(0.85)
                ).foregroundColor(.lightColor)
            }.padding(.top, 2).opacity(task.completed ? 0.3 : 1)
        }.padding().background(
            Color.customOffWhite.cornerRadius(15)
                .shadow(radius: 3, y: 2)
        ).padding(.horizontal).onTapGesture(count: 3) {
            presentAlert(title: "Delete Task", message: "Are you sure you want to delete this task?", primaryAction: .Cancel, secondaryAction: .init(title: "Delete", style: .destructive, handler: { _ in
                manager.deleteTask(task: task)
            }))
        }
    }
}

// MARK: - Preview UI
struct TaskTileView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        manager.projects = PreviewData.projects
        return TaskTileView(task: PreviewData.tasks[0]).environmentObject(manager)
    }
}

