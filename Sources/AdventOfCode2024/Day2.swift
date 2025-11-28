//
//  Day2.swift
//  AdventOfCode2
//
//  Created by Kamaal M Farah on 11/28/20.
//

import Foundation
import AdventOfCode2

struct Day2: AdventOfCodeSolver {
    let day = 2
    let bundle: Bundle = .module

    func solvePart1(_ input: String?) async throws -> String {
        let input = try parseInput(input)
        let safeReports = input.reduce(0) { result, report in result + (reportIsSafe(report) ? 1 : 0) }

        return String(safeReports)
    }

    func solvePart2(_ input: String?) async throws -> String {
        let input = try parseInput(input)
        let safeReports = input.reduce(0) { result, report in
            if reportIsSafe(report) {
                return result + 1
            }

            let hasToleratedReport = (0..<report.count).contains { i in
                let potentionallyToleratedReport = Array(report[0 ..< i] + report[(i + 1) ..< report.count])
                return reportIsSafe(potentionallyToleratedReport)
            }

            return result + (hasToleratedReport ? 1 : 0)
        }

        return String(safeReports)
    }

    func reportIsSafe(_ report: [Int]) -> Bool {
        var previous: Int = report[0]
        var isIncreasing: Bool?
        for level in report[1 ..< report.count] {
            if isIncreasing == nil {
                if level > previous {
                    isIncreasing = true
                } else if level < previous {
                    isIncreasing = false
                } else {
                    return false
                }
            }

            let isIncreasingValue = isIncreasing!
            let delta = level - previous
            if isIncreasingValue {
                if delta < 1 || delta > 3 {
                    return false
                }
            } else {
                if delta > -1 || delta < -3 {
                    return false
                }
            }
            previous = level
        }

        return true
    }

    private func parseInput(_ input: String?) throws -> [[Int]] {
        let input = if let input { input } else { try getInput() }

        return input.split(whereSeparator: \.isNewline)
            .compactMap { line -> [Int]? in
                let parsed = line.split(whereSeparator: \.isWhitespace)
                    .compactMap { Int($0) }
                guard !parsed.isEmpty else { return nil }
                return parsed
            }
    }
}
