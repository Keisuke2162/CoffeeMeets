//
//  PostingModalView.swift
//
//
//  Created by Kei on 2024/06/23.
//

import APIClient
import CasePaths
import ComposableArchitecture
import Entity
import Foundation
import SwiftUI
import IdentifiedCollections

@Reducer
public struct PostingModal {
  @ObservableState
  public struct State: Equatable {
    
    public init() {
    }
  }

  public enum Action {
    case onAppear
  }

  public init() {}

  @Dependency(\.dismiss) var dismiss

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
      }
    }
  }
}

struct PostingModalView: View {
  let store: StoreOf<PostingModal>
  
  public init(store: StoreOf<PostingModal>) {
    self.store = store
  }

  var body: some View {
    Text("Hello")
  }
}

#Preview {
  return PostingModalView(store: .init(initialState: PostingModal.State(), reducer: {
    PostingModal()
  }))
}

