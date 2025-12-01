// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode2",
    defaultLocalization: "en",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "AdventOfCode2", targets: ["AdventOfCode2"]),
        .library(name: "AdventOfCode2024", targets: ["AdventOfCode2024"]),
        .library(name: "AdventOfCode2025", targets: ["AdventOfCode2025"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Kamaalio/KamaalSwift.git", .upToNextMajor(from: "3.4.0")),
    ],
    targets: [
        .target(name: "AdventOfCode2"),
        .testTarget(name: "AdventOfCode2Tests", dependencies: ["AdventOfCode2"]),
        .target(
            name: "AdventOfCode2024",
            dependencies: ["AdventOfCode2"],
            resources: [.process("Input")]
        ),
        .testTarget(name: "AdventOfCode2024Tests", dependencies: ["AdventOfCode2024"]),
        .target(
            name: "AdventOfCode2025",
            dependencies: [
                .product(name: "KamaalExtensions", package: "KamaalSwift"),
                "AdventOfCode2",
            ],
            resources: [.process("Input")]
        ),
        .testTarget(name: "AdventOfCode2025Tests", dependencies: ["AdventOfCode2025"]),
    ]
)
