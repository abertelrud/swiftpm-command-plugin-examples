// swift-tools-version: 999.0
import PackageDescription

let package = Package(
    name: "MyDocCPlugin",
    products: [
        // Declaring the plugin product vends the plugin to clients of the package.
        .plugin(
            name: "MyDocCPlugin",
            targets: ["MyDocCPlugin"]
        ),
    ],
    targets: [
        // This is the actual target that implements the command plugin.
        .plugin(
            name: "MyDocCPlugin",
            capability: .command(
                intent: .documentationGeneration()
            )
        ),
        // This is a sample target on which we can invoke the plugin.
        .target(
            name: "MyLibrary"
        )
    ]
)
