//
//  File.swift
//  
//
//  Created by Kei on 2024/05/22.
//

import Foundation

public struct Coffees: Codable {
  
}

public struct Coffee: Codable, Equatable, Identifiable {
  public let id: String
  public let fullName: String
  public let thumanbilImage: URL?

  public init(id: String, fullName: String, thumanbilImage: URL?) {
    self.id = id
    self.fullName = fullName
    self.thumanbilImage = thumanbilImage
  }
}

extension Coffee {
  public static func mock(id: String) -> Coffee {
    .init(
      id: id,
      fullName: "Title",
      thumanbilImage: URL(string: "https://placehold.jp/150x150.png")
    )
  }
}
