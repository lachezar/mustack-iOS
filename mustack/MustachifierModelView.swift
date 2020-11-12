//
//  MustachifierModelView.swift
//  mustack
//
//  Created by Lachezar Yankov on 2020-11-12.
//

import Combine
import UIKit

final class MustachifierModelView: ObservableObject {
  
  enum SaveProgress {
    case none
    case ongoing
    case completed
  }
  
  @Published var showImagePicker: Bool = false {
    willSet {
      self.saveProgress = .none
    }
  }
  @Published var image: UIImage? {
    willSet {
      if newValue != nil {
        isError = false
      }
    }
  }
  @Published var isError: Bool = false
  @Published var showSpinner: Bool = false {
    willSet {
      if newValue {
        self.isError = false
        self.image = nil
      }
    }
  }
  @Published var saveProgress: SaveProgress = .none
  
  let mustacheImage: UIImage = UIImage(named: "Mustache")!
  let goldenMustacheImage: UIImage = UIImage(named: "GoldenMustache")!
  
  func pickImage(sourceType: UIImagePickerController.SourceType, onCancel: @escaping () -> Void) -> ImagePicker {
    return ImagePicker(sourceType: sourceType, onCancel: onCancel) { image in
      self.showSpinner = true
      DispatchQueue.global(qos: .userInitiated).async {
        Mustachifier.mustachify(
          image: image,
          errorCallback: { error in
            DispatchQueue.main.async {
              self.markError()
              print(error?.localizedDescription ?? "")
            }
          }) { newImage in
          DispatchQueue.main.async {
            self.image = newImage
          }
        }
      }
    }
  }
    
  func emptyScreen() -> Bool {
    return image == nil && showImagePicker == .none
  }
  
  func markError() {
    self.image = nil
    self.isError = true
    self.showSpinner = false
  }
}
