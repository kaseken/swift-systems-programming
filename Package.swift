// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSystemsProgramming",
    platforms: [
        .macOS(.v13),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-system.git", from: "1.3.0"),
    ],
    targets: [
        .executableTarget(
            name: "Chapter01",
            dependencies: [
                .product(name: "SystemPackage", package: "swift-system"),
            ],
            path: "Sources/Chapter01"
        ),
    ]
)
