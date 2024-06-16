//
//  CoffeeAPIClient.swift
//
//
//  Created by Kei on 2024/05/24.
//

import Dependencies
import DependenciesMacros
import Entity

@DependencyClient
public struct CoffeeAPIClient {
  public var getCoffeeList: @Sendable () async throws -> [PostItem]
}

extension CoffeeAPIClient: DependencyKey {
  public static let liveValue: Self = {
    return Self(
      getCoffeeList: {
        // TODO: Request
        let mock = (0...10).map {
          if $0 % 2 == 0 {
            PostItem.mock(id: "\($0)", type: .cafe)
          } else {
            PostItem.mock(id: "\($0)", type: .coffee)
          }
        }
        return mock
      }
    )
  }()
}

extension DependencyValues {
  public var coffeeAPIClient: CoffeeAPIClient {
    get { self[CoffeeAPIClient.self] }
    set { self[CoffeeAPIClient.self] = newValue }
  }
}
