//
//  Day2.swift
//  AdventOfCode2
//
//  Created by Kamaal M Farah on 12/02/20.
//

import AdventOfCode2
import Foundation
import KamaalExtensions

struct Day2: AdventOfCodeSolver {
    let day = 2
    let bundle: Bundle = .module

    func solvePart1(_ input: String?) async throws -> String {
        parseInput(input).map(duplicatedInvalidIdSum)
            .sum(by: \.self)
            .string
    }

    func solvePart2(_ input: String?) async throws -> String {
        parseInput(input).map(invalidIdSum)
            .sum(by: \.self)
            .string
    }

    private func invalidIdSum(_ id: Pair<Int>) -> Int {
        var invalidIdSum = 0
        for value in id.closedRange {
            guard value > 9 else { continue }

            let valueString = value.string
            inner: for i in 1..<(valueString.count + 1) {
                let chunks = valueString.chunked(i, includeRemainder: true)
                guard chunks.count > 1 else { continue }
                let firstChunk = chunks.first!
                guard firstChunk.count == chunks.last!.count else { continue }

                let isInvalid = chunks[1..<chunks.count].allSatisfy { $0 == firstChunk }
                if isInvalid {
                    invalidIdSum += value
                    break inner
                }
            }
        }

        return invalidIdSum
    }

    private func duplicatedInvalidIdSum(_ id: Pair<Int>) -> Int {
        var invalidIdSum = 0
        for value in id.closedRange {
            let valueString = value.string
            guard valueString.count % 2 == 0 else { continue }

            let firstHalf = valueString[
                valueString.startIndex..<valueString.index(valueString.startIndex, offsetBy: valueString.count / 2)]
            let secondHalf = valueString[
                valueString.index(
                    valueString.startIndex, offsetBy: valueString.count / 2)..<valueString.endIndex]
            if firstHalf == secondHalf {
                invalidIdSum += value
            }
        }

        return invalidIdSum
    }

    private func parseInput(_ input: String?) -> [Pair<Int>] {
        let input = input ?? getInput()

        return input.splitCommas
            .compactMap { range -> Pair<Int>? in
                let ids = range.split(separator: "-").map { $0.trimmingByWhitespacesAndNewLines.int! }
                assert(ids.count == 2)

                return Pair(left: ids[0], right: ids[1])
            }
    }
}
