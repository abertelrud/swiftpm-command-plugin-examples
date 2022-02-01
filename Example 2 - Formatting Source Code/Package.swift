// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "MyFormatterPlugin",
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.48.0"),
    ],
    targets: [
        .plugin(
            name: "MyFormatterPlugin",
            capability: .command(
                intent: .sourceCodeFormatting(),
                permissions: [
                    .writeToPackageDirectory(reason: "This command reformats source files")
                ]
            ),
            dependencies: [
                .product(name: "swiftformat", package: "SwiftFormat"),
            ]
        ),
        // This is a sample target on which we can invoke the plugin.
        .target(
            name: "MyLibrary"
        )
    ]
)
