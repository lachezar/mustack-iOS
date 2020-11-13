//
//  mustackApp.swift
//  mustack
//
//  Created by Lachezar Yankov on 2020-11-11.
//

import SwiftUI
import UIKit

@main
struct MustackApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      StartView()
    }
  }
}
