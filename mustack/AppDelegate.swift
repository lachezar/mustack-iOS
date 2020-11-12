//
//  AppDelegate.swift
//  mustack
//
//  Created by Lachezar Yankov on 2020-11-12.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    let navigationBarAppearance = UINavigationBarAppearance()
    navigationBarAppearance.configureWithOpaqueBackground()
    navigationBarAppearance.backgroundColor = UIColor.black
    navigationBarAppearance.shadowColor = .clear
    navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    
    UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    UINavigationBar.appearance().tintColor = .white
    
    
    return true
  }
}
