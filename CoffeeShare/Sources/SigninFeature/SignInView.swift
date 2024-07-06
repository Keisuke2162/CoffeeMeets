//
//  SignInView.swift
//
//
//  Created by Kei on 2024/06/30.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct SignIn {
  @ObservableState
  public struct State: Equatable {
    var emailAddress: String = ""
    var password: String = ""
    var isEnableSigninButton: Bool {
      return !emailAddress.isEmpty && !password.isEmpty
    }

    public init() {}
  }
  
  public enum Action: BindableAction {
    case onAppear
    case binding(BindingAction<State>)
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
      }
    }
  }
}

public struct SignInView: View {
  @Bindable var store: StoreOf<SignIn>
  
  public init(store: StoreOf<SignIn>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 16) {
      TextField("Email", text: $store.emailAddress)
      SecureField(text: $store.password) {
        Text("password")
      }
      Button {
        
      } label: {
        Text("ログイン")
      }
      .disabled(!store.isEnableSigninButton)
    }
    .padding(.horizontal, 36)
  }
}

#Preview {
  SignInView(store: .init(initialState: SignIn.State(), reducer: {
    SignIn()
  }))
}
