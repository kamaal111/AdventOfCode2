//
//  Day3Tests.swift
//  AdventOfCode2
//
//  Created by Kamaal M Farah on 12/03/20.
//

import Testing
@testable import AdventOfCode2025

private let day3 = Day3()

@Test func `Day 3 Part 1 Example 1`() async throws {
    let example = ""
    let solution = try await day3.solvePart1(example)

    #expect(solution == "")
}

@Test func `Day 3 Part 1`() async throws {
    let solution = try await day3.solvePart1(nil)

    #expect(solution == "")
}

@Test func `Day 3 Part 2 Example 1`() async throws {
    let example = ""
    let solution = try await day3.solvePart2(example)

    #expect(solution == "")
}

@Test func `Day 3 Part 2`() async throws {
    let solution = try await day3.solvePart2(nil)

    #expect(solution == "")
}
