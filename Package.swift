import PackageDescription

let package = Package(
	name: "Swiftx",
	targets: [
		Target(name: "Swiftx"),
	],
	dependencies: [
		.Package(url: "https://github.com/typelift/Operadics.git", majorVersion: 0)
	]
)

