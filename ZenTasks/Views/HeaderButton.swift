//
//  HeaderButton.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/15/22.
//

import SwiftUI

/// Custom button for section header
struct HeaderButton: View {
    
    let title: String
    @State var image: String?
    let action: () -> Void
    
    // MARK: - Main rendering function
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 5) {
                if let imageName = image {
                    Image(systemName: imageName).font(.system(size: 14))
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 33).padding(.vertical, 7)
            .background(Color.customBlue.cornerRadius(20))
        }
    }
}

// MARK: - Preview UI
struct HeaderButton_Previews: PreviewProvider {
    static var previews: some View {
        HeaderButton(title: "Add",image: "plus") { }
    }
}
