//
//  PersistenceReaderKey+Extension.swift
//
//
//  Created by Kei on 2024/06/21.
//

import ComposableArchitecture
import Entity

extension PersistenceReaderKey where Self == PersistenceKeyDefault<FileStorageKey<[PostItem.ItemType]>> {
  public static var selectedPostItemTypes: Self {
    PersistenceKeyDefault(
      .fileStorage(.documentsDirectory.appending(component: "selected-post-item-types.json")),
      [])
  }
}
