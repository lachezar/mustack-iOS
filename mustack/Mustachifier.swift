//
//  Mustachifier.swift
//  mustack
//
//  Created by Lachezar Yankov on 2020-11-12.
//

import UIKit
import Vision

class Mustachifier {
  
  typealias Chance = Int
  typealias Mustaches = [(UIImage, Chance)]
  
  var image: UIImage
  var callback: (UIImage?) -> Void
  
  let mustaches: Mustaches = [
    (UIImage(named: "Mustache")!, 95),
    (UIImage(named: "GoldenMustache")!, 5)
  ]
  
  static func mustachify(image: UIImage, callback: @escaping (UIImage?) -> Void) throws -> Void {
    do {
      let _ = try Mustachifier(image: image, callback: callback)
    } catch {
      throw error
    }
  }
  
  private init(image: UIImage, callback: @escaping (UIImage?) -> Void) throws {
    self.image = image
    self.callback = callback
    if let cgImage = image.cgImage {
      let requestHandler = VNImageRequestHandler(cgImage: cgImage)
      let detectFaceRequest = VNDetectFaceLandmarksRequest(completionHandler: detectedFace)
      do {
        try requestHandler.perform([detectFaceRequest])
      } catch {
        print(error.localizedDescription)
        throw error
      }
    }
  }
  
  func detectedFace(request: VNRequest, error: Error?) {
    
    guard
      let results = request.results as? [VNFaceObservation],
      let mustache = chooseMustache(self.mustaches)
    else {
      callback(nil)
      return
    }
    
    var resultImage: UIImage? = results.count == 0 ? nil : self.image
    
    for result in results {
      
      if let landmarks = result.landmarks, let bottomImage = resultImage {
        let size = CGSize(width: bottomImage.size.width, height: bottomImage.size.height)
        if let mouthPoints = landmarks.outerLips?.pointsInImage(imageSize: size),
           let nosePoints = landmarks.nose?.pointsInImage(imageSize: size) {
          
          guard
            let maxX = mouthPoints.max(by: { $0.x < $1.x }),
            let minX = mouthPoints.min(by: { $0.x < $1.x }),
            let topPoint = mouthPoints.max(by: { $0.y < $1.y }),
            let bottomNosePoint = nosePoints.min(by: { $0.y < $1.y })
          else {
            callback(nil)
            return
          }
          
          let mustacheWidth = maxX.x - minX.x
          let newSize = CGSize(width: bottomImage.size.width, height: bottomImage.size.height)
          
          UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
          
          let _ = UIGraphicsGetCurrentContext()
          
          bottomImage.draw(in: CGRect(origin: .zero, size: newSize))
          
          //context?.rotate(by: 0.1)
          let mustacheHeight = 2 * abs(maxX.y - minX.y)
          let angle = atan((minX.y - maxX.y) / (maxX.x - minX.x))
          let tiltedMustache = mustache.rotate(radians: Float(angle))
          
          
          tiltedMustache?.draw(in: CGRect(origin: CGPoint(x: minX.x - 20, y: bottomImage.size.height - bottomNosePoint.y - 10), size: CGSize(width: mustacheWidth + 40, height: max(bottomNosePoint.y - topPoint.y + 20, mustacheHeight))))
          //          print(CGPoint(x: minX.x - 20, y: topPoint.y - 20))
          //          print(CGSize(width: mustacheWidth + 40, height: (mustacheWidth + 40) / 2))
          
          
          
          resultImage = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          
        }
      }
    }
    callback(resultImage)
  }
  
  func chooseMustache(_ mustaches: Mustaches) -> UIImage? {
    var n = Int.random(in: 1..<101)
    for (mustache, chance) in mustaches {
      if n <= chance {
        return mustache
      } else {
        n -= chance
      }
    }
    return mustaches.last?.0
  }
}

// borrowed from https://stackoverflow.com/a/47402811/488035
extension UIImage {
  func rotate(radians: Float) -> UIImage? {
    var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
    // Trim off the extremely small float value to prevent core graphics from rounding it up
    newSize.width = floor(newSize.width)
    newSize.height = floor(newSize.height)
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
    let context = UIGraphicsGetCurrentContext()!
    
    // Move origin to middle
    context.translateBy(x: newSize.width/2, y: newSize.height/2)
    // Rotate around middle
    context.rotate(by: CGFloat(radians))
    // Draw the image at its center
    self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
  }
}
