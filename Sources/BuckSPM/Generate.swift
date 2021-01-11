// SPDX-License-Identifier: MIT
// Copyright © 2021 makadaw

import ArgumentParser
import Workspace

struct Generate: ParsableCommand, WorkspaceCommand {
    @Option var swiftCompiler: CompilerPath?

    @Option var packagePath: String

    @Option var target: String

    @Option var templatePath: String?

    func run() throws {
        let packagePath = AbsolutePath(self.packagePath)
        let workspace = try buildWorkspace()

        // Get a graph
        let diagnostics = DiagnosticsEngine()
        let graph = workspace.loadPackageGraph(root: packagePath, diagnostics: diagnostics)

        // Get root target
        guard let root = graph.rootPackages.first(where: { $0.name == target })?.targets.first else {
            print("Can't find \(target) in root packages")
            throw ExitCode.failure
        }

        // Flatten root depepndencies
        // TODO use dependencies with platform and configuration
//        root.recursiveDependencies(satisfying: .init(platform: .iOS, configuration: .debug))
        let targets = root.recursiveTargetDependencies().map {
            TargetDescription.from(target: $0, resolvePath: workspace.checkoutsPath)
        }

        let renderer = Renderer(templatePath: templatePath)
        let content = try renderer.render(targets: targets)
        print(content)

        try localFileSystem.writeIfChanged(path: packagePath.appending(component: "Packages").appending(component: "BUCK"),
                                           bytes: ByteString(content.utf8))
        print("Done")
    }
}
