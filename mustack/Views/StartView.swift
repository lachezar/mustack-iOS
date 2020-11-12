//
//  StartView.swift
//  mustack
//
//  Created by Lachezar Yankov on 2020-11-11.
//

import SwiftUI

struct StartView: View {
  
  var body: some View {
    
    NavigationView {
      
      ZStack{
        Color.black.edgesIgnoringSafeArea(.all)
        
        VStack(alignment: .center) {
          
          
          VStack(alignment: .leading, spacing: 20) {
            NavigationLink(destination: MustachifierView(inputMethod: .camera)) {
              HStack{
                Image(systemName: "camera")
                Text("Take a picture")
                  .fontWeight(.semibold)
              }
              .buttonStyle(DefaultButtonStyle())
              .foregroundColor(.green)
              .font(.title)
            }
            
            NavigationLink(destination: MustachifierView(inputMethod: .photoLibrary
            )) {
              HStack{
                Image(systemName: "photo")
                Text("Chose from album")
                  .fontWeight(.semibold)
              }
              .buttonStyle(DefaultButtonStyle())
              .foregroundColor(.yellow)
              .font(.title)
            }
            
            NavigationLink(destination: GalleryView()) {
              HStack{
                Image(systemName: "book")
                Text("History")
                  .fontWeight(.semibold)
              }
              .buttonStyle(DefaultButtonStyle())
              .foregroundColor(.white)
              .font(.title)
            }
          }
          .padding(.top, 100)
          
          Spacer()
          
          Text("Yankov.se")
            .font(.custom("HelveticaNeue-Bold", size: 12))
            .foregroundColor(.white)
            .padding(.bottom, 10)
          
        }
      }
      .accentColor(.white)
    }
  }
}

struct StartView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      StartView()
    }
  }
}
