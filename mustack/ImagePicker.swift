//
//  ImagePicker.swift
//  mustack
//
//  Created by Lachezar Yankov on 2020-11-11.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
  
  private let sourceType: UIImagePickerController.SourceType
  private let onImagePicked: (UIImage) -> Void
  private let onCancel: () -> Void
  
  @Environment(\.presentationMode) private var presentationMode
  
  public init(sourceType: UIImagePickerController.SourceType, onCancel: @escaping () -> Void, onImagePicked: @escaping (UIImage) -> Void) {
    self.sourceType = sourceType
    self.onImagePicked = onImagePicked
    self.onCancel = onCancel
  }
  
  public func makeUIViewController(context: Context) -> UIImagePickerController {
    UINavigationBar.appearance().tintColor = .systemBlue
    let picker = UIImagePickerController()
    picker.sourceType = self.sourceType
    picker.delegate = context.coordinator
    return picker
  }
  
  public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    Coordinator(
      onCancel: self.onCancel,
      onDismiss: { self.presentationMode.wrappedValue.dismiss() },
      onImagePicked: self.onImagePicked
    )
  }
  
  final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private let onCancel: () -> Void
    private let onDismiss: () -> Void
    private let onImagePicked: (UIImage) -> Void
    
    init(onCancel: @escaping () -> Void, onDismiss: @escaping () -> Void, onImagePicked: @escaping (UIImage) -> Void) {
      self.onCancel = onCancel
      self.onDismiss = onDismiss
      self.onImagePicked = onImagePicked
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      if let image = info[.originalImage] as? UIImage {
        self.onImagePicked(image)
      } else {
        self.onCancel()
      }
      self.onDismiss()
    }
    
    public func imagePickerControllerDidCancel(_: UIImagePickerController) {
      self.onCancel()
      self.onDismiss()
    }
  }
}
