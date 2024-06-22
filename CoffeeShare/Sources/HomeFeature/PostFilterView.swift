//
//  PostFilterView.swift
//
//
//  Created by Kei on 2024/06/16.
//

import CasePaths
import ComposableArchitecture
import Entity
import Extensions
import Foundation
import SwiftUI

@Reducer
public struct PostFilter {
  @ObservableState
  public struct State: Equatable {
    @Shared(.selectedPostItemTypes) var sharedSelectedTypes

    var selectedPostItemTypes: [PostItem.ItemType] = []
    var items: [PostItemType] {
      let items = PostItem.ItemType.allCases
      return items.map {
        let isExist = selectedPostItemTypes.contains($0)
        return .init(type: $0, isChoose: isExist)
      }
    }

    public init() {
    }
  }

  public enum Action {
    case onAppear
    case tapTypeView(PostItem.ItemType)
    case tapSaveButton
  }

  public init() {}

  @Dependency(\.dismiss) var dismiss

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        // 保存ボタンタップ時にSharedの更新をしたいので一度変数にコピー
        state.selectedPostItemTypes = state.sharedSelectedTypes
        return .none
      case let .tapTypeView(type):
        if let index = state.selectedPostItemTypes.firstIndex(of: type) {
          state.selectedPostItemTypes.remove(at: index)
        } else {
          state.selectedPostItemTypes.append(type)
        }
        return .none
      case .tapSaveButton:
        state.sharedSelectedTypes = state.selectedPostItemTypes
        return .run { _ in
          await self.dismiss()
        }
      }
    }
  }
}

extension PostFilter {
  struct PostItemType: Hashable {
    let type: PostItem.ItemType
    let isChoose: Bool
  }
}

struct PostFilterView: View {
  let store: StoreOf<PostFilter>
  
  public init(store: StoreOf<PostFilter>) {
    self.store = store
  }

  var body: some View {
    VStack {
      // Header
      ZStack {
        Text("絞り込み")
          .font(.system(size: 16).bold())
        HStack {
          Spacer()
          Button {
            store.send(.tapSaveButton)
          } label: {
            Text("保存")
              .font(.system(size: 16).bold())
          }
        }
        .padding(.trailing, 32)
      }
      .padding(.top, 32)
      // FilterItem
      List(store.state.items, id: \.self) { item in
        Button {
          store.send(.tapTypeView(item.type))
        } label: {
          HStack {
            typeView(type: item.type)
              .padding(.vertical, 8)
            Spacer()
            if item.isChoose {
              Image(systemName: "checkmark")
            }
          }
          .foregroundColor(.primary)
          .padding(.horizontal, 16)
        }
      }
      .listStyle(.plain)
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
  
  @ViewBuilder
  private func typeView(type: PostItem.ItemType) -> some View {
    switch type {
    case .cafe:
      HStack(alignment: .center, spacing: 12) {
        Image(systemName: "storefront")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 24)
        Text("cafe")
          .font(.system(size: 16))
      }
      .frame(height: 24)
    case .coffee:
      HStack(alignment: .center, spacing: 12) {
        Image(systemName: "cup.and.saucer")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 24)
        Text("coffee")
          .font(.system(size: 16))
      }
      .frame(height: 24)
    }
  }
}

#Preview {
  @Shared(.selectedPostItemTypes) var sharedSelectedTypes = []
  return PostFilterView(store: .init(initialState: PostFilter.State(), reducer: {
    PostFilter()
  }))
}


