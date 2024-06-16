//
//  PostItem.swift
//  
//
//  Created by Kei on 2024/05/22.
//

import Foundation
import SwiftUI

public struct PostItems: Codable {
  
}

public struct PostItem: Codable, Equatable, Identifiable {
  public let id: String
  public let thumanbilImage: URL?
  public let thumbnailTitle: String
  public let type: ItemType
  public let title: String
  public let place: String?
  public let starCount: Int
  public let discription: String?
  
  public init(id: String, thumanbilImage: URL?, thumbnailTitle: String, type: ItemType, title: String, place: String?, starCount: Int, discription: String?) {
    self.id = id
    self.thumanbilImage = thumanbilImage
    self.thumbnailTitle = thumbnailTitle
    self.type = type
    self.title = title
    self.place = place
    self.starCount = starCount
    self.discription = discription
  }
}

extension PostItem {
  public static func mock(id: String, type: ItemType) -> PostItem {
    switch type {
    case .cafe:
      return .init(
        id: id,
        thumanbilImage: URL(string: "https://placehold.jp/150x150.png"), 
        thumbnailTitle: "cafe_sample",
        type: type,
        title: "諸島’s cafe",
        place: "横浜市/戸塚",
        starCount: 3,
        discription: "2年前からよく通うカフェです。土日でもほどほどに空いていてコーヒーも軽食も美味しくてすごく良いです"
      )
    case .coffee:
      return .init(
        id: id,
        thumanbilImage: URL(string: "https://placehold.jp/150x150.png"), 
        thumbnailTitle: "coffee_sample",
        type: type,
        title: "珈琲諸島オリジナルブレンド",
        place: "京都",
        starCount: 5,
        discription: "6月に旅行した時に寄ったカフェで買ったコーヒーです。苦味の中にほのかな酸味を感じることができてとても良いです"
      )
    }
  }
}

extension PostItem {
  public enum ItemType: String, Codable {
    case cafe
    case coffee
  }
}
