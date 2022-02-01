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
            throw "Expected two arguments: product name and archive name"
        }
        let productName = arguments[0]
        let archiveName = arguments[1]

        // Ask the plugin host (SwiftPM or an IDE) to build our product.
        let result = try packageManager.build(
            .product(productName),
            parameters: .init(configuration: .release, logging: .concise)
        )
        
        // Check the result. Ideally this would report more details.
        guard result.succeeded else { throw "couldn't build product" }

        // Get the list of built executables from the build result.
        let builtExecutables = result.builtArtifacts.filter{ $0.kind == .executable }

        // Decide on the output path for the archive.
        let outputPath = context.pluginWorkDirectory.appending("\(archiveName).zip")

        // Use Foundation to run `zip`. The exact details of using the Foundation
        // API aren't relevant; the point is that the built artifacts can be used
        // by the script.
        let zipTool = try context.tool(named: "zip")
        let zipArgs = ["-j", outputPath.string] + builtExecutables.map{ $0.path.string }
        let zipToolURL = URL(fileURLWithPath: zipTool.path.string)
        let process = try Process.run(zipToolURL, arguments: zipArgs)
        process.waitUntilExit()

        // Check whether the subprocess invocation was successful.
        if process.terminationReason == .exit && process.terminationStatus == 0 {
            print("Created distribution archive at \(outputPath).")
        }
        else {
            let problem = "\(process.terminationReason):\(process.terminationStatus)"
            Diagnostics.error("zip invocation failed: \(problem)")
        }
    }

    /// Bridging implementation of new method to call the old one.
    func performCommand(
        context: PluginContext,
        arguments: [String]
    ) throws {
        // Extract the target arguments and pass them on to the old method.
        var argExtractor = ArgumentExtractor(arguments)
        let targetNames = argExtractor.extractOption(named: "target")
        let targets = targetNames.isEmpty
            ? context.package.targets
            : try context.package.targets(named: targetNames)
        try self.performCommand(context: context, targets: targets, arguments: arguments)
    }
}

extension String: Error { }
