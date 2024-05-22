//
//  CoffeeList.swift
//
//
//  Created by Kei on 2024/05/22.
//

import ComposableArchitecture
import Entity
import Foundation
import SwiftUI

@Reducer
public struct CoffeeList {
  @ObservableState
  public struct State: Equatable {
    var items: [Coffee] = []

    public init() {}
  }

  public enum Action {
    case onAppear
    
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
      }
    }
  }
}

public struct CoffeeListView: View {
  let store: StoreOf<CoffeeList>


  public var body: some View {
    Text("A")
  }
}



/*
 public struct FavoriteRepositoryListView: View {
   @Bindable var store: StoreOf<FavoriteRepositoryList>

   public init(store: StoreOf<FavoriteRepositoryList>) {
     self.store = store
   }

   public var body: some View {
     NavigationStack(
       path: $store.scope(
         state: \.path,
         action: \.path
       )
     ) {
       List {
         ForEach(
           store.scope(
             state: \.repositoryRows,
             action: \.repositoryRows
           ),
           content: RepositoryRowView.init(store:)
         )
         .onDelete {
           store.send(.onDelete($0))
         }
       }
       .navigationTitle("Favorite Repositories")
       .onAppear {
         store.send(.onAppear)
       }
     } destination: { store in
       switch store.case {
       case let .repositoryDetail(store):
         RepositoryDetailView(store: store)
       }
     }
   }
 }
 */
