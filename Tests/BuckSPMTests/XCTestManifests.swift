// SPDX-License-Identifier: MIT
// Copyright © 2021 makadaw

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(buck_spmTests.allTests),
    ]
}
#endif
