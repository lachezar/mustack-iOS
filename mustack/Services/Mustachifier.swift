//
//  Mustachifier.swift
//  mustack
//
//  Created by Lachezar Yankov on 2020-11-12.
//

import UIKit
import Vision

final class Mustachifier {

  typealias Chance = Int
  typealias Mustaches = [(UIImage, Chance)]

  var image: UIImage
  var successCallback: (UIImage) -> Void
  var errorCallback: (Error?) -> Void

  let mustaches: Mustaches = [
    (UIImage(named: "Mustache")!, 95),
    (UIImage(named: "GoldenMustache")!, 5)
  ]

  static func mustachify(image: UIImage, errorCallback: @escaping (Error?) -> Void, successCallback: @escaping (UIImage?) -> Void) -> Void {
    let _ = Mustachifier(image: image, errorCallback: errorCallback, successCallback: successCallback)
  }

  private init(image: UIImage, errorCallback: @escaping (Error?) -> Void, successCallback: @escaping (UIImage) -> Void) {
    self.image = image
    self.errorCallback = errorCallback
    self.successCallback = successCallback

    if let cgImage = image.cgImage {
      let requestHandler = VNImageRequestHandler(cgImage: cgImage)
      let detectFaceRequest = VNDetectFaceLandmarksRequest(completionHandler: detectedFace)
      do {
        try requestHandler.perform([detectFaceRequest])
      } catch {
        print(error.localizedDescription)
        self.errorCallback(error)
      }
    }
  }

  func detectedFace(request: VNRequest, error: Error?) {

    guard
      let results = request.results as? [VNFaceObservation],
      let mustache = type(of: self).chooseMustache(self.mustaches)
    else {
      self.errorCallback(nil)
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
            self.errorCallback(nil)
            return
          }

          let mustacheWidth = maxX.x - minX.x
          let newSize = CGSize(width: bottomImage.size.width, height: bottomImage.size.height)

          autoreleasepool {

            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)

            let _ = UIGraphicsGetCurrentContext()

            bottomImage.draw(in: CGRect(origin: .zero, size: newSize))

            let mustacheHeight = 2 * abs(maxX.y - minX.y)
            let angle = atan((minX.y - maxX.y) / (maxX.x - minX.x))
            let tiltedMustache = mustache.rotate(radians: Float(angle))
            let tiltCorrectionX = mustacheWidth - cos(angle)*mustacheWidth
            let tiltCorrectionY = cos(angle) * mustacheHeight / 2

            tiltedMustache?.draw(in: CGRect(origin: CGPoint(x: minX.x - 20 - tiltCorrectionX, y: bottomImage.size.height - bottomNosePoint.y - tiltCorrectionY), size: CGSize(width: mustacheWidth + 40, height: max(bottomNosePoint.y - topPoint.y + 20, mustacheHeight))))

            resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
          }

        }
      }
    }
    if let newImage = resultImage {
      return self.successCallback(newImage)
    } else {
      return self.errorCallback(nil)
    }
  }

  static func chooseMustache(_ mustaches: Mustaches) -> UIImage? {
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
