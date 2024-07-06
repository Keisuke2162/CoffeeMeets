// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoffeeShare",
    platforms: [
      .iOS(.v17),
    ],
    products: [
      .library(name: "RootFeature", targets: ["RootFeature"]),
      .library(name: "SigninFeature", targets: ["SigninFeature"]),
    ],
    dependencies: [
      .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.11.1"),
      .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.0.0"))
    ],
    targets: [
      .target(
        name: "APIClient",
        dependencies: [
          "Entity",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
      .target(name: "Entity"),
      .target(
        name: "Extensions",
        dependencies: [
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
      .target(
        name: "FirebaseClient",
        dependencies: [
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
          .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
        ]
      ),
      .target(
        name: "AppFeature",
        dependencies: [
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
      .testTarget(
        name: "AppFeatureTests",
        dependencies: ["AppFeature"]
      ),
      .target(
        name: "RootFeature",
        dependencies: [
          "HomeFeature",
          "SettingFeature",
          "FirebaseClient",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
          .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
          .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
        ]
      ),
      .target(
        name: "HomeFeature",
        dependencies: [
          "Entity",
          "Extensions",
          "APIClient",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
      .target(
        name: "SettingFeature",
        dependencies: [
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
      .target(
        name: "SigninFeature",
        dependencies: [
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
    ]
)
