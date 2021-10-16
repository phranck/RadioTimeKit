// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RadioTimeKit",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "RadioTimeKit", targets: ["RadioTimeKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/sharplet/Regex.git", from: "2.1.0"),
        .package(url: "https://github.com/realm/realm-cocoa.git", from: "10.17.0")
    ],
    targets: [
        .target(
            name: "RadioTimeKit",
            dependencies: [
                "Regex",
                .product(name: "Realm", package: "realm-cocoa"),
                .product(name: "RealmSwift", package: "realm-cocoa")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "RadioTimeKitTests",
            dependencies: ["RadioTimeKit"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
