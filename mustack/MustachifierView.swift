//
//  ImagePickerView.swift
//  mustack
//
//  Created by Lachezar Yankov on 2020-11-11.
//

import SwiftUI
import Vision
import Combine

struct MustachifierView: View {
  
  @ObservedObject var viewModel = MustachifierModelView()
  
  @Environment(\.presentationMode) var presentation
  
  let sourceType: UIImagePickerController.SourceType
  
  init(inputMethod: UIImagePickerController.SourceType) {
    self.sourceType = inputMethod
  }
  
  func configure() {
    self.viewModel.showImagePicker = true
    self.viewModel.image = nil
    self.viewModel.isError = false
  }
  
  var body: some View {
    
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all)
      
      VStack {
        if let image = self.viewModel.image {
          Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
        } else if self.viewModel.isError {
          Text("The image could not be mustachified :{(")
            .fontWeight(.bold)
            .font(.title)
            .foregroundColor(.yellow)
        }
        
        Spacer()
        
        if !self.viewModel.showImagePicker {
          HStack {
            Spacer()
            
            if self.viewModel.image != nil {
              Button("Save") {
                self.viewModel.showImagePicker.toggle()
              }
              .foregroundColor(.white)
            }
            
            Spacer()
            
            Button("Pick new image") {
              self.viewModel.showImagePicker.toggle()
            }
            .foregroundColor(.white)
            
            Spacer()
            
            if self.viewModel.image != nil {
              Button("Share") {
                self.viewModel.showImagePicker.toggle()
              }
              .foregroundColor(.white)
            }
            
            Spacer()
          }.padding(.bottom, 20)
        }
      }
      .onAppear {
        configure()
      }
      .sheet(isPresented: $viewModel.showImagePicker) {
        ImagePicker(sourceType: self.sourceType,
                    onCancel: { self.presentation.wrappedValue.dismiss() }
        ) { image in
          do {
            try Mustachifier.mustachify(image: image) { newImageMaybe in
              if let newImage = newImageMaybe {
                self.viewModel.image = newImage
              } else {
                self.viewModel.markError()
              }
            }
          } catch {
            self.viewModel.markError()
            print(error.localizedDescription)
          }
        }
      }
    }
  }
}

struct ImagePickerView_Previews: PreviewProvider {
  static var previews: some View {
    MustachifierView(inputMethod: .photoLibrary)
  }
}
