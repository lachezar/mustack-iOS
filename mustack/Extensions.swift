//
//  Extensions.swift
//  mustack
//
//  Created by Lachezar Yankov on 2020-11-12.
//

import UIKit

// borrowed from https://stackoverflow.com/a/47402811/488035
extension UIImage {
  func rotate(radians: Float) -> UIImage? {
    var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
    // Trim off the extremely small float value to prevent core graphics from rounding it up
    newSize.width = floor(newSize.width)
    newSize.height = floor(newSize.height)
    
    var newImage: UIImage?
    
    autoreleasepool {
      UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
      let context = UIGraphicsGetCurrentContext()!
      
      // Move origin to middle
      context.translateBy(x: newSize.width/2, y: newSize.height/2)
      // Rotate around middle
      context.rotate(by: CGFloat(radians))
      // Draw the image at its center
      self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
      
      newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
    }
    
    return newImage
  }
  
  // borrowed from https://stackoverflow.com/a/45635306/488035
  func resized(to size: CGSize) -> UIImage {
    return UIGraphicsImageRenderer(size: size).image { _ in
      draw(in: CGRect(origin: .zero, size: size))
    }
  }
  
  func resized(maxHeight: CGFloat) -> UIImage {
    if self.size.height <= maxHeight {
      return self
    } else {
      let k = self.size.height / maxHeight
      let size = CGSize(width: self.size.width / k, height: self.size.height / k)
      return UIGraphicsImageRenderer(size: size).image { _ in
        draw(in: CGRect(origin: .zero, size: size))
      }
    }
  }
  
  func resized(maxSide: CGFloat) -> UIImage {
    let maxS = max(self.size.width, self.size.height)
    if maxS <= maxSide {
      return self
    } else {
      let k = maxS / maxSide
      let size = CGSize(width: self.size.width / k, height: self.size.height / k)
      let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

      var newImage: UIImage!
      
      autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: rect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
      }
        
      return newImage
    }
  }
  
}
