// SPDX-License-Identifier: MIT
// Copyright © 2021 makadaw

import Workspace
import ArgumentParser

struct CompilerPath: ExpressibleByArgument {
    let path: String

    static func defaultSwiftCompiler() -> CompilerPath {
        let string: String
        #if os(macOS)
        string = try! Process.checkNonZeroExit(args: "xcrun", "--sdk", "macosx", "-f", "swiftc").spm_chomp()
        #else
        string = try! Process.checkNonZeroExit(args: "which", "swiftc").spm_chomp()
        #endif
        return CompilerPath(argument: string)!
    }

    init?(argument: String) {
        self.path = argument
    }

    func toAbsolutePath() -> AbsolutePath {
        AbsolutePath(path)
    }
}

protocol WorkspaceCommand {
    var swiftCompiler: CompilerPath? { get }
    var packagePath: String { get }
}

extension WorkspaceCommand {
    func buildWorkspace() throws -> Workspace {
        let packagePath = AbsolutePath(self.packagePath)

        let swiftCompiler = (self.swiftCompiler ?? CompilerPath.defaultSwiftCompiler()).toAbsolutePath()
        let resources = try UserManifestResources(swiftCompiler: swiftCompiler)
        let manifestLoader = ManifestLoader(manifestResources: resources)

        // Workspace use several private methods (eg: cache) that will require more work, lets just use it to keep
        // download state in order and copy checkouted artefacts
        return Workspace(
            dataPath: packagePath.appending(component: ".my-build"),
            editablesPath: packagePath.appending(component: "Packages"),
            pinsFile: packagePath.appending(component: "Package.resolved"),
            manifestLoader: manifestLoader,
            enableResolverTrace: true
        )
    }
}
