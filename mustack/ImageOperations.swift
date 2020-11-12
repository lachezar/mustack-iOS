//
//  ImageOperations.swift
//  mustack
//
//  Created by Lachezar Yankov on 2020-11-12.
//

import UIKit

final class ImageOperations {
  
  static func generateName() -> URL? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
    let filename = dateFormatter.string(from: Date()) + ".jpg"

    let fileManager = FileManager.default
    do {
      let url = try fileManager
        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent(filename)
      return url
    } catch {
      return nil
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
      print(fileURLs)
      return fileURLs
    } catch {
      print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
    }
    return []
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
  
  static func share(image: UIImage) {
    let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
  }
}
