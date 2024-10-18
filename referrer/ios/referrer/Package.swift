// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "referrer",
    platforms: [
        .iOS("11.0"),
    ],
    products: [
        .library(name: "referrer", targets: ["referrer"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "referrer",
            dependencies: [],
            resources: []
        )
    ]
)
