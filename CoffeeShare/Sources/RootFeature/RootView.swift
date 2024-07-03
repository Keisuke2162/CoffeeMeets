//
//  RootView.swift
//
//
//  Created by Kei on 2024/05/22.
//

import Foundation
import FirebaseAuth
import FirebaseClient
import HomeFeature
import SettingFeature
import SwiftUI
import ComposableArchitecture

@Reducer
public struct Root {
  @ObservableState
  public struct State: Equatable {

    public init() {
    }
  }

  public enum Action {
    case onAppear
  }

  @Dependency(\.firebaseAuthClient) var firebaseAuthClient

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
      }
    }
  }
}

public struct RootView: View {
  let store: StoreOf<Root>
  
  public init(store: StoreOf<Root>) {
    self.store = store
  }

  public var body: some View {
    Text("")
  }
}

//#Preview {
//  RootView()
//}
