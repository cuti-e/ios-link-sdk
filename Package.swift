// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "CutiELink",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "CutiELink",
            targets: ["CutiELink"]
        ),
    ],
    targets: [
        .target(
            name: "CutiELink",
            dependencies: [],
            path: "Sources/CutiELink"
        )
    ]
)
