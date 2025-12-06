//
//  Day5Tests.swift
//  AdventOfCode
//
//  Created by Kamaal M Farah on 12/05/20.
//

import Testing
import KamaalExtensions

@testable import AdventOfCode2025

private let day5 = Day5()

@Test func `Day 5 Part 1 Example 1`() async throws {
    let example = """
        3-5
        10-14
        16-20
        12-18

        1
        5
        8
        11
        17
        32
        """

    let solution = try await day5.solvePart1(example)

    #expect(solution == "3")
}

@Test func `Day 5 Part 1`() async throws {
    let solution = try await day5.solvePart1(nil)

    #expect(solution == "862")
}

@Test func `Day 5 Part 2 Example 1`() async throws {
    let example = """
        3-5
        10-14
        16-20
        12-18

        1
        5
        8
        11
        17
        32
        """

    let solution = try await day5.solvePart2(example)

    #expect(solution == "14")
}

@Test func `Day 5 Part 2`() async throws {
    let solution = try await day5.solvePart2(nil).int!

    #expect(solution > 331_874_390_115_074)
    #expect(solution > 349_978_322_801_186)
    #expect(solution == 357_907_198_933_892)
}
