//
//  CofeeDetail.swift
//
//
//  Created by Kei on 2024/05/23.
//

import ComposableArchitecture
import Entity
import Foundation
import SwiftUI
import IdentifiedCollections

@Reducer
public struct CoffeeDetail {
  @ObservableState
  public struct State: Equatable {
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

public struct CoffeeDetailView: View {
  @Bindable var store: StoreOf<CoffeeDetail>
  
  public init(store: StoreOf<CoffeeDetail>) {
    self.store = store
  }

  public var body: some View {
    Text("B")
  }
}
