//
//  GalleryView.swift
//  mustack
//
//  Created by Lachezar Yankov on 2020-11-12.
//

import SwiftUI

struct GalleryView: View {
  
  @ObservedObject var modelView = GalleryModelView()
  
  let columns = [
    GridItem(.flexible(minimum: 100, maximum: 400), alignment: .center),
    GridItem(.flexible(minimum: 100, maximum: 400), alignment: .center),
    GridItem(.flexible(minimum: 100, maximum: 400), alignment: .center)
  ]
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, alignment: .center) {
        ForEach(self.modelView.imageUrls, id: \.self) { url in
          if let image = ImageOperations.readImage(url: url) {
            NavigationLink(destination: PhotoView(image: image, url: url, modelView: self.modelView)) {
              // fill the grid with thumb images, otherwise we run out of memory
              // GeometryReader was not letting the ScrollView to scroll to the bottom,
              // so I had to use UIScreen
              Image(uiImage: image.resized(maxHeight: 100))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: (UIScreen.main.bounds.size.width / 3 - 10).rounded(), height: (UIScreen.main.bounds.size.width / 3 - 10).rounded())
            }
          }
        }
        .border(Color.yellow, width: 1)
      }
      .onAppear( perform: self.configure )
    }
  }
  
  func configure() {
    DispatchQueue.global(qos: .userInitiated).async {
      let imageUrls = ImageOperations.listImages()
      let sortedUrls = imageUrls.sorted(by: { $0.absoluteString > $1.absoluteString })
      DispatchQueue.main.async {
        self.modelView.imageUrls = sortedUrls
      }
    }
  }
}

struct GalleryView_Previews: PreviewProvider {
  static var previews: some View {
    GalleryView()
  }
}
