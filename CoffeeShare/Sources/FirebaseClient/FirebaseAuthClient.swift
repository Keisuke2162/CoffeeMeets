//
//  File.swift
//  
//
//  Created by Kei on 2024/07/03.
//

import Dependencies
import DependenciesMacros
import FirebaseAuth
import Foundation

@DependencyClient
public struct FirebaseAuthClient {
  public var getAuthStatus: @Sendable () async throws -> Bool
}

extension FirebaseAuthClient: DependencyKey {
  public static let liveValue: Self = {
    return FirebaseAuthClient(
      getAuthStatus: {
        return false
      }
    )
  }()
}

extension DependencyValues {
  public var firebaseAuthClient: FirebaseAuthClient {
    get { self[FirebaseAuthClient.self] }
    set { self[FirebaseAuthClient.self] = newValue }
  }
}
