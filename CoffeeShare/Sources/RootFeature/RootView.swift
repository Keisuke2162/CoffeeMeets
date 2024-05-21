//
//  RootView.swift
//
//
//  Created by Kei on 2024/05/22.
//

import Foundation
import SwiftUI

public struct RootView: View {
  public var body: some View {
    TabView {
      Text("1")
        .tabItem {
          Label("Home", systemImage: "house")
        }
        .tag(1)
      Text("2")
        .tabItem {
          Label("Search", systemImage: "magnifyingglass")
        }
        .tag(2)
      Text("3")
        .tabItem {
          Label("Announce", systemImage: "envelope")
        }
        .tag(3)
      Text("4")
        .tabItem {
          Label("My Page", systemImage: "person")
        }
        .tag(4)
    }
  }
}

#Preview {
  RootView()
}
