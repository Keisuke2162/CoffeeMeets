//
//  CoffeeMeetsApp.swift
//  CoffeeMeets
//
//  Created by Kei on 2024/05/21.
//

import RootFeature
import SwiftUI
import FirebaseAuth
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct CoffeeMeetsApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
          RootView(store: .init(initialState: Root.State(), reducer: {
            Root()
          }))
        }
    }
}
