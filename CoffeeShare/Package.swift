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
    ],
    dependencies: [
      .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.11.1"),
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
      .target(name: "Extensions"),
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
          "Extensions",
          "APIClient",
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
    ]
)
