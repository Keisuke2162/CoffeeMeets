//
//  CoffeeList.swift
//
//
//  Created by Kei on 2024/05/22.
//

import CasePaths
import ComposableArchitecture
import Entity
import Foundation
import SwiftUI
import IdentifiedCollections

@Reducer
public struct CoffeeList {
  @ObservableState
  public struct State: Equatable {
    // 一覧の表示
    var coffeeItems: IdentifiedArrayOf<CoffeeListItem.State> = []
    // 画面遷移の実装
    var path = StackState<Path.State>()

    public init() {}
  }

  public enum Action: BindableAction {
    case onAppear
    case binding(BindingAction<State>)
    case coffeeItems(IdentifiedActionOf<CoffeeListItem>)
    case path(StackAction<Path.State, Path.Action>)
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.coffeeItems = [.init(coffee: Coffee.mock(id: "1"))]
        return .none
      case .binding:
        return .none
      case .coffeeItems:
        return .none
      case .path:
        return .none
      }
    }
    .forEach(\.coffeeItems, action: \.coffeeItems) {
      CoffeeListItem()
    }
    .forEach(\.path, action: \.path)
  }
}

extension CoffeeList {
  @Reducer(state: .equatable)
  public enum Path {
    case coffeeDetail(CoffeeDetail)
  }
}


public struct CoffeeListView: View {
  @Bindable var store: StoreOf<CoffeeList>

  public init(store: StoreOf<CoffeeList>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      Group {
        List {
          ForEach(store.scope(state: \.coffeeItems, action: \.coffeeItems)) { store in
            CoffeeListItemView.init(store: store)
          }
        }
      }
      .onAppear {
        store.send(.onAppear)
      }
    } destination: { store in
      switch store.case {
      case let .coffeeDetail(store):
        CoffeeDetailView(store: store)
      }
    }
  }
}

#Preview {
  CoffeeListView(
    store: .init(initialState: CoffeeList.State()) {
      CoffeeList()
    }
  )
}
