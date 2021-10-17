// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RadioTimeKit",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(name: "RadioTimeKit", targets: ["RadioTimeKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/sharplet/Regex.git", from: "2.1.0"),
        .package(url: "https://github.com/nbasham/CloudUserDefaults.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "RadioTimeKit",
            dependencies: ["Regex", "CloudUserDefaults"],
            path: "Sources"
        ),
        .testTarget(
            name: "RadioTimeKitTests",
            dependencies: ["RadioTimeKit"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
