//
//  ProjectDetailsContentView.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/14/22.
//

import SwiftUI

/// Shows the project details with a list of tasks
struct ProjectDetailsContentView: View {
    
    @EnvironmentObject var manager: DataManager
    
    // MARK: - Main rendering function
    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderView
            if let project = manager.selectedProject {
                ScrollView(.vertical, showsIndicators: false) {
                    TasksSectionView(allProjectTasks: true, project: project)
                }
            } else {
                Spacer()
            }
        }.background(Color.backgroundColor)
    }
    
    /// Custom header view
    private var CustomHeaderView: some View {
        return ZStack {
            Rectangle()
                .fill(Color.customOffWhite)
                .ignoresSafeArea()
            if let project = manager.selectedProject {
                ZStack {
                    Color.black.frame(width: ProjectTileView.tileSize.width, height: ProjectTileView.tileSize.height-30)
                        .cornerRadius(30).shadow(color: Color.black.opacity(0.5), radius: 20)
                    ProjectTileView(project: project)
                }
            }
            VStack {
                HStack {
                    Button {
                        if let project = manager.selectedProject {
                            presentAlert(title: "Delete Project", message: "Are you sure you want to delete this project and all of its tasks?", primaryAction: .Cancel, secondaryAction: .init(title: "Delete", style: .destructive, handler: { _ in
                                manager.deleteProject(project: project)
                            }))
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                    Spacer()
                    Button { exitFlow() } label: {
                        Image(systemName: "xmark")
                    }
                }
                Spacer()
            }.foregroundColor(.whiteColor).padding().padding(.top, -10)
        }.frame(height: ProjectTileView.tileSize.height * 1.2)
    }
    
    /// Exit project details flow
    private func exitFlow() {
        manager.fullScreenMode = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            manager.selectedProject = nil
        }
    }
}

// MARK: - Preview UI
struct ProjectDetailsContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        manager.projects = PreviewData.projects
        manager.tasks = PreviewData.tasks
        manager.selectedProject = manager.projects[0]
        return ProjectDetailsContentView().environmentObject(manager)
    }
}
