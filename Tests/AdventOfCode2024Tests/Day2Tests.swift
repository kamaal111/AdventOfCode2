//
//  Day2Tests.swift
//  AdventOfCode2
//
//  Created by Kamaal M Farah on 11/28/20.
//

import Testing
@testable import AdventOfCode2024

private let day2 = Day2()

@Test func `Day 2 Part 1 Example 1`() async throws {
    let example = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """
    let solution = try await day2.solvePart1(example)

    #expect(solution == "2")
}

@Test
func `Day 2 Part 1 Example 1 report is safe`() async throws {
    let reports = [
        [7, 6, 4, 2, 1],
        [1, 3, 6, 7, 9],
    ]
    for report in reports {
        #expect(day2.reportIsSafe(report))
    }
}

@Test
func `Day 2 Part 1 Example 1 report is not safe`() async throws {
    let reports = [
        [1, 2, 7, 8, 9],
        [9, 7, 6, 2, 1],
        [1, 3, 2, 4, 5],
        [8, 6, 4, 4, 1],
    ]
    for report in reports {
        #expect(!day2.reportIsSafe(report))
    }
}

@Test func `Day 2 Part 1`() async throws {
    let solution = try await day2.solvePart1(nil)

    #expect(solution == "670")
}

@Test func `Day 2 Part 2 Example 1`() async throws {
    let example = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """
    let solution = try await day2.solvePart2(example)

    #expect(solution == "4")
}

@Test func `Day 2 Part 2`() async throws {
    let solution = try await day2.solvePart2(nil)

    #expect(solution == "700")
}
