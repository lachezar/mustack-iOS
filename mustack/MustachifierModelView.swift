//
//  MustachifierModelView.swift
//  mustack
//
//  Created by Lachezar Yankov on 2020-11-12.
//

import Combine
import UIKit

class MustachifierModelView: ObservableObject {
  
  @Published var showImagePicker: Bool = false
  @Published var image: UIImage? {
    willSet {
      if newValue != nil {
        isError = false
      }
    }
  }
  @Published var isError: Bool = false
  
  let mustacheImage: UIImage = UIImage(named: "Mustache")!
  let goldenMustacheImage: UIImage = UIImage(named: "GoldenMustache")!
  
  func emptyScreen() -> Bool {
    return image == nil && showImagePicker == .none
  }
  
  func markError() {
    self.image = nil
    self.isError = true
  }
}
