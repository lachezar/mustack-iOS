//
//  PhotoView.swift
//  mustack
//
//  Created by Lachezar Yankov on 2020-11-12.
//

import SwiftUI

struct PhotoView: View {
  
  @State var prompt = false
  
  var image: UIImage
  var url: URL
  var modelView: GalleryModelView
  
  var body: some View {
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
            self.modelView.imageUrls = ImageOperations.listImages()
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

struct PhotoView_Previews: PreviewProvider {
  static var previews: some View {
    PhotoView(image: UIImage(systemName: "book")!, url: URL(string: "file///")!, modelView: GalleryModelView())
  }
}
