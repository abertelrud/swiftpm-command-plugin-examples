// swift-tools-version: 999.0
import PackageDescription

let package = Package(
    name: "MyExecutable",
    products: [
        .executable(name: "MyExec", targets: ["MyExec"])
    ],
    targets: [
        // This is the hypothetical executable we want to distribute.
        .executableTarget(
            name: "MyExec"
        ),
        // This is the plugin that defines a custom command to distribute the executable.
        .plugin(
            name: "MyDistributionArchiveCreator",
            capability: .command(
                intent: .custom(
                    verb: "create-distribution-archive",
                    description: "Creates a .zip containing release builds of products"
                )
            )
        )
    ]
)
