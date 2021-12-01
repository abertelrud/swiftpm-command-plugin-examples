# Example 3 - Building Deployment Artifacts

This example command plugin does a release build of an executable product in the package, and then creates a `.tar` archive from the built artifacts. It shows how command arguments can be accessed in the plugin.

To invoke it, use:

```shell
swift package plugin create-distribution-archive MyExec Distro.tar
```

from this directory (or use the `--package-path` option if invoking from a different directory).
