//
//  PostListView.swift
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
public struct PostList {
  @ObservableState
  public struct State: Equatable {
    // 一覧の表示
    var postItems: IdentifiedArrayOf<PostListItem.State> = []
    // 画面遷移の実装
    var path = StackState<Path.State>()

    var isLoading: Bool = false

    public init() {}
  }

  public enum Action: BindableAction {
    case onAppear
    case tapFilterButton
    case getPostListResponse(Result<[PostItem], Error>)
    case binding(BindingAction<State>)
    case postItems(IdentifiedActionOf<PostListItem>)
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
          await send(.getPostListResponse(
            Result {
              try await coffeeAPIClient.getCoffeeList()
            }
          ))
        }
      case .tapFilterButton:
        return .none
      case let .getPostListResponse(result):
        state.isLoading = false

        switch result {
        case let .success(items):
          state.postItems = .init(
            uniqueElements: items.map { .init(postItem: $0) }
          )
          return .none
        case .failure:
          return .none
        }
      case .binding:
        return .none
      case let .postItems(.element(id, .delegate(.tapItem))):
        guard let item = state.postItems[id: id]?.postItem else {
          return .none
        }
        state.path.append(.postDetail(.init(postItem: item)))
        return .none
      case .postItems:
        return .none
      case .path:
        return .none
      }
    }
    .forEach(\.postItems, action: \.postItems) {
      PostListItem()
    }
    .forEach(\.path, action: \.path)
  }
}

extension PostList {
  @Reducer(state: .equatable)
  public enum Path {
    case postDetail(PostDetail)
  }
}

public struct PostListView: View {
  @Namespace private var nameSpace
  @Bindable var store: StoreOf<PostList>

  public init(store: StoreOf<PostList>) {
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
              ForEach(store.scope(state: \.postItems, action: \.postItems)) { store in
                PostListItemView.init(store: store)
                  .listRowSeparator(.hidden)
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
      case let .postDetail(store):
        PostDetailView(store: store)
      }
    }
  }
}

#Preview {
  PostListView(
    store: .init(initialState: PostList.State()) {
      PostList()
    }
  )
}
