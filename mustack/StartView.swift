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
                Image(systemName: "photo")
                Text("Take a picture")
                  .fontWeight(.semibold)
                
              }
              .buttonStyle(DefaultButtonStyle())
              .foregroundColor(.green)
              .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
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
              .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
            
            Button(action: {
              print("pressed button 3")
            }){
              HStack{
                Image(systemName: "book")
                Text("History")
                  .fontWeight(.semibold)
              }
              .foregroundColor(.white)
              .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
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
