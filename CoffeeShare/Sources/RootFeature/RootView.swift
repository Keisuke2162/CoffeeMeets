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
import SigninFeature
import SwiftUI
import ComposableArchitecture

@Reducer
public struct Root {
  @ObservableState
  public struct State: Equatable {
    var isLoading = true
    var isLogin = false

    public init() {
    }
  }

  public enum Action {
    case onAppear
    case firebaseCheckLoginResult(Result<Bool, Error>)
  }

  @Dependency(\.firebaseAuthClient) var firebaseAuthClient

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await send(.firebaseCheckLoginResult(Result { try await firebaseAuthClient.getAuthStatus() }))
        }
      case let .firebaseCheckLoginResult(result):
        state.isLoading = false
        switch result {
        case let .success(isLogin):
          state.isLogin = isLogin
          return .none
        case .failure:
          return .none
        }
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
    Group {
      if store.isLoading {
        ProgressView()
      } else if store.isLogin {
        Text("ホーム画面")
      } else {
        SignInView(store: .init(initialState: SignIn.State(), reducer: {
          SignIn()
        }))
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
}

//#Preview {
//  RootView()
//}
