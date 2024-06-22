//
//  PostDetailView.swift
//
//
//  Created by Kei on 2024/05/23.
//

import ComposableArchitecture
import Entity
import Extensions
import Foundation
import SwiftUI
import IdentifiedCollections

@Reducer
public struct PostDetail {
  @ObservableState
  public struct State: Equatable {
    public var id: String { postItem.id }
    let postItem: PostItem

    public init(postItem: PostItem) {
      self.postItem = postItem
    }
  }

  public enum Action {
    case onAppear
    // case binding(BindingAction<State>)
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    // BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
//      case .binding:
//        return .none
      }
    }
  }
}

public struct PostDetailView: View {
  @Bindable var store: StoreOf<PostDetail>
  
  public init(store: StoreOf<PostDetail>) {
    self.store = store
  }

  public var body: some View {
    ScrollView {
      VStack(alignment: .center) {
        // Header
        
        // Image
        Image(store.postItem.thumbnailTitle, bundle: .module)
          .resizable()
          .clipShape(.rect(cornerRadius: 8))
          .aspectRatio(contentMode: .fit)
          .frame(height: 224)
          //.padding(.horizontal, 32)

        VStack(alignment: .leading, spacing: 16) {
          HStack {
            typeView(type: store.postItem.type)
              .padding(.top, 32)
            
          }
          Text(store.postItem.title)
            .font(.system(size: 24).bold())
          HStack(alignment: .center, spacing: 12) {
            Image(systemName: "map")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 20)
            if let place = store.postItem.place {
              Text(place)
                .font(.system(size: 16))
            }
          }
          starView(count: store.postItem.starCount)
          Spacer(minLength: 16)
          
          
          Group {
            VStack(alignment: .leading, spacing: 12) {
              HStack(spacing: 8) {
                Image("icon-user-sample", bundle: .module)
                  .resizable()
                  .frame(width: 32, height: 32)
                  .clipShape(.circle)
                Text(store.postItem.reviewUserName)
                  .font(.system(size: 14).weight(.medium))
              }
              // Description
              if let discription = store.postItem.discription {
                Text(discription)
                  .font(.system(size: 16).weight(.medium))
              }
            }
            .padding(16)
            .background(Color.coffeeDetailDescription)
            .clipShape(.rect(cornerRadius: 8))
          }
        }
        .padding(.horizontal, 32)
      }
    }
    //.navigationBarBackButtonHidden()
  }
  
  // TODO: これ使いまわしてるからどうにかしたい
  @ViewBuilder
  private func typeView(type: PostItem.ItemType) -> some View {
    switch type {
    case .cafe:
      HStack(alignment: .center, spacing: 2) {
        Image(systemName: "storefront")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 24)
        Text("cafe")
          .font(.system(size: 16).bold())
      }
    case .coffee:
      HStack(alignment: .center, spacing: 6) {
        Image(systemName: "cup.and.saucer")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 24)
        Text("coffee")
          .font(.system(size: 16).bold())
      }
    }
  }

  @ViewBuilder
  private func starView(count: Int) -> some View {
    HStack(alignment: .center, spacing: 4) {
      ForEach(0..<5, id: \.self) { index in
        if index < count {
          Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 16)
            .foregroundStyle(Color.yellow)
        } else {
          Image(systemName: "star")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 16)
            .foregroundStyle(Color.yellow)
        }
      }
    }
  }
  
}

#Preview {
  PostDetailView(store: .init(initialState: PostDetail.State(postItem: .mock(id: "0", type: .coffee)), reducer: {
    PostDetail()
  }))
}
