//
//  AppView.swift
//
//
//  Created by Kei on 2024/05/21.
//

import ComposableArchitecture
import Foundation
import SwiftUI

public struct AppView: View {

  public init() {}

  public var body: some View {
    VStack {
        Image(systemName: "globe")
            .imageScale(.large)
            .foregroundStyle(.tint)
        Text("Hello, world!")
    }
    .padding()
  }
}

#Preview {
  AppView()
}
