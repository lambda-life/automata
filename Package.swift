// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Automata",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Automata",
            targets: ["Automata"]),
    ],
    targets: [
        .target(
            name: "Automata",
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["Automata"],
            path: "Tests"),
    ]
)
