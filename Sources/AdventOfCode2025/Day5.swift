//
//  Day5.swift
//  AdventOfCode
//
//  Created by Kamaal M Farah on 12/05/20.
//

import AdventOfCode
import Foundation
import KamaalExtensions

struct Day5: AdventOfCodeSolver {
    let day = 5
    let bundle: Bundle = .module

    func solvePart1(_ input: String?) async throws -> String {
        let (ranges, ids) = parseInput(input)

        return ids.reduce(0) { result, id in
            let isFresh = ranges.contains { range in
                id >= range.left && id <= range.right
            }
            if isFresh {
                return result + 1
            }
            return result
        }
        .string
    }

    func solvePart2(_ input: String?) async throws -> String {
        parseInput(input).ranges
            .sorted(by: \.left, using: .orderedAscending)
            .reduce([Pair<Int>]()) { mergedPairs, pair in
                if let lastMergedPair = mergedPairs.last, pair.left <= lastMergedPair.right {
                    let newRight = max(lastMergedPair.right, pair.right)
                    return mergedPairs.removedLast().appended(Pair(left: lastMergedPair.left, right: newRight))
                }

                return mergedPairs.appended(pair)
            }
            .reduce(0, { result, pair in result + pair.closedRangeCount })
            .string
    }

    private func parseInput(_ input: String?) -> (ranges: [Pair<Int>], list: [Int]) {
        let input = input ?? getInput()

        return input.splitLines
            .reduce((ranges: [Pair<Int>](), list: [Int]())) { result, line in
                let trimmed = line.trimmingByWhitespacesAndNewLines
                guard !trimmed.isEmpty else { return result }

                if trimmed.contains("-") {
                    let ids = trimmed.split(separator: "-").map(\.int!)
                    assert(ids.count == 2)
                    return (result.ranges.appended(Pair(left: ids[0], right: ids[1])), result.list)
                }

                return (result.ranges, result.list.appended(trimmed.int!))
            }
    }
}
