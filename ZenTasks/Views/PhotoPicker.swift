//
//  PhotoPicker.swift
//  ZenTasks
//
//  Created by Booysenberry on 7/17/22.
//

import SwiftUI
import PhotosUI

/// Photo picker view to select photos from the library
struct PhotoPicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    let didSelect: (_ image: UIImage?) -> Void
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.selectionLimit = 1
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<PhotoPicker>) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker
        var isProcessing: Bool = false
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            for result in results {
                self.loadImage(fromResult: result) { selectedImage in
                    DispatchQueue.main.async {
                        self.parent.didSelect(selectedImage)
                        picker.dismiss(animated: true, completion: nil)
                    }
                }
            }
            if results.count == 0 {
                picker.dismiss(animated: true, completion: nil)
            }
        }
        
        /// Load image from selected gallery asset
        private func loadImage(fromResult result: PHPickerResult, completion: @escaping (_ image: UIImage?) -> Void) {
            let identifier = result.itemProvider.registeredTypeIdentifiers.first ?? UTType.png.identifier
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: identifier) { url, _ in
                guard let imageURL = url, let imageData = try? Data(contentsOf: imageURL) else {
                    completion(nil)
                    return
                }
                if let image = UIImage(data: imageData), let id = result.assetIdentifier {
                    image.accessibilityIdentifier = id.replacingOccurrences(of: "/", with: "_")
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
