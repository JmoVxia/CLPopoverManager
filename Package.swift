// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "CLPopoverManager",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CLPopoverManager",
            targets: ["CLPopoverManager"]
        ),
    ],
    targets: [
        .target(
            name: "CLPopoverManager",
            path: "CLPopoverManager/"
        )
    ],
    swiftLanguageVersions: [.v5]
) 