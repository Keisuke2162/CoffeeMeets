//
//  SelectAuthView.swift
//
//
//  Created by Kei on 2024/07/07.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct SelectAuth {
  @ObservableState
  public struct State: Equatable {
    // 画面遷移
    var path = StackState<Path.State>()
  
    public init() {}
  }
  
  public enum Action: BindableAction {
    case onAppear
    case binding(BindingAction<State>)
    case tapSigninButton
    case tapSignupButton
    case path(StackAction<Path.State, Path.Action>)
  }

  public init() {}
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
      case .binding:
        return .none
      case .tapSigninButton:
        state.path.append(.signin)
        return .none
      case .tapSignupButton:
        state.path.append(.signup)
        return .none
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

extension SelectAuth {
  @Reducer(state: .equatable)
  public enum Path {
    case signin
    case signup
  }
}

public struct SelectAuthView: View {
  @Bindable var store: StoreOf<SelectAuth>
  
  public init(store: StoreOf<SelectAuth>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      VStack(spacing: 16) {
        Button {
          store.send(.tapSigninButton)
        } label: {
          Text("ログイン")
        }
        
        Button {
          store.send(.tapSignupButton)
        } label: {
          Text("新規登録")
        }
      }
      .padding(.horizontal, 36)
    } destination: { store in
      switch store.case {
      case .signin:
        Text("Signin")
      case .signup:
        Text("Signup")
      }
    }
  }
}

#Preview {
  SelectAuthView(store: .init(initialState: SelectAuth.State(), reducer: {
    SelectAuth()
  }))
}
