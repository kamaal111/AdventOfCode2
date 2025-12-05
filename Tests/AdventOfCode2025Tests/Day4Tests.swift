//
//  Day4Tests.swift
//  AdventOfCode2
//
//  Created by Kamaal M Farah on 12/04/20.
//

import Testing
import AdventOfCode2

@testable import AdventOfCode2025

private let day4 = Day4()

@Test func `Day 4 Part 1 Example 1`() async throws {
    let example = """
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """

    let solution = try await day4.solvePart1(example)

    #expect(solution == "13")
}

@Test func `Day 4 Part 1`() async throws {
    let solution = try await day4.solvePart1(nil)

    #expect(solution == "1320")
}

@Test func `Day 4 Part 1 Example 1 is accessible by forklift`() async throws {
    let example = """
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """
    let grid = day4.parseInput(example)
    let cases: [(row: Int, column: Int, expected: Bool)] = [
        (0, 2, true),
        (1, 0, true),
        (1, 1, false),
        (1, 4, false),
    ]

    for (row, column, expected) in cases {
        let element = grid.get(row: row, column: column)!

        #expect(day4.isAccessibleByForklift(element: element, grid: grid) == expected)
    }
}

@Test func `Day 4 Part 2 Example 1`() async throws {
    let example = """
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """
    let solution = try await day4.solvePart2(example)

    #expect(solution == "43")
}

@Test func `Day 4 Part 2`() async throws {
    let solution = try await day4.solvePart2(nil)

    #expect(solution == "8354")
}
