# Example 2 - Formatting Source Code

This example command plugin uses the https://github.com/apple/swift-format.git package to reformat source code. It is an example of a plugin that needs additional permissions (in this case to write to the file system). For sample purposes, the formatting instructions are taken from a `.swift-format.json` file in the top-level directory of the package.

To invoke it, use:

```shell
swift package plugin --target MyLibrary format-source-code
```

from this directory (or use the `--package-path` option if invoking from a different directory).
