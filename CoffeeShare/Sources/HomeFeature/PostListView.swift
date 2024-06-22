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
    // 絞り込みType
    @Shared(.selectedPostItemTypes) var sharedSelectedTypes
    // 一覧の表示
    var postItems: IdentifiedArrayOf<PostListItem.State> = []
    // 画面遷移
    var path = StackState<Path.State>()
    // Loading
    var isLoading: Bool = false
    // モーダル
    @Presents var destination: Destination.State?

    public init() {}
  }

  public enum Action: BindableAction {
    case onAppear
    // モーダル
    case destination(PresentationAction<Destination.Action>)
    case tapFilterButton
    // 投稿一覧取得
    case getPostListResponse(Result<[PostItem], Error>)
    case binding(BindingAction<State>)
    case postItems(IdentifiedActionOf<PostListItem>)
    case path(StackAction<Path.State, Path.Action>)
    // 投稿ボタン
    case tapPostingButton
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

      case .destination(.presented(.postFilter(.tapSaveButton))):
        // TODO: Filterに変化がない場合は再取得しないようにしたい
        state.isLoading = true
        return .run { send in
          await send(.getPostListResponse(
            Result {
              try await coffeeAPIClient.getCoffeeList()
            }
          ))
        }

      case .destination:
        return .none

      case .tapFilterButton:
        state.destination = .postFilter(PostFilter.State())
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
      case .tapPostingButton:
        state.destination = .postingModal(PostingModal.State())
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination.body
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
  
  @Reducer(state: .equatable)
  public enum Destination {
    case postFilter(PostFilter)
    case postingModal(PostingModal)
  }
}

public struct PostListView: View {
  @Namespace private var nameSpace
  @Bindable var store: StoreOf<PostList>

  public init(store: StoreOf<PostList>) {
    self.store = store
  }

  public var body: some View {
    ZStack {
      NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
        Group {
          if store.isLoading {
            ProgressView()
          } else {
            VStack {
              HStack {
                Spacer()
                Button(action: {
                  store.send(.tapFilterButton)
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
      .sheet(item: $store.scope(state: \.destination?.postFilter, action: \.destination.postFilter)) { store in
        PostFilterView(store: store)
          .presentationDetents([.medium])
      }
      .sheet(item: $store.scope(state: \.destination?.postingModal, action: \.destination.postingModal)) { store in
        PostingModalView(store: store)
      }
      
      VStack {
        Spacer()
        HStack {
          Spacer()
          Button {
            store.send(.tapPostingButton)
          } label: {
            Image(systemName: "plus.circle")
              .resizable()
              .frame(width: 32, height: 32)
              .foregroundStyle(Color.black)
          }
          .frame(width: 64, height: 64)
          .background(Color.brown)
          .clipShape(.rect(cornerRadius: 8))
          .padding(32)
        }
        
      }
    }
  }
}

//#Preview {
//  PostListView(
//    store: .init(initialState: PostList.State()) {
//      PostList()
//    }
//  )
//}
