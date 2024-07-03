//
//  MainTabView.swift
//
//
//  Created by Kei on 2024/06/30.
//

import Foundation
import HomeFeature
import SettingFeature
import SwiftUI

public struct MainTabView: View {
  public init() {}
  public var body: some View {
    TabView {
      HomeView()
        .tabItem {
          Label("Home", systemImage: "house")
        }
        .tag(1)
      Text("2")
        .tabItem {
          Label("Search", systemImage: "magnifyingglass")
        }
        .tag(2)
      SettingView(store: .init(initialState: Setting.State(), reducer: {
        Setting()
      }))
        .tabItem {
          Label("My Page", systemImage: "person")
        }
        .tag(3)
    }
  }
}

#Preview {
  MainTabView()
}
