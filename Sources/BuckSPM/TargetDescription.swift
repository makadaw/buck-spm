// SPDX-License-Identifier: MIT
// Copyright © 2021 makadaw

import PackageModel
import Workspace

public struct TargetDescription {
    let target: PackageModel.ResolvedTarget

    let name: String
    let srcs: [String]
    let exportedHeaders: String?
    let deps: [String]
    let preprocessorFlags: [String]?

    static func from(target: PackageModel.ResolvedTarget, resolvePath: AbsolutePath) -> TargetDescription {

        let srcs = target.sources.paths.map { $0.relative(to: resolvePath).pathString }
        let deps = target.dependencies.compactMap({ $0.target }).map({ $0.name })

        let exportedHeaders: String?
        switch target.underlyingTarget {
        case is ClangTarget:
            // In SPM there are can be only one public headers path
            exportedHeaders = (target.underlyingTarget as! ClangTarget).includeDir.relative(to: resolvePath).pathString.appending("/**/*.h")
        case is SwiftTarget:
            exportedHeaders = nil
        default:
            fatalError("Unsuported target")
        }

        var preprocessorFlags = [String]()
        if let headerSearchPath = target.underlyingTarget.buildSettings.assignments[.HEADER_SEARCH_PATHS]?.first?.value {
            preprocessorFlags.append(headerSearchPath.map({ "-I\($0)" }).joined(separator: ","))
        }

        return Self.init(target: target,
                         name: target.name,
                         srcs: srcs,
                         exportedHeaders: exportedHeaders,
                         deps: deps,
                         preprocessorFlags: preprocessorFlags.isEmpty ? nil : preprocessorFlags)
    }
}
