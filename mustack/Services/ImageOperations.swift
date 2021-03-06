//
//  ImageOperations.swift
//  mustack
//
//  Created by Lachezar Yankov on 2020-11-12.
//

import UIKit

final class ImageOperations {

  typealias ImageNames = (thumb: URL, normal: URL)

  static let thumbPostFix = "_thumb.jpg"
  static let normalPostFix = ".jpg"

  static func generateName() -> ImageNames? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
    let filename = dateFormatter.string(from: Date()) + normalPostFix
    let thumbFilename = dateFormatter.string(from: Date()) + thumbPostFix

    let fileManager = FileManager.default
    do {
      let url = try fileManager
        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent(filename)
      let thumbUrl = try fileManager
        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent(thumbFilename)
      return (thumb: thumbUrl, normal: url)
    } catch {
      return nil
    }
  }

  static func normalUrl(from: URL) -> URL? {
    URL(string: from.absoluteString.replacingOccurrences(of: thumbPostFix, with: normalPostFix))
  }

  static func thumbUrl(from: URL) -> URL? {
    if from.absoluteString.contains(thumbPostFix) {
      return from
    } else {
      return URL(string: from.absoluteString.replacingOccurrences(of: normalPostFix, with: thumbPostFix))
    }
  }

  static func saveImage(image: UIImage, url: URL) -> Bool {
    if let imageBlob = image.jpegData(compressionQuality: 1.0) {
      do {
        try imageBlob.write(to: url, options: .atomic)
        return true
      } catch {
        return false
      }
    } else {
      return false
    }
  }

  static func listImages() -> [URL] {
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    do {
      let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
      return fileURLs
    } catch {
      print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
    }
    return []
  }

  static func listThumbImages() -> [URL] {
    return listImages().filter({ url in url.absoluteString.contains("_thumb")})
  }

  static func readImage(url: URL) -> UIImage? {
    return UIImage(contentsOfFile: url.path)
  }

  static func deleteImage(url: URL) -> Bool {
    let fileManager = FileManager.default
    do {
      try fileManager.removeItem(at: url)
      return true
    } catch {
      return false
    }
  }

  static func deleteImageAndThumb(normalUrl: URL) -> Bool {
    let result = deleteImage(url: normalUrl)

    if let thumbUrl = thumbUrl(from: normalUrl) {
      return result && deleteImage(url: thumbUrl)
    } else {
      return false
    }
  }

  static func deleteAll() -> Void {
    let urls = listImages()
    urls.forEach { url in let _ = deleteImage(url: url) }
  }

  static func share(image: UIImage) {
    let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
  }
}
