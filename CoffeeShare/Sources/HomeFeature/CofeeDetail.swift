//
//  CofeeDetail.swift
//
//
//  Created by Kei on 2024/05/23.
//

import ComposableArchitecture
import Entity
import Foundation
import SwiftUI
import IdentifiedCollections

@Reducer
public struct CoffeeDetail {
  @ObservableState
  public struct State: Equatable {
    public init() {}
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
        // Account
        
        // Image
        Rectangle()
          .aspectRatio(1, contentMode: .fit)
          .overlay {
            Image("cofee_sample", bundle: .module)
              .resizable()
              .aspectRatio(contentMode: .fill)
          }
          .clipped()
          .frame(height: 400)
        
        // Category
        HStack {
          Image(systemName: "cup.and.saucer")
            .padding()
          Image(systemName: "mug")
            .padding()
          Image(systemName: "house.lodge")
            .padding()
          Image(systemName: "takeoutbag.and.cup.and.straw")
            .padding()
        }
        // Title
        Text("コロンビア")
          .font(.title).bold()
          .padding()
        // Review
        
        // Text
        
      }
      
    }
    .background(Color.brown)
  }
}

#Preview {
  CoffeeDetailView(store: .init(initialState: CoffeeDetail.State(), reducer: {
    CoffeeDetail()
  }))
}
