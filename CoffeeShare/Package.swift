// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoffeeShare",
    platforms: [
      .iOS(.v17),
    ],
    products: [
      .library(name: "AppFeature", targets: ["AppFeature"]),
      .library(name: "RootFeature", targets: ["RootFeature"]),
      .library(name: "HomeFeature", targets: ["HomeFeature"]),
      .library(name: "Entity", targets: ["Entity"]),
      .library(name: "APIClient", targets: ["APIClient"]),
    ],
    dependencies: [
      .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.10.4"),
    ],
    targets: [
      .target(
        name: "APIClient",
        dependencies: [
          "Entity",
        ]
      ),
      .target(
        name: "Entity",
        dependencies: [
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
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
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
      .target(
        name: "HomeFeature",
        dependencies: [
          "Entity",
          "APIClient",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
    ]
)
