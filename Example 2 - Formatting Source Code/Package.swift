// swift-tools-version: 999.0
import PackageDescription

let package = Package(
    name: "MyFormatterPlugin",
    dependencies: [
        .package(url: "https://github.com/apple/swift-format.git", from: "0.50500.0"),
    ],
    targets: [
        .plugin(
            name: "MyFormatterPlugin",
            capability: .command(
                intent: .sourceCodeFormatting,
                permissions: [
                    .writeToPackageDirectory(reason: "This command reformats source files")
                ]
            ),
            dependencies: [
                .product(name: "swift-format", package: "swift-format"),
            ]
        ),
        // This is a sample target on which we can invoke the plugin.
        .target(
            name: "MyLibrary"
        )
    ]
)
