// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "Swiftx",
  products: [
    .library(
      name: "Swiftx",
      targets: ["Swiftx"]),
    ],
  dependencies: [
    .package(url: "https://github.com/typelift/Operadics.git", from: "0.3.0"),
    .package(url: "https://github.com/typelift/SwiftCheck.git", from: "0.9.0"),
  ],
  targets: [
    .target(
      name: "Swiftx",
      dependencies: ["Operadics"]),
    .testTarget(
      name: "SwiftxTests",
      dependencies: ["Swiftx", "Operadics", "SwiftCheck"]),
    ]
)

