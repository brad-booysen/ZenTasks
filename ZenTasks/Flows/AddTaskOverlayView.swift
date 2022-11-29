//
//  AddTaskOverlayView.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/14/22.
//

import SwiftUI

/// Add task overlay for dashboard
struct AddTaskOverlayView: View {
   
    @EnvironmentObject var manager: DataManager
    @State private var startEnterAnimation: Bool = false
    @State private var startExitAnimation: Bool = false
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .opacity(startEnterAnimation ? (startExitAnimation ? 0 : 0.8) : 0)
                .onTapGesture { exitFlow() }
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Add Task").font(.system(size: 22, weight: .semibold))
                        Spacer()
                        HeaderButton(title: "Save") { exitFlow(save: true) }
                    }
                    Color.lightGrayColor.frame(height: 1).opacity(0.4).padding(.top)
                    ScrollView(.vertical, showsIndicators: false) {
                        Spacer(minLength: 10)
                        TaskDetailsContainerView
                    }.frame(height: UIScreen.main.bounds.height/2.4)
                }
                .padding([.top, .horizontal]).padding(.horizontal, 5)
                .foregroundColor(.extraDarkGrayColor).background(
                    RoundedCorner(radius: 30, corners: [.topLeft, .topRight])
                        .foregroundColor(.customOffWhite).ignoresSafeArea()
                )
                .offset(y: startEnterAnimation ? (startExitAnimation ? UIScreen.main.bounds.height : 0) : UIScreen.main.bounds.height)
            }
        }.onAppear {
            if startEnterAnimation == false {
                withAnimation { startEnterAnimation = true }
            }
        }
    }
    
    /// Exit flow action
    private func exitFlow(save: Bool = false) {
        hideKeyboard()
        if save { manager.saveTask() }
        withAnimation { startExitAnimation = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            manager.showAddTaskOverlay = false
        }
    }
    
    /// Task details container view
    private var TaskDetailsContainerView: some View {
        VStack {
            TaskTitleDescriptionSection
            TaskStartEndDateSection
            ChooseProjectSection
        }
    }
    
    /// Task title and description section
    private var TaskTitleDescriptionSection: some View {
        VStack {
            VStack(spacing: 0) {
                TextField("Task Name", text: $manager.taskTitle)
                    .font(.system(size: 18, weight: .semibold)).padding(.vertical)
                Color.lightGrayColor.frame(height: 1).opacity(0.4)
            }
            VStack(spacing: 0) {
                TextField("Description", text: $manager.taskDescription)
                    .font(.system(size: 15)).padding(.vertical)
                Color.lightGrayColor.frame(height: 1).opacity(0.4)
            }
        }.foregroundColor(.extraDarkGrayColor)
    }
    
    /// Task stard/end date
    private var TaskStartEndDateSection: some View {
        VStack(spacing: 5) {
            VStack {
                HStack {
                    Text("Due Date:")
                    Spacer()
                    DatePicker("", selection: $manager.taskEndDate, in: manager.taskStartDate...).labelsHidden()
                }
            }.font(.system(size: 18, weight: .medium)).opacity(0.75)
        }.foregroundColor(.extraDarkGrayColor).padding(.vertical, 10)
    }
    
    /// Choose a project section
    private var ChooseProjectSection: some View {
        let projects = manager.projects
        return ZStack {
            if projects.count > 0 {
                VStack(alignment: .leading, spacing: 0) {
                    Color.lightGrayColor.frame(height: 1)
                        .opacity(0.4).padding(.bottom, 15)
                    Text("Choose project:").font(.system(size: 18, weight: .medium)).opacity(0.75)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            Spacer(minLength: -14)
                            NoProjectItem
                            ForEach(0..<projects.count, id: \.self) { index in
                                ProjectItem(atIndex: index)
                            }
                            Spacer(minLength: -14)
                        }
                    }.padding(.top, 5)
                }
            }
        }
    }
    
    /// Project carousel item
    private func ProjectItem(atIndex index: Int) -> some View {
        let projects = manager.projects
        return Image(projects[index].backgroundName).resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 70, alignment: .center)
            .cornerRadius(12).padding(2).overlay(
                ZStack {
                    Color.black.cornerRadius(12).opacity(0.4).padding(2)
                    HStack {
                        Text(projects[index].name)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.whiteColor)
                            .padding(.vertical, 7).padding(.horizontal, 10)
                        Spacer()
                    }
                }
            )
            .opacity(projects[index].id == manager.taskProjectId ? 1 : 0.3)
            .onTapGesture { manager.taskProjectId = projects[index].id }
    }
    
    /// No project item
    private var NoProjectItem: some View {
        ZStack {
            Color.darkGrayColor.cornerRadius(12)
                .frame(width: 100, height: 70, alignment: .center)
            VStack {
                Image(systemName: "xmark").font(.system(size: 17, weight: .bold))
                Text("No Project").font(.system(size: 12, weight: .bold))
            }.foregroundColor(.lightColor)
        }.contentShape(Rectangle()).onTapGesture { manager.taskProjectId = "" }
    }
}

// MARK: - Preview UI
struct AddTaskOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        manager.projects = PreviewData.projects
        return AddTaskOverlayView().environmentObject(manager)
    }
}

