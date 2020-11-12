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
    self.viewModel.saveProgress = .none
  }
  
  var body: some View {
    
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all)
      
      // image or spinner
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
        } else if self.viewModel.showSpinner {
          Spacer()
          ProgressView()
            .scaleEffect(2, anchor: .center)
        }
        
        Spacer()
        
        // bottom buttons
        if !self.viewModel.showImagePicker {
          HStack {
            Spacer()
            
            // save image button
            if let image = self.viewModel.image {
              Button(action: {
                if let url = ImageOperations.generateName() {
                  self.viewModel.saveProgress = .ongoing
                  DispatchQueue.global(qos: .userInitiated).async {
                    if ImageOperations.saveImage(image: image, url: url) {
                      DispatchQueue.main.async {
                        self.viewModel.saveProgress = .completed
                      }
                    }
                  }
                }
              }) {
                switch self.viewModel.saveProgress {
                case .none:
                  HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("Save")
                  }
                case .ongoing:
                  ProgressView()
                case .completed:
                  Text("👍")
                }
              }.foregroundColor(.white)
            }
            
            Spacer()
            
            Button("Pick new image") {
              self.viewModel.showImagePicker.toggle()
            }
            .foregroundColor(.white)
            
            Spacer()
            
            // share image button
            if let image = self.viewModel.image {
              Button(action: { ImageOperations.share(image: image) }) {
                HStack {
                  Image(systemName: "square.and.arrow.up")
                  Text("Share")
                }
              }.foregroundColor(.white) 
            }
            
            Spacer()
          }
          .padding(.bottom, 20)
        }
      }
      .onAppear {
        configure()
      }
      .sheet(isPresented: $viewModel.showImagePicker) {
        self.viewModel.pickImage(
          sourceType: self.sourceType,
          onCancel: { self.presentation.wrappedValue.dismiss() })
      }
    }
  }
}

struct ImagePickerView_Previews: PreviewProvider {
  static var previews: some View {
    MustachifierView(inputMethod: .photoLibrary)
  }
}
