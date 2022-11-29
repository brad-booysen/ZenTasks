//
//  ZenTasksApp.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/14/22.
//

import SwiftUI

@main
struct ZenTasksApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var manager: DataManager = DataManager()
    
    // MARK: - Main rendering function
    var body: some Scene {
        WindowGroup {
            DashboardContentView().environmentObject(manager)
        }
    }
}

// MARK: - Useful extensions
extension Date {
    var longFormat: String {
        string(format: "MMM d, yyyy")
    }
    
    var month: String {
        string(format: "MMMM")
    }
    
    var monthDate: String {
        string(format: "MMM d")
    }
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension Calendar {
    var startOfYear: Date {
        date(from: dateComponents([.year], from: Date()))!
    }
    
    var endOfYear: Date {
        date(from: DateComponents(year: dateComponents([.year], from: Date()).year!, month: 12, day: 31))!
    }
    
    var tomorrow: Date {
        date(byAdding: .day, value: 1, to: Date())!
    }
    
    func timeRemaining(startDate: Date, endDate: Date) -> String {
        func formattedTime(amount: Int?, component: Calendar.Component) -> String? {
            if let time = amount, time > 0 { return "\(time) \(component)\(time > 1 ? "s" : "")" }
            return nil
        }
        
        let dateComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: startDate, to: endDate)
        if let daysLeft = formattedTime(amount: dateComponents.day, component: .day) {
            return daysLeft
        } else if let hoursLeft = formattedTime(amount: dateComponents.hour, component: .hour) {
            return hoursLeft
        } else if let minutesLeft = formattedTime(amount: dateComponents.minute, component: .minute) {
            return minutesLeft
        }
        
        return "- -"
    }
}

extension String {
    var isValid: Bool {
        !trimmingCharacters(in: .whitespaces).isEmpty
    }
}

extension UIImage {
    func cache(key: String) {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsUrl.appendingPathComponent("\(key).jpg")
        if let imageData = jpegData(compressionQuality: 1.0) {
            try? imageData.write(to: fileURL, options: .atomic)
        }
    }
    
    static func cached(key: String) -> UIImage? {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsUrl.appendingPathComponent("\(key).jpg")
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {}
        return nil
    }
}

/// Create a shape with specific rounded corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

/// Present an alert from anywhere in the app
func presentAlert(title: String, message: String, primaryAction: UIAlertAction = .OK, secondaryAction: UIAlertAction? = nil, tertiaryAction: UIAlertAction? = nil) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(primaryAction)
        if let secondary = secondaryAction { alert.addAction(secondary) }
        if let tertiary = tertiaryAction { alert.addAction(tertiary) }
        rootController?.present(alert, animated: true, completion: nil)
    }
}

extension UIAlertAction {
    static var OK: UIAlertAction {
        UIAlertAction(title: "OK", style: .cancel, handler: nil)
    }
    
    static var Cancel: UIAlertAction {
        UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
}

var rootController: UIViewController? {
    var root = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
    if let presenter = root?.presentedViewController { root = presenter }
    return root
}

/// Hide keyboard from any view
extension View {
    func hideKeyboard() {
        DispatchQueue.main.async {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
