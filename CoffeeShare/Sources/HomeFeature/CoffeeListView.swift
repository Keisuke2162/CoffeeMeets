//
//  CoffeeListView.swift
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

    public init() {}
  }

  public enum Action: BindableAction {
    case onAppear
    case tapFilterButton
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
      case .tapFilterButton:
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
      case let .coffeeItems(.element(id, .delegate(.tapItem))):
        guard let item = state.coffeeItems[id: id]?.coffee else {
          return .none
        }
        state.path.append(.coffeeDetail(.init(coffee: item)))
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
  @Namespace private var nameSpace
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
                // store.send(.tapChangeLayoutButton)
              }, label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
              })
              .padding(.init(top: 16, leading: 16, bottom: 16, trailing: 32))
            }
            Spacer()
            List {
              ForEach(store.scope(state: \.coffeeItems, action: \.coffeeItems)) { store in
                if #available(iOS 18.0, *) {
                  CoffeeListItemView.init(store: store)
                    .navigationTransition(.zoom(sourceID: store.state.coffee.id, in: nameSpace))
                    .listRowSeparator(.hidden)
                } else {
                  // Fallback on earlier versions
                  CoffeeListItemView.init(store: store)
                    .listRowSeparator(.hidden)
                }
              }
            }
            .listStyle(PlainListStyle())
          }
        }
      }
      .onAppear {
        store.send(.onAppear)
      }
    } destination: { store in
      switch store.case {
      case let .coffeeDetail(store):
        if #available(iOS 18.0, *) {
          CoffeeDetailView(store: store)
            .matchedTransitionSource(id: store.state.coffee.id, in: nameSpace)
        } else {
          CoffeeDetailView(store: store)
        }
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
