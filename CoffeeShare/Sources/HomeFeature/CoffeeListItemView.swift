//
//  CoffeeListItemView.swift
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
  public struct State: Equatable, Identifiable {
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

  public init() {}

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
  
  public init(store: StoreOf<CoffeeListItem>) {
    self.store = store
  }

  var body: some View {
    Button {
      store.send(.tapItem)
    } label: {
      HStack(alignment: .top, spacing: 16) {
//        AsyncImage(url: store.coffee.thumanbilImage) { phase in
//          if let image = phase.image {
//            image
//              .resizable()
//              .frame(width: 80, height: 80)
//          } else if phase.error != nil {
//            // TODO: Error
//            Color(.red)
//          } else {
//            ProgressView()
//          }
//        }
        Image(store.coffee.thumbnailTitle, bundle: .module)
          .resizable()
          .scaledToFill()
          .frame(width: 88, height: 88)
          .clipShape(Rectangle())
        VStack(alignment: .leading, spacing: 8) {
          typeView(type: store.coffee.type)
            .padding(.top, 8)
          Text(store.coffee.title)
            .font(.system(size: 12).bold())
            .foregroundStyle(.black)
          HStack(alignment: .center, spacing: 8) {
            Image(systemName: "map")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 12)
              .foregroundStyle(.black)
            if let place = store.coffee.place {
              Text(place)
                .font(.system(size: 8))
                .foregroundStyle(.black)
            }
          }
          starView(count: store.coffee.starCount)
          
        }
        Spacer()
      }
    }
    .buttonStyle(CustomButtonStyle())
    .background(Color.white)
    .clipShape(.rect(cornerRadius: 8))
    .shadow(radius: 4)
  }
  
  @ViewBuilder
  private func typeView(type: Coffee.ItemType) -> some View {
    switch type {
    case .cafe:
      HStack(alignment: .center, spacing: 2) {
        Image(systemName: "storefront")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 12)
          .foregroundStyle(.black)
        Text("cafe")
          .font(.system(size: 8))
          .foregroundStyle(.black)
      }
    case .coffee:
      HStack(alignment: .center, spacing: 2) {
        Image(systemName: "cup.and.saucer")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 12.12)
          .foregroundStyle(.black)
        Text("coffee")
          .font(.system(size: 8))
          .foregroundStyle(.black)
      }
    }
  }

  @ViewBuilder
  private func starView(count: Int) -> some View {
    HStack(alignment: .center, spacing: 2) {
      ForEach(0..<5, id: \.self) { index in
        if index < count {
          Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 8)
            .foregroundStyle(Color.yellow)
        } else {
          Image(systemName: "star")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 8)
            .foregroundStyle(Color.yellow)
        }
      }
    }
  }
}

struct CustomButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .opacity(configuration.isPressed ? 0.6 : 1.0)
      .contentShape(Rectangle())
  }
}

#Preview {
  CoffeeListItemView(
    store: .init(
      initialState: CoffeeListItem.State(coffee: .mock(id: "1", type: .cafe)),
      reducer: {
        CoffeeListItem()
      }
    )
  )
  .padding()
}


