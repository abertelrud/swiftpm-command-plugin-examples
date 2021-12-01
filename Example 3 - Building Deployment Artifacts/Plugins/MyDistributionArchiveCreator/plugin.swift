import PackagePlugin
import Foundation

@main
struct MyDistributionArchiveCreator: CommandPlugin {
    func performCommand(
       context: PluginContext,
       targets: [Target],
       arguments: [String]
    ) throws {
        // Check that we were given the name of a product as the first argument
        // and the name of an archive as the second.
        guard arguments.count == 2 else {
            throw StringError("Expected two arguments: product name and archive name")
        }
        let productName = arguments[0]
        let archiveName = arguments[1]

        // Ask the plugin host (SwiftPM or an IDE) to build our product.
        let result = try packageManager.build(
            .product(productName),
            parameters: .init(configuration: .release, logging: .concise)
        )
        
        // Check the result. Ideally this would report more details.
        guard result.succeeded else { throw StringError("couldn't build product") }

        // Get the list of built executables from the build result.
        let builtExecutables = result.builtArtifacts.filter{ $0.kind == .executable }

        // Decide on the output path for the archive.
        let outputPath = context.pluginWorkDirectory.appending("\(archiveName).tar")

        // Use Foundation to run `tar`. The exact details of using the Foundation
        // API aren't relevant; the point is that the built artifacts can be used
        // by the script.
        let tarTool = try context.tool(named: "tar")
        let tarArgs = ["-czf", outputPath.string] + builtExecutables.map{ $0.path.string }
        let process = try Process.run(URL(fileURLWithPath: tarTool.path.string), arguments: tarArgs)
        process.waitUntilExit()

        // The plugin should also report errors from the creation of the archive.

        print("Created archive at \(outputPath).")
    }
}

/// Represents a string error.
public struct StringError: Equatable, Codable, CustomStringConvertible, Error {

    /// The description of the error.
    public let description: String

    /// Create an instance of StringError.
    public init(_ description: String) {
        self.description = description
    }
}
