//
//  HomeView.swift
//
//
//  Created by Kei on 2024/05/22.
//

import Foundation
import SwiftUI

public struct HomeView: View {
  public init() {}

  public var body: some View {
    CoffeeListView(store: .init(initialState: CoffeeList.State(), reducer: {
      CoffeeList()
    }))
  }
}
