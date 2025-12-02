//
//  Day2Tests.swift
//  AdventOfCode2
//
//  Created by Kamaal M Farah on 12/02/20.
//

import Testing

@testable import AdventOfCode2025

private let day2 = Day2()

@Test func `Day 2 Part 1 Example 1`() async throws {
    let example = """
        11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
        1698522-1698528,446443-446449,38593856-38593862,565653-565659,
        824824821-824824827,2121212118-2121212124
        """
    let solution = try await day2.solvePart1(example)

    #expect(solution == "1227775554")
}

@Test func `Day 2 Part 1`() async throws {
    let solution = try await day2.solvePart1(nil)

    #expect(solution == "37314786486")
}

@Test func `Day 2 Part 2 Example 1`() async throws {
    let example = """
        11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
        1698522-1698528,446443-446449,38593856-38593862,565653-565659,
        824824821-824824827,2121212118-2121212124
        """
    let solution = try await day2.solvePart2(example)

    #expect(solution == "4174379265")
}

@Test func `Day 2 Part 2 Example 2`() async throws {
    let example = """
        11-22
        """
    let solution = try await day2.solvePart2(example)

    #expect(solution == "33")
}

@Test(.disabled("Brute forced solution that takes too long (41.466 seconds)"))
func `Day 2 Part 2`() async throws {
    let solution = try await day2.solvePart2(nil)

    #expect(solution == "47477053982")
}
