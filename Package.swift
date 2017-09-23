// swift-tools-version:4.0

import PackageDescription

let package = Package(
	name: "Swiftx",
	products: [
        .library(name: "Swiftx", targets: ["Swiftx"])
    ],
	dependencies: [
		.package(url: "https://github.com/typelift/Operadics.git", .branch("master")),
		.package(url: "https://github.com/typelift/SwiftCheck.git", .branch("master"))
	],
	targets: [
		.target(name: "Swiftx", dependencies: ["Operadics"]),
        .testTarget(name: "SwiftxTests", dependencies: ["Swiftx", "SwiftCheck"]),
	]
)

