import PackageDescription

let package = Package(
	name: "Swiftx",
	targets: [
		Target(name: "Swiftx"),
	],
	dependencies: [
		.Package(url: "https://github.com/typelift/Operadics.git", versions: Version(0,2,2)...Version(0,2,2))
	]
)

let libSwiftx = Product(name: "Swiftx", type: .Library(.Dynamic), modules: "Swiftx")
products.append(libSwiftx)
