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
    ],
    targets: [
      .target(
        name: "AppFeature"
      ),
      .testTarget(
        name: "AppFeatureTests",
        dependencies: ["AppFeature"]
      )
    ]
)
