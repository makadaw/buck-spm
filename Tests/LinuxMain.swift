// SPDX-License-Identifier: MIT
// Copyright © 2021 makadaw

import XCTest

import buck_spmTests

var tests = [XCTestCaseEntry]()
tests += buck_spmTests.allTests()
XCTMain(tests)
