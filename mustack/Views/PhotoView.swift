//
//  PhotoView.swift
//  mustack
//
//  Created by Lachezar Yankov on 2020-11-12.
//

import SwiftUI

struct PhotoView: View {

  @State var prompt = false

  let url: URL
  let modelView: GalleryModelView

  var body: some View {
    if let image = ImageOperations.readImage(url: self.url) {
      VStack {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)

        Spacer()

        HStack{

          Spacer()

          // delete image button
          Button(action: { self.prompt = true }, label: {
            Image(systemName: "trash")
            Text("Delete")
          }).alert(isPresented: self.$prompt) {
            let deleteButton = Alert.Button.destructive(Text("Delete")) {
              let _ = ImageOperations.deleteImage(url: url)
              self.modelView.imageUrls = ImageOperations.listThumbImages()
            }
            let cancelButton = Alert.Button.cancel()
            return Alert(title: Text("Are you sure?"), primaryButton: cancelButton, secondaryButton: deleteButton)
          }
          .foregroundColor(.red)

          Spacer()

          // share image button
          Button(action: {ImageOperations.share(image: image)}) {
            HStack {
              Image(systemName: "square.and.arrow.up")
              Text("Share")
            }
          }.foregroundColor(.white)

          Spacer()
        }
      }
    }
  }
}

struct PhotoView_Previews: PreviewProvider {
  static var previews: some View {
    PhotoView(url: URL(string: "file///")!, modelView: GalleryModelView())
  }
}
