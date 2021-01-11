// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyApp",
    platforms: [.macOS("10.15")],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(
            name: "MyApp",
            targets: ["MyApp"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "7.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MyApp",
            dependencies: [
//                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "GoogleUtilities_UserDefaults", package: "Firebase"),
                ],
            exclude: ["BUCK"])
    ]
)
