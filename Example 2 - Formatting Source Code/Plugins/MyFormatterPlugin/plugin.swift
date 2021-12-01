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
        let swiftFormatTool = try context.tool(named: "swift-format")

        // By convention, use a configuration file in the package directory.
        let configFile = context.package.directory.appending(".swift-format.json")

        // Iterate over the targets we've been asked to format.
        for target in targets {
            // Skip any type of target that doesn't have source files.
            // Note: We could choose to instead emit a warning or error here.
            guard let target = target as? SourceModuleTarget else { continue }

            // Invoke `swift-format` on the target directory, passing a configuration
            // file from the package directory.
            let swiftFormatExec = URL(fileURLWithPath: swiftFormatTool.path.string)
            let swiftFormatArgs = [
                "--configuration", "\(configFile)",
                "--in-place",
                "--recursive",
                "\(target.directory)"
            ]
            let process = try Process.run(swiftFormatExec, arguments: swiftFormatArgs)
            process.waitUntilExit()

            // The plugin should also report non-zero exit codes from `swift-format` here.

            print("Formatted the source code in \(target.directory).")
        }
    }
}
