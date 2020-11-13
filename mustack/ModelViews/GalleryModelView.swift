//
//  GalleryModelView.swift
//  mustack
//
//  Created by Lachezar Yankov on 2020-11-12.
//

import Combine
import UIKit

final class GalleryModelView: ObservableObject {

  @Published var imageUrls: [URL] = []
}
