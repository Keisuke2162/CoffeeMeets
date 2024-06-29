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
    var selectedImages: [UIImage] = []
    var showImagePicker: Bool = false
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
    
    
    case toggleImagePicker
//    case imagesSelected([UIImage])
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
      case .toggleImagePicker:
        state.showImagePicker.toggle()
        return .none
//      case let .imagesSelected(images):
//        state.selectedImages = images
//        state.showImagePicker = false
//        return .none
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

extension PostingModal {
  enum Field: Hashable {
    case title, content
  }
}

struct PostingModalView: View {
  @Bindable var store: StoreOf<PostingModal>
  @FocusState private var focusedField: PostingModal.Field?

  public init(store: StoreOf<PostingModal>) {
    self.store = store
  }
  
  var body: some View {
    GeometryReader { geo in
      NavigationStack {
        VStack(alignment: .center, spacing: 32) {
          // 名前
          TextField("Title", text: $store.title)
            .font(.title)
            .padding()
            .focused($focusedField, equals: .title)
            .onSubmit {
              focusedField = .content
            }
          
          // ブランド（不要？）
          
          
          // 場所
          
          
          // 場所（詳細）
          
          
          // 評価
          
          
          // コメント
          
          
          // 日付
          
          
          // 写真
          
          
          
          // Type選択
          HStack {
            Button(action: {
              store.send(.tapCategoryType(store.selectedType))
            }, label: {
              typeView(type: store.selectedType)
                .foregroundStyle(.black)
            })
            .frame(height: 144)
            .padding(.horizontal, 24)
            .overlay(
              RoundedRectangle(cornerRadius: 30)
                .stroke(Color.black, lineWidth: 2)
            )
            .padding()
            Spacer()
            // 星
            starView(count: store.starCount)
              .frame(height: 144)
              .padding(.horizontal, 32)
          }
          .padding(.horizontal, 16)
          
          
          VStack {
            ScrollView(.horizontal, showsIndicators: false) {
              HStack {
                ForEach(store.selectedImages, id: \.self) { image in
                  Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(.rect(cornerRadius: 8))
                }
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
                      .foregroundStyle(Color.black)
                      .padding(32)
                }
                .onChange(of: store.selectedPhotos) {
                  store.send(.selectedPhotosOnchange)
                }
              }
            }
            .frame(height: 120)
            .padding(.horizontal)
            
            
            
            ZStack(alignment: .topLeading) {
              TextEditor(text: $store.description)
                .padding()
                .focused($focusedField, equals: .content)
              if store.description.isEmpty {
                
                Text("Content")
                  .foregroundStyle(Color.gray)
                  .padding(24)
              }
            }
            
          }
        }
        .background(Color.brown.opacity(0.9))
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
        .foregroundStyle(.black)
      }
    }
  }
  
  // Type選択ボタン
  @ViewBuilder
  private func typeView(type: PostItem.ItemType) -> some View {
    VStack {
      Image(systemName: "storefront")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 48)
      Text("coffee")
        .font(.system(size: 24).bold())
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
              .frame(height: 24)
              .foregroundStyle(Color.yellow)
          } else {
            Image(systemName: "star")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: 24)
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

