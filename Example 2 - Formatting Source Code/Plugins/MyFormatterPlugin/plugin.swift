import PackagePlugin
import Foundation

@main
struct MyFormatterPlugin: CommandPlugin {
    func performCommand(
        context: PluginContext,
        targets: [Target],
        arguments: [String]
    ) throws {
        // We'll be invoking `swift-format`, so start by locating it.
        let swiftFormatTool = try context.tool(named: "swiftformat")

        // By convention, use a configuration file in the package directory.
        let configFile = context.package.directory.appending(".swiftformat")

        // Iterate over the targets we've been asked to format.
        for target in targets {
            // Skip any type of target that doesn't have source files.
            // Note: We could choose to instead emit a warning or error here.
            guard let target = target as? SourceModuleTarget else { continue }

            // Invoke `swift-format` on the target directory, passing a configuration
            // file from the package directory.
            let swiftFormatExec = URL(fileURLWithPath: swiftFormatTool.path.string)
            let swiftFormatArgs = [
                "--config", "\(configFile)",
                "--cache", "\(context.pluginWorkDirectory)",
                "\(target.directory)"
            ]
            let process = try Process.run(swiftFormatExec, arguments: swiftFormatArgs)
            process.waitUntilExit()

            // Check whether the subprocess invocation was successful.
            if process.terminationReason == .exit && process.terminationStatus == 0 {
                print("Formatted the source code in \(target.directory).")
            }
            else {
                let problem = "\(process.terminationReason):\(process.terminationStatus)"
                Diagnostics.error("swiftformat invocation failed: \(problem)")
            }
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
