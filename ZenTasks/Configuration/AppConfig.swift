//
//  AppConfig.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/15/22.
//

import UIKit
import SwiftUI
import Foundation

/// Generic configurations for the app
class AppConfig {
    
    /// This is the AdMob Interstitial ad id
    /// Test App ID: ca-app-pub-3940256099942544~1458002511
    static let adMobAdId: String = "ca-app-pub-7548745678690435/3033821201"
    
    // MARK: - Settings flow items
    static let emailSupport = "hey@booysenberry.com"
    static let privacyURL: URL = URL(string: "https://booysenberry.com/zentasks-app")!
    static let yourAppURL: URL = URL(string: "https://apps.apple.com/app/idXXXXXXXXX")!
    
    // MARK: - Generic Configurations
    static let appLaunchDelay: TimeInterval = 1.5
    static let confettiDuration: TimeInterval = 2.5
    static let confettiSpeed: CGFloat = 450
    static let confettiColors: [Color] = [Color(#colorLiteral(red: 0.1884031892, green: 0.6164012551, blue: 0.7388934493, alpha: 1)), Color(#colorLiteral(red: 0.1884031892, green: 0.7812900772, blue: 0.7388934493, alpha: 1)), Color(#colorLiteral(red: 0.8304590583, green: 0.2868802845, blue: 0.5694329143, alpha: 1)), Color(#colorLiteral(red: 0.9708533654, green: 0.2868802845, blue: 0.5694329143, alpha: 1)), Color(#colorLiteral(red: 0.5536777973, green: 0.4510317445, blue: 0.9476286769, alpha: 1)), Color(#colorLiteral(red: 0.5536777973, green: 0.6288913198, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.973535955, green: 0.2599409819, blue: 0.299492985, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.493189179, blue: 0.299492985, alpha: 1))]
    static let projectBackgrounds: [String] = ["gray-diamond", "black-grill", "dark-shades", "blur-ocean", "dark-gradient", "red-waves", "blue-waves", "multicolor-waves", "blue-moon", "sunset-sky", "evening-mountains", "night-laptop"]
    
    // MARK: - In App Purchases
    static let premiumVersion: String = "ZenTasks.Premium"
    static let freeProjectBackgroundsCount = 3
    static let freeProjectsCount: Int = 1
    static let freeTasksCount: Int = 10
}

// MARK: - Full Screen flow
enum FullScreenMode: Int, Identifiable {
    case addProject, photoPicker, projectDetails, premium
    var id: Int { hashValue }
}

// MARK: - Months of the year
enum Month: String, CaseIterable, Identifiable {
    case january, february, march, april, may, june, july, august, september, october, november, december
    var id: Int { hashValue }
    var short: String { rawValue.prefix(3).capitalized }
}

// MARK: - Tasks filter
enum TaskFilterType: String, CaseIterable, Identifiable {
    case all, open, closed
    var id: Int { hashValue }
}

// MARK: - Color configurations
extension Color {
    static let whiteColor: Color = Color("WhiteColor")
    static let darkGrayColor: Color = Color("DarkGrayColor")
    static let extraDarkGrayColor: Color = Color("ExtraDarkGrayColor")
    static let accentLightColor: Color = Color("AccentLightColor")
    static let backgroundColor: Color = Color("BackgroundColor")
    static let lightBlueColor: Color = Color("LightBlueColor")
    static let lightColor: Color = Color("LightColor")
    static let lightGrayColor: Color = Color("LightGrayColor")
    static let sideMenuStartColor: Color = Color("SideMenuStartColor")
    static let sideMenuEndColor: Color = Color("SideMenuEndColor")
    static let redStartColor: Color = Color("RedStartColor")
    static let redEndColor: Color = Color("RedEndColor")
    static let customBlue: Color = Color("CustomBlue")
    static let customGray: Color = Color("CustomGray")
    static let customOffWhite: Color = Color("CustomOffWhite")
    static let customPink: Color = Color("CustomPink")

}
