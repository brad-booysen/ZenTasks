//
//  SideMenuContentView.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/14/22.
//

import SwiftUI
import StoreKit
import MessageUI

/// Shows the left side menu for the app
struct SideMenuContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @Binding var showSideMenu: Bool
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.sideMenuEndColor, Color.customBlue], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 10) {
                CloseBarButton
                ScrollView(.vertical, showsIndicators: false) {
                    AvatarView
                    VStack(spacing: 10) {
                        SettingsItem(title: "Pro", icon: "crown.fill") {
                            manager.fullScreenMode = .premium
                        }
                        SettingsItem(title: "Restore", icon: "arrow.clockwise.circle.fill") {
                            manager.fullScreenMode = .premium
                        }
                        
                        SettingsItem(title: "Rate App", icon: "star.fill") {
                            if let scene = UIApplication.shared.windows.first?.windowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        }.padding(.top, 30)
                        SettingsItem(title: "Share App", icon: "square.and.arrow.up.fill") {
                            let shareController = UIActivityViewController(activityItems: [AppConfig.yourAppURL], applicationActivities: nil)
                            rootController?.present(shareController, animated: true, completion: nil)
                        }
                        SettingsItem(title: "Email us", icon: "envelope.badge.fill") {
                            EmailPresenter.shared.present()
                        }.padding(.top, 30)
                        SettingsItem(title: "Privacy Policy", icon: "hand.raised.fill") {
                            UIApplication.shared.open(AppConfig.privacyURL)
                        }
                    }.lineLimit(1).minimumScaleFactor(0.7)
                }.frame(width: UIScreen.main.bounds.width/2.2)
            }.padding().padding(.horizontal, 10)
        }
    }
    
    /// Close bar button
    private var CloseBarButton: some View {
        HStack {
            Button {
                withAnimation { showSideMenu = false }
            } label: {
                Image(systemName: "xmark")
            }.foregroundColor(.whiteColor)
            Spacer()
        }
    }
    
    /// Avatar view
    private var AvatarView: some View {
        Button {
            manager.fullScreenMode = .photoPicker
        } label: {
            if let avatar = manager.avatarImage {
                Image(uiImage: avatar).resizable().aspectRatio(contentMode: .fill).mask(Circle()).padding(10).background(
                    ZStack {
                        Circle().foregroundColor(.lightColor).opacity(0.2)
                        Circle().foregroundColor(.lightColor).opacity(0.4).padding(5)
                    }
                )
            } else {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 65)).padding(10)
            }
        }
        .frame(width: 75, height: 75, alignment: .center)
        .foregroundColor(.whiteColor).padding(.vertical, 40)
        .offset(x: -15)
    }
    
    /// Settings item
    private func SettingsItem(title: String, icon: String, completion: @escaping () -> Void) -> some View {
        HStack {
            Button {
                withAnimation { showSideMenu = false }
                completion()
            } label: {
                HStack {
                    Image(systemName: icon).font(.system(size: 20))
                        .offset(y: -2).frame(width: 30, height: 30)
                    Text(title).font(.system(size: 17, weight: .semibold))
                }.foregroundColor(.whiteColor)
            }
            Spacer()
        }
    }
}

// MARK: - Preview UI
struct SideMenuContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        return SideMenuContentViewPreview().environmentObject(manager)
    }
    
    struct SideMenuContentViewPreview: View {
        @State private var showSideMenuFlow: Bool = false
        var body: some View {
            SideMenuContentView(showSideMenu: $showSideMenuFlow)
        }
    }
}

// MARK: - Mail presenter for SwiftUI
class EmailPresenter: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailPresenter()
    private override init() { }
    
    func present() {
        if !MFMailComposeViewController.canSendMail() {
            presentAlert(title: "Email Client", message: "Your device must have the native iOS email app installed for this feature.")
            return
        }
        let picker = MFMailComposeViewController()
        picker.setToRecipients([AppConfig.emailSupport])
        picker.mailComposeDelegate = self
        rootController?.present(picker, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        rootController?.dismiss(animated: true, completion: nil)
    }
}
