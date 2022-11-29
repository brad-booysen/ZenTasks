//
//  ProjectsSectionView.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/14/22.
//

import SwiftUI

/// Shows a horizontal list of projects for dashboard
struct ProjectsSectionView: View {
    
    @EnvironmentObject var manager: DataManager
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20,style: .continuous)
                .fill(Color.customOffWhite)
                .shadow(radius: 3, y: 2)
            VStack(spacing:3) {
                CustomHeaderView
                ProjectsCarouselView
                HeaderButton(title: "Create") {
                    manager.fullScreenMode = .addProject
                }
            }
            .padding(.bottom)
        }
        .padding(.all,8)
        
    }
    
    /// Custom header view
    private var CustomHeaderView: some View {
        HStack {
            VStack(alignment: .center) {
                Text("Projects").font(.system(size: 28, weight: .semibold))
                Text("You have").foregroundColor(.darkGrayColor) + Text(" \(manager.projects.count) ").bold().foregroundColor(.darkGrayColor) + Text("projects").foregroundColor(.darkGrayColor)
            }
        }.padding().padding(.bottom, -15).foregroundColor(.extraDarkGrayColor)
    }
    
    /// No projects view
    private var EmptyProjectsView: some View {
        VStack {
            Spacer()
            Image(systemName: "hammer.fill").font(.system(size: 25))
            Text("No Projects").bold()
            Text("You don't have any projects yet").font(.system(size: 15))
            Spacer()
        }.foregroundColor(.extraDarkGrayColor).frame(height: ProjectTileView.tileSize.height)
    }
    
    /// Projects carousel view
    private var ProjectsCarouselView: some View {
        let projects = manager.projects
        return ZStack {
            if projects.count > 0 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        Spacer(minLength: 18)
                        ForEach(0..<projects.count, id: \.self) { index in
                            Button {
                                manager.selectedProject = projects[index]
                                manager.fullScreenMode = .projectDetails
                            } label: {
                                ProjectTileView(project: projects[index]).environmentObject(manager)
                            }
                        }
                        Spacer(minLength: -10)
                    }.frame(height: ProjectTileView.tileSize.height)
                }.padding(.bottom, 10)
            } else {
                EmptyProjectsView
            }
        }
    }
}

// MARK: - Preview UI
struct ProjectsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        manager.projects = PreviewData.projects
        return ProjectsSectionView().environmentObject(manager)
    }
}

