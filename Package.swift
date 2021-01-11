// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuckSPM",
    platforms: [.macOS("10.15")],
    products: [
        .executable(
            name: "buck-spm",
            targets: ["buck-spm"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.3.0")),
        .package(url: "https://github.com/stencilproject/Stencil.git", .upToNextMinor(from: "0.13.0")),
        .package(name: "SwiftPM", url: "https://github.com/apple/swift-package-manager", .branch("release/5.3"))
    ],
    targets: [
        .target(
            name: "buck-spm",
            dependencies: ["BuckSPM"]),
        .target(
            name: "BuckSPM",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Stencil",
                "SwiftPM"
            ]),
        .testTarget(
            name: "BuckSPMTests",
            dependencies: ["BuckSPM"]),
    ]
)
