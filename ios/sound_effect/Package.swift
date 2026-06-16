// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sound_effect",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        // The plugin name contains "_", so "-" is used for the library name.
        .library(name: "sound-effect", targets: ["sound_effect"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "sound_effect",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            resources: [
                // This plugin does not require a privacy manifest, so the
                // PrivacyInfo.xcprivacy file in ios/Resources is left unbundled.
                // If that changes, move it next to the sources and uncomment:
                // .process("PrivacyInfo.xcprivacy"),
            ]
        )
    ]
)
