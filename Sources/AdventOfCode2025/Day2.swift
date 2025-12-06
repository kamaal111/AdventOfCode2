//
//  Day2.swift
//  AdventOfCode
//
//  Created by Kamaal M Farah on 12/02/25.
//

import AdventOfCode
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
        id.closedRange.reduce(0) { result, value in
            assert(value > 9)
            let valueString = value.string
            let isOfEvenCharacters = valueString.count % 2 == 0
            let isInvalid = (1..<valueString.count).contains {
                guard (isOfEvenCharacters && ($0 % 1) == 0) || !isOfEvenCharacters else { return false }

                let chunks = valueString.chunked($0, includeRemainder: true)
                assert(chunks.count > 1)
                let firstChunk = chunks.first!
                guard firstChunk.count == chunks.last!.count else { return false }

                return chunks.dropFirst()
                    .allSatisfy { $0 == firstChunk }
            }
            if isInvalid {
                return result + value
            }

            return result
        }
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
