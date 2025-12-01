//
//  Day1Tests.swift
//  AdventOfCode2
//
//  Created by Kamaal M Farah on 12/01/20.
//

import Testing

@testable import AdventOfCode2025

private let day1 = Day1()

@Test func `Day 1 Part 1 Example 1`() async throws {
    let example = """
        L68
        L30
        R48
        L5
        R60
        L55
        L1
        L99
        R14
        L82
        """
    let solution = try await day1.solvePart1(example)

    #expect(solution == "3")
}

@Test func `Day 1 Part 1 Dail 1`() async throws {
    let cases: [(rotation: Day1.Rotation, expected: Int)] = [
        (.init(direction: .left, distance: 68), 82),
        (.init(direction: .left, distance: 30), 52),
        (.init(direction: .right, distance: 48), 0),
        (.init(direction: .left, distance: 5), 95),
        (.init(direction: .right, distance: 60), 55),
        (.init(direction: .left, distance: 55), 0),
        (.init(direction: .left, distance: 1), 99),
        (.init(direction: .left, distance: 99), 0),
        (.init(direction: .right, distance: 14), 14),
        (.init(direction: .left, distance: 82), 32),
    ]
    var dail = Day1.Dial(position: 50)
    for (rotation, expected) in cases {
        _ = dail.rotate(rotation: rotation)
        #expect(dail.position == expected)
    }
    #expect(dail.position == 32)
}

@Test func `Day 1 Part 1`() async throws {
    let solution = try await day1.solvePart1(nil)

    #expect(solution != "68")
    #expect(solution != "75")
    #expect(solution != "56")
    #expect(solution == "1147")
}

@Test func `Day 1 Part 2 Example 1`() async throws {
    let example = """
        L68
        L30
        R48
        L5
        R60
        L55
        L1
        L99
        R14
        L82
        """
    let solution = try await day1.solvePart2(example)

    #expect(solution == "6")
}

@Test func `Day 1 Part 2`() async throws {
    let rawSolution = try await day1.solvePart2(nil)
    let solution = try #require(Int(rawSolution))

    #expect(solution != 2349)
    #expect(solution > 2679)
    #expect(solution > 2788)
    #expect(solution != 5669)
    #expect(solution == 6789)
}

@Test func `Day 1 Part 2 Dail 1`() async throws {
    let cases: [(rotation: Day1.Rotation, clicks: Int)] = [
        (.init(direction: .left, distance: 68), 1),
        (.init(direction: .left, distance: 30), 0),
        (.init(direction: .right, distance: 48), 1),
        (.init(direction: .left, distance: 5), 0),
        (.init(direction: .right, distance: 60), 1),
        (.init(direction: .left, distance: 55), 1),
        (.init(direction: .left, distance: 1), 0),
        (.init(direction: .left, distance: 99), 1),
        (.init(direction: .right, distance: 14), 0),
        (.init(direction: .left, distance: 82), 1),
    ]
    var dail = Day1.Dial(position: 50)
    for (rotation, expectedClicks) in cases {
        let clicks = dail.rotate(rotation: rotation)
        #expect(clicks == expectedClicks)
    }
}
