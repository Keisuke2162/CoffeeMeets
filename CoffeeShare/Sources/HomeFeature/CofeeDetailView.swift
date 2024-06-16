//
//  CofeeDetailView.swift
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
public struct CoffeeDetail {
  @ObservableState
  public struct State: Equatable {
    public var id: String { coffee.id }
    let coffee: Coffee

    public init(coffee: Coffee) {
      self.coffee = coffee
    }
  }

  public enum Action: BindableAction {
    case onAppear
    case binding(BindingAction<State>)
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
      case .binding:
        return .none
      }
    }
  }
}

public struct CoffeeDetailView: View {
  @Bindable var store: StoreOf<CoffeeDetail>
  
  public init(store: StoreOf<CoffeeDetail>) {
    self.store = store
  }

  public var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        // Image
        Image(store.coffee.thumbnailTitle, bundle: .module)
          .resizable()
          .clipShape(.rect(cornerRadius: 8))
          .aspectRatio(contentMode: .fill)
          .frame(height: 224)
          .padding(.horizontal, 32)

        VStack(alignment: .leading, spacing: 16) {
          typeView(type: store.coffee.type)
            .padding(.top, 32)
          Text(store.coffee.title)
            .font(.system(size: 24).bold())
          HStack(alignment: .center, spacing: 12) {
            Image(systemName: "map")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 20)
              .foregroundStyle(.black)
            if let place = store.coffee.place {
              Text(place)
                .font(.system(size: 16))
                .foregroundStyle(.black)
            }
          }
          starView(count: store.coffee.starCount)
          Spacer(minLength: 16)
          
          VStack {
            HStack {
              
              Text("諸島")
            }
            // Description
            if let discription = store.coffee.discription {
              Text(discription)
                .font(.system(size: 16))
                .padding(16)
                .background(Color.coffeeDetailDescriptionColor)
                .clipShape(.rect(cornerRadius: 8))
            }
          }
        }
        .padding(.horizontal, 32)
      }
    }
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
      HStack(alignment: .center, spacing: 6) {
        Image(systemName: "cup.and.saucer")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 24)
          .foregroundStyle(.black)
        Text("coffee")
          .font(.system(size: 16).bold())
          .foregroundStyle(.black)
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
  CoffeeDetailView(store: .init(initialState: CoffeeDetail.State(coffee: .mock(id: "0", type: .coffee)), reducer: {
    CoffeeDetail()
  }))
}
