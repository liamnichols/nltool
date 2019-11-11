// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NLTool",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .executable(name: "nltool", targets: ["NLTool"])
    ],
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "5.0.0"),
        .package(url: "https://github.com/scottrhoyt/SwiftyTextTable.git", from: "0.5.0")
    ],
    targets: [
        .target(name: "NLTool", dependencies: ["SwiftCLI", "SwiftyTextTable", "NLToolCore"]),
        .target(name: "NLToolCore", dependencies: []),
        .testTarget(name: "NLToolCoreTests", dependencies: ["NLToolCore"]),
    ]
)
