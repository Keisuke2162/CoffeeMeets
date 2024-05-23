//
//  CoffeeList.swift
//
//
//  Created by Kei on 2024/05/22.
//

import APIClient
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

    var isLoading: Bool = false
    var gridType: HomeGridType = .column

    public init() {}
  }

  public enum Action: BindableAction {
    case onAppear
    case tapChangeLayoutButton
    case getCoffeeListResponse(Result<[Coffee], Error>)
    case binding(BindingAction<State>)
    case coffeeItems(IdentifiedActionOf<CoffeeListItem>)
    case path(StackAction<Path.State, Path.Action>)
  }

  @Dependency(\.coffeeAPIClient) var coffeeAPIClient

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.isLoading = true
        return .run { send in
          await send(.getCoffeeListResponse(
            Result {
              try await coffeeAPIClient.getCoffeeList()
            }
          ))
        }
      case .tapChangeLayoutButton:
        switch state.gridType {
        case .list:
          state.gridType = .column
        case .column:
          state.gridType = .list
        }
        return .none
      case let .getCoffeeListResponse(result):
        state.isLoading = false

        switch result {
        case let .success(coffees):
          state.coffeeItems = .init(
            uniqueElements: coffees.map { .init(coffee: $0) }
          )
          return .none
        case .failure:
          return .none
        }
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

extension CoffeeList {
  public enum HomeGridType {
    case list
    case column
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
        if store.isLoading {
          ProgressView()
        } else {
          VStack {
            HStack {
              Spacer()
              Button(action: {
                store.send(.tapChangeLayoutButton)
              }, label: {
                switch store.gridType {
                case .list:
                  Image(systemName: "list.bullet.rectangle.portrait")
                case .column:
                  Image(systemName: "square.grid.2x2")
                }
              })
              .padding(.init(top: 16, leading: 16, bottom: 16, trailing: 32))
            }
            Spacer()
            switch store.gridType {
            case .list:
              List {
                ForEach(store.scope(state: \.coffeeItems, action: \.coffeeItems)) { store in
                  CoffeeListItemView.init(store: store)
                }
              }
            case .column:
              // TODO: 専用のItemViewとReducerを追加してGridViewで表示する
              List {
                ForEach(store.scope(state: \.coffeeItems, action: \.coffeeItems)) { store in
                  CoffeeListItemView.init(store: store)
                }
              }
            }
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

//#Preview {
//  CoffeeListView(
//    store: .init(initialState: CoffeeList.State()) {
//      CoffeeList()
//    } withDependencies: { dependencies in
//      dependencies.coffeeAPIClient.getCoffeeList = { @Sendable _ in
//        (1...50).map { .mock(id: "\($0)") }
//      }
//    }
//  )
//}
