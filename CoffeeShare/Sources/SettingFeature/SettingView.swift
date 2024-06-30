//
//  SettingView.swift
//
//
//  Created by Kei on 2024/06/29.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct Setting {
  @ObservableState
  public struct State: Equatable {
    public init() {
    }
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

extension Setting {
  @Reducer(state: .equatable)
  public enum Path {
    case profile
    case aboutApp
    case privacyPolicy
  }
}

public struct SettingView: View {
  @Bindable var store: StoreOf<Setting>
  
  public init(store: StoreOf<Setting>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack {
      List {
        Section("アカウント") {
          Text("プロフィール")
        }
        Section("アプリ情報") {
          Text("利用規約")
          Text("プライバシーポリシー")
          Text("このアプリについて")
        }
      }
    }
  }
}

#Preview {
  SettingView(store: .init(initialState: Setting.State(), reducer: {
    Setting()
  }))
}
