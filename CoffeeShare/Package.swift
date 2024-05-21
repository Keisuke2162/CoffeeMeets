// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoffeeShare",
    platforms: [
      .iOS(.v17),
    ],
    products: [
      .library(
        name: "AppFeature",
        targets: ["AppFeature"]
      ),
      .library(
        name: "RootFeature",
        targets: ["RootFeature"]
      ),
    ],
    dependencies: [
      .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.10.4"),
    ],
    targets: [
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
          .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]
      ),
    ]
)
