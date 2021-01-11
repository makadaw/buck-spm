// SPDX-License-Identifier: MIT
// Copyright © 2021 makadaw

import ArgumentParser
import Workspace

struct Fetch: ParsableCommand, WorkspaceCommand {
    static var configuration = CommandConfiguration(
        commandName: "fetch",
        abstract: "Fetch dependencies and copy to destination"
        )

    @Option var swiftCompiler: CompilerPath?

    @Option var packagePath: String

    func run() throws {
        let packagePath = AbsolutePath(self.packagePath)
        let workspace = try buildWorkspace()

        // Download dependencies. TODO: Check here do we need to redownload everything
        let diagnostics = DiagnosticsEngine()
        workspace.updateDependencies(root: PackageGraphRootInput(packages: [packagePath]), diagnostics: diagnostics)

        // Copy checkouts
        let destination = packagePath.appending(component: "Packages")
        try localFileSystem.removeFileTree(destination)
        try localFileSystem.copy(from: workspace.checkoutsPath, to: destination)
        print("Done")
    }
}
