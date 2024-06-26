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
import PhotosUI

@Reducer
public struct PostingModal {
  @ObservableState
  public struct State: Equatable {
    var selectedType: PostItem.ItemType = .coffee
    var title: String = ""
    var starCount: Int = 3
    var place: String = ""
    var description: String = ""
    
    // 写真
    var selectedImages: [UIImage?] = []
    var selectedPhotos: [PhotosPickerItem] = []
    let maxSelectablePhotoCount: Int = 4
    

    public init() {
    }
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case onAppear
    case tapCategoryType(PostItem.ItemType)
    case tapStarButton(Int)
    case tapCancelButton
    case selectedPhotosOnchange
    case updateSelectedImage(UIImage)
  }

  public init() {}

  @Dependency(\.dismiss) var dismiss

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .onAppear:
        return .none
      case let .tapCategoryType(type):
        state.selectedType = type
        return .none
      case let .tapStarButton(count):
        state.starCount = count
        return .none
      case .tapCancelButton:
        return .run { _ in await dismiss() }
      case .selectedPhotosOnchange:
        state.selectedImages.removeAll()
        let selectedPhotos = state.selectedPhotos
        return .run { send in
          for photo in selectedPhotos {
            guard let data = try? await photo.loadTransferable(type: Data.self) else { continue }
            if let image = UIImage(data: data) {
              await send(.updateSelectedImage(image))
            } else {
              continue
            }
          }
        }
      case let .updateSelectedImage(image):
        print("テスト \(image)")
        state.selectedImages.append(image)
        return .none
      }
    }
  }
}

struct PostingModalView: View {
  @Bindable var store: StoreOf<PostingModal>
  
  /*
   ScrollView(.horizontal) {
                   HStack {
                       ForEach(uiImages, id: \.self) { uiImage in
                           if let uiImage {
                               Image(uiImage: uiImage)
                                   .resizable()
                                   .scaledToFit()
                                   .padding(20)
                           }
                       }
                   }
               }
   */
  
  public init(store: StoreOf<PostingModal>) {
    self.store = store
  }

  var body: some View {
    NavigationStack {
      VStack(alignment: .center, spacing: 32) {
        // 画像
        PhotosPicker(
          selection: $store.selectedPhotos,
          maxSelectionCount: 4,
          matching: .images,
          photoLibrary: .shared()
        ) {
          Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32)
                        .foregroundStyle(Color.gray)
        }
        .onChange(of: store.selectedPhotos) {
          store.send(.selectedPhotosOnchange)
        }
        
        ScrollView(.horizontal) {
          HStack {
            ForEach(store.selectedImages, id: \.self) { image in
              if let image {
                Image(uiImage: image)
                  .clipShape(.rect(cornerRadius: 8))
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 300, height: 150, alignment: .center)
              }
            }
          }
        }
        
        
        // Type選択
        HStack(spacing: 8) {
          ForEach(PostItem.ItemType.allCases, id: \.self) { item in
            Button(action: {
              store.send(.tapCategoryType(item))
            }, label: {
              typeView(type: item)
            })
            .padding(8)
            .background(item == store.selectedType ? Color.brown : Color.gray.opacity(0.5))
            .foregroundStyle(item == store.selectedType ? Color.white : Color.black)
            
            .clipShape(.rect(cornerRadius: 8))
          }
        }
        .padding(.top, 16)
        // 店舗名or商品名
        TextField("Title", text: $store.title)
          .padding(.horizontal, 32)
        // 星
        starView(count: store.starCount)
        // 場所
        TextField("Place", text: $store.place)
          .padding(.horizontal, 32)
        // description
        ZStack(alignment: .topLeading) {
          TextEditor(text: $store.description)
            .padding(12)
          if store.description.isEmpty {
            Text("Description") .foregroundColor(Color(uiColor: .placeholderText))
                .padding(20)
                .allowsHitTesting(false)
          }
        }
        Spacer()
      }
      .background(Color.blue.opacity(0.2))
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            store.send(.tapCancelButton)
          } label: {
            Text("キャンセル")
              .padding(.leading, 8)
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            
          } label: {
            Text("投稿")
              .padding(.trailing, 8)
          }
        }
      }
    }
  }
  
  // Type選択ボタン
  @ViewBuilder
  private func typeView(type: PostItem.ItemType) -> some View {
    switch type {
    case .cafe:
      HStack(alignment: .center, spacing: 4) {
        Image(systemName: "storefront")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 24)
        Text("cafe")
          .font(.system(size: 16))
      }
      .frame(height: 24)
    case .coffee:
      HStack(alignment: .center, spacing: 4) {
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

  @ViewBuilder
  private func starView(count: Int) -> some View {
    HStack(alignment: .center, spacing: 4) {
      ForEach(0..<5, id: \.self) { index in
        Button(action: {
          store.send(.tapStarButton(index + 1))
        }, label: {
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
        })
      }
    }
  }
}

#Preview {
  return PostingModalView(store: .init(initialState: PostingModal.State(), reducer: {
    PostingModal()
  }))
}

