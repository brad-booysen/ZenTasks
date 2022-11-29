//
//  ProjectTileView.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/17/22.
//

import SwiftUI

/// Shows a project tile on the dashboard
struct ProjectTileView: View {
    
    @EnvironmentObject var manager: DataManager
    @State var previewMode: Bool = false
    static let tileSize: CGSize = CGSize(width: UIScreen.main.bounds.width-100, height: UIScreen.main.bounds.height/3.8)
    let project: ProjectModel
    
    // MARK: - Main rendering function
    var body: some View {
        let size = ProjectTileView.tileSize
        return ZStack {
            BackgroundImage
            VStack {
                ProjectTitleDescription
                Spacer()
                DueDateView
            }.padding(.vertical, 30).padding(.horizontal, 20)
            VStack {
                Spacer()
                ProgressBarView
            }.padding(.horizontal, 20).padding(.bottom, 70)
        }.frame(width: size.width, height: size.height, alignment: .center)
    }
    
    /// Project background image
    private var BackgroundImage: some View {
        let size = ProjectTileView.tileSize
        let backgroundImageName = previewMode ? manager.projectBackgroundName : project.backgroundName
        return GeometryReader { _ in
            Image(backgroundImageName).resizable()
                .frame(width: size.width, height: size.height-30, alignment: .center)
                .overlay(
                    LinearGradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0)], startPoint: .top, endPoint: .bottom)
                ).cornerRadius(20).background(
                    Image(backgroundImageName).resizable()
                        .frame(width: size.width, height: size.height-30, alignment: .center)
                        .cornerRadius(30).blur(radius: 5).opacity(0.4).offset(y: 5)
                ).offset(y: 15)
        }
    }
    
    /// Project title and description
    private var ProjectTitleDescription: some View {
        let projectName = previewMode ? manager.projectName : project.name
        let projectDescription = previewMode ? manager.projectDescription : project.description
        return HStack {
            VStack(alignment: .leading) {
                Text(projectName).font(.system(size: 21, weight: .semibold)).lineLimit(1)
                Text(projectDescription).font(.system(size: 12, weight: .light)).lineLimit(2)
            }.foregroundColor(.white).multilineTextAlignment(.leading)
            Spacer()
        }
    }
    
    /// Project progress bar view
    private var ProgressBarView: some View {
        let progress = manager.progress(forProject: project)
        return VStack(spacing: 5) {
            ZStack {
                GeometryReader { reader in
                    Capsule().frame(width: reader.size.width, height: 8, alignment: .center)
                        .foregroundColor(.whiteColor)
                    Capsule()
                        .fill(LinearGradient(gradient: Gradient(colors: [.yellow, .purple, .customBlue]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: progress > 0 ? (((progress * reader.size.width)/100.0)-2) : 0, height: 8, alignment: .center)
                }.frame(height: 8).overlay(
                    /// Checkmark overlay when progress is 100%
                    Image(systemName: "checkmark.seal.fill").font(.system(size: 30))
                        .background(
                            ZStack {
                                Image(systemName: "checkmark.seal.fill").font(.system(size: 33))
                                    .foregroundColor(.whiteColor)
                                Circle().foregroundColor(.whiteColor).padding(10)
                            }
                        ).overlay(
                            LinearGradient(colors: [.accentLightColor, .accentColor], startPoint: .top, endPoint: .bottom).mask(
                                Image(systemName: "checkmark.seal.fill").font(.system(size: 30))
                            )
                        ).opacity(progress == 100 ? 1 : 0)
                )
            }
            HStack {
                Text("Progress")
                Spacer()
                Text(String(format: "%.f%%", progress > 0 ? progress : 0))
            }.font(.system(size: 10, weight: .light)).foregroundColor(.whiteColor)
        }
    }
    
    /// Project due date view
    private var DueDateView: some View {
        let dueDate = previewMode ? (manager.enableDueDate ? manager.projectDueDate.longFormat : nil) : project.dueDate?.longFormat
        return HStack(spacing: 5) {
            Image(systemName: "calendar").font(.system(size: 15))
            Text("Due Date:")
            Spacer()
            Text(dueDate ?? "N/A")
        }.font(.system(size: 12)).foregroundColor(.whiteColor)
    }
}

// MARK: - Preview UI
struct ProjectTileView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        return ProjectTileView(project: PreviewData.projects[0]).environmentObject(manager)
    }
}

