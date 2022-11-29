//
//  AddProjectContentView.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/14/22.
//

import SwiftUI

/// Create project flow
struct AddProjectContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @State var didShowKeyboard: Bool = false
    
    // MARK: - Main rendering function
    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderView
            Divider()
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ProjectBackgroundSection
                        ProjectTitleDescriptionSection
                        ProjectDueDateSection
                    }
                    Spacer(minLength: 100)
                }
                SaveProjectSection
            }
        }.background(
            LinearGradient(colors: [Color.lightColor, Color.backgroundColor], startPoint: .top, endPoint: .bottom)
        ).onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { _ in
                didShowKeyboard = true
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { _ in
                didShowKeyboard = false
            }
        }
    }
    
    /// Custom header view
    private var CustomHeaderView: some View {
        ZStack {
            Text("Add Project").font(.system(size: 20, weight: .bold))
            HStack {
                Spacer()
                Button {
                    if didShowKeyboard {
                        hideKeyboard()
                    } else {
                        manager.fullScreenMode = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            manager.resetProjectDetails()
                        }
                    }
                } label: {
                    Image(systemName: didShowKeyboard ? "keyboard.chevron.compact.down" : "xmark")
                }
            }
        }.padding().padding(.top, -10).foregroundColor(.extraDarkGrayColor).background(
            Color.customOffWhite.ignoresSafeArea()
        )
    }
    
    /// Project background section
    private var ProjectBackgroundSection: some View {
        let backgrounds = AppConfig.projectBackgrounds
        return VStack(spacing: 0) {
            ProjectTileView(previewMode: true, project: PreviewData.projects[0])
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    Spacer(minLength: 1)
                    ForEach(0..<backgrounds.count, id: \.self) { index in
                        BackgroundCarouselItem(atIndex: index)
                    }
                    Spacer(minLength: 1)
                }
            }
        }.background(
            Color.customOffWhite.shadow(color: Color.black.opacity(0.05), radius: 5, y: 5)
        ).padding(.bottom, 10)
    }
    
    /// Background carousel item
    private func BackgroundCarouselItem(atIndex index: Int) -> some View {
        let backgrounds = AppConfig.projectBackgrounds
        return Image(backgrounds[index]).resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 70, alignment: .center)
            .cornerRadius(12).padding(4).overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.accentColor, lineWidth: manager.projectBackgroundName == backgrounds[index] ? 2 : 0)
                    if !manager.isPremiumUser && index >= AppConfig.freeProjectBackgroundsCount {
                        Color.black.opacity(0.5).cornerRadius(12).padding(4)
                        Image(systemName: "crown.fill").foregroundColor(.whiteColor)
                    }
                }
            ).padding(.vertical).onTapGesture {
                if !manager.isPremiumUser && index >= AppConfig.freeProjectBackgroundsCount {
                    presentAlert(title: "Pro Feature", message: "To unlock all backgrounds, you must upgrade to the Pro version")
                } else {
                    manager.projectBackgroundName = backgrounds[index]
                }
            }
    }
    
    /// Project title and description section
    private var ProjectTitleDescriptionSection: some View {
        VStack {
            VStack(spacing: 0) {
                TextField("Project Name", text: $manager.projectName)
                    .font(.system(size: 20, weight: .semibold)).padding()
                Color.lightGrayColor.frame(height: 1).padding(.horizontal).opacity(0.4)
            }
            VStack(spacing: 0) {
                TextField("Description", text: $manager.projectDescription)
                    .font(.system(size: 15)).padding()
                Color.lightGrayColor.frame(height: 1).padding(.horizontal).opacity(0.4)
            }
        }.foregroundColor(.extraDarkGrayColor).background(
            Color.backgroundColor
        )
    }
    
    /// Project due date
    private var ProjectDueDateSection: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: "calendar")
                Text("Due Date:")
                Spacer()
                DatePicker("", selection: $manager.projectDueDate, in: Calendar.current.tomorrow..., displayedComponents: .date)
                    .opacity(manager.enableDueDate ? 1 : 0)
                Spacer()
                Toggle("", isOn: $manager.enableDueDate).labelsHidden()
            }
            .font(.system(size: 18, weight: .medium))
            .padding().padding(.bottom, -5)
            Color.lightGrayColor.frame(height: 1).padding(.horizontal).opacity(0.4)
        }.foregroundColor(.extraDarkGrayColor).background(
            Color.backgroundColor
        )
    }
    
    /// Save project button
    private var SaveProjectSection: some View {
        Button { manager.saveProject() } label: {
            ZStack {
                Color.customBlue.cornerRadius(40)
                Text("Save Project").bold().font(.title3)
            }.foregroundColor(.whiteColor)
        }.frame(height: 50).padding().background(
            Color.customOffWhite.shadow(color: Color.black.opacity(0.05), radius: 5, y: -5).ignoresSafeArea()
        )
    }
}

// MARK: - Preview UI
struct AddProjectContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        return AddProjectContentView()
            .environmentObject(manager)
            .preferredColorScheme(.light)
    }
}

