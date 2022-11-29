//
//  DashboardContentView.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/14/22.
//

import SwiftUI

/// Main dashboard for the app
struct DashboardContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @State private var showSideMenuFlow: Bool = false
    private let screenWidth: Double = UIScreen.main.bounds.width
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            /// Side menu as a background view
            SideMenuContentView(showSideMenu: $showSideMenuFlow).environmentObject(manager)
            Color.clear.overlay(
                LinearGradient(colors: [Color.lightColor, Color.backgroundColor], startPoint: .top, endPoint: .bottom)
                    .cornerRadius(showSideMenuFlow ? 40 : UIDevice.current.hasNotch ? 30 : 0)
                    .padding(.vertical, showSideMenuFlow ? 48 : 0).ignoresSafeArea()
            ).offset(x: showSideMenuFlow ? screenWidth/1.8 : 0)

            /// Main dashboard container
            VStack(spacing: 0) {
                CustomHeaderView
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ProjectsSectionView()
                        TasksSectionView()
                    }.environmentObject(manager)
                    Spacer(minLength: 40)
                }.background(
                    LinearGradient(colors: [Color.lightColor, Color.backgroundColor], startPoint: .top, endPoint: .bottom)
                )
            }
            .cornerRadius(showSideMenuFlow ? 40 : 0)
            .background(LayeredBackgroundView)
            .offset(x: showSideMenuFlow ? screenWidth/1.8 : 0)
            .disabled(showSideMenuFlow)
            
            /// Show add task overlay
            if manager.showAddTaskOverlay {
                AddTaskOverlayView().environmentObject(manager)
            }
        }
        /// Fetch all data
        .onAppear {
            manager.fetchAllProjects()
            manager.fetchAllTasks()
        }
        /// Present full screen flows
        .fullScreenCover(item: $manager.fullScreenMode) { type in
            switch type {
            case .photoPicker:
                PhotoPicker { image in manager.updateAvatar(image: image) }
            case .addProject:
                AddProjectContentView().environmentObject(manager)
            case .projectDetails:
                ProjectDetailsContentView().environmentObject(manager)
            case .premium:
                PremiumView
            }
        }
    }
    
    /// Layered background for main dashboard
    private var LayeredBackgroundView: some View {
        ZStack {
            Color.backgroundColor.cornerRadius(40)
                .offset(x: -54).padding(35).opacity(0.2)
            Color.backgroundColor.cornerRadius(40)
                .offset(x: -25).padding().opacity(0.5)
        }
    }
    
    /// Custom header view
    private var CustomHeaderView: some View {
        ZStack{
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Text("ZenTasks").font(.system(size: 30, weight: .bold))
                }
                Spacer()
            }.padding().foregroundColor(.extraDarkGrayColor).background(
                Color.lightColor.ignoresSafeArea()
            )
            HStack{
                Spacer()
                Button {
                    withAnimation { showSideMenuFlow = true }
                } label: {
                    ZStack {
                        if let avatar = manager.avatarImage {
                            Image(uiImage: avatar).resizable().aspectRatio(contentMode: .fill).mask(Circle())
                        } else {
                            Image(systemName: "gearshape.fill").font(.system(size: 30))
                        }
                        Color.backgroundColor.mask(Circle()).opacity(showSideMenuFlow ? 1 : 0)
                    }
                }.frame(width: 36, height: 36, alignment: .center)
                    .padding().foregroundColor(.customBlue).background(
                        Color.lightColor.ignoresSafeArea()
                    )

            }
            
        }
    }
    
    /// Premium in-app purchases view
    private var PremiumView: some View {
        PremiumContentView(title: "PRO Version", subtitle: "Unlock All Features", features: ["Remove Ads", "Project Backgrounds", "Unlimited Projects", "Unlimited Tasks"], productIds: [AppConfig.premiumVersion]) {
            manager.fullScreenMode = nil
        } completion: { _, status, _ in
            DispatchQueue.main.async {
                manager.fullScreenMode = nil
                if status == .success || status == .restored {
                    manager.isPremiumUser = true
                }
            }
        }
    }
}

// MARK: - Preview UI
struct DashboardContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        manager.tasks = PreviewData.tasks
        manager.projects = PreviewData.projects
        return DashboardContentView()
            .environmentObject(manager)
            .preferredColorScheme(.light)
    }
}
