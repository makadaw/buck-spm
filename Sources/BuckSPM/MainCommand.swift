// SPDX-License-Identifier: MIT
// Copyright © 2021 makadaw

import ArgumentParser

public struct BUCKSPMCommand: ParsableCommand {
    static public var configuration = CommandConfiguration(
        commandName: "buck-spm",
        abstract: "Connect SPM with BUCK",
        subcommands: [Fetch.self, Generate.self]
        )

    public init() {}
}
