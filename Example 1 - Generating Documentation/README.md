# Example 1 - Generating Documentation

This example command plugin uses the `docc` tool to generate documentation for one or more targets in a package. It expects the `docc` executable to be in the toolchain.

To invoke it, use:

```shell
swift package plugin --target MyLibrary generate-documentation
```

from this directory (or use the `--package-path` option if invoking from a different directory).
