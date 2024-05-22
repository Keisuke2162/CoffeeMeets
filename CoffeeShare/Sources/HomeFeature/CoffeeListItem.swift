//
//  CoffeeListItem.swift
//
//
//  Created by Kei on 2024/05/22.
//

import CasePaths
import ComposableArchitecture
import Entity
import Foundation
import SwiftUI

@Reducer
public struct CoffeeListItem {
  @ObservableState
  public struct State: Equatable {
    public var id: String { coffee.id }

    let coffee: Coffee

    public init(coffee: Coffee) {
      self.coffee = coffee
    }
  }

  public enum Action {
    case tapItem
    case delegate(Delegate)
  
    @CasePathable
    public enum Delegate {
      case tapItem(Coffee)
    }
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .tapItem:
        return .send(.delegate(.tapItem(state.coffee)))
      case .delegate:
        return .none
      }
    }
  }
}

struct CoffeeListItemView: View {
  let store: StoreOf<CoffeeListItem>

  var body: some View {
    Button {
      store.send(.tapItem)
    } label: {
      HStack(alignment: .center, spacing: 16) {
        AsyncImage(url: store.coffee.thumanbilImage) { phase in
          if let image = phase.image {
            image
              .resizable()
              .frame(width: 80, height: 80)
          } else if phase.error != nil {
            // TODO: Error
            Color(.red)
          } else {
            ProgressView()
          }
        }
        Text(store.coffee.fullName)
        Spacer()
      }
    }
  }
}

#Preview {
  CoffeeListItemView(
    store: .init(
      initialState: CoffeeListItem.State(coffee: .mock(id: "1")),
      reducer: {
        CoffeeListItem()
      }
    )
  )
  .padding()
}
