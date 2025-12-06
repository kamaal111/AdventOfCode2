//
//  Day6.swift
//  AdventOfCode
//
//  Created by Kamaal M Farah on 12/06/25.
//

import AdventOfCode
import Foundation
import KamaalExtensions

struct Day6: AdventOfCodeSolver {
    let day = 6
    let bundle: Bundle = .module

    func solvePart1(_ input: String?) async throws -> String {
        let (numberRows, operations) = parseInput(input)

        return operations.enumerated()
            .map { i, operation in
                var numbers: [Int] = []
                for numberRow in numberRows {
                    numbers.append(numberRow[i].number)
                }
                return Formula(numbers: numbers, operation: operation)
            }
            .reduce(0) { result, formula in result + formula.calculate() }
            .string
    }

    func solvePart2(_ input: String?) async throws -> String {
        let (numberRows, operations) = parseInput(input)

        return operations.enumerated()
            .map { i, operation in
                var groupedNumbers: [Int: [Int]] = [:]
                for numberRow in numberRows {
                    let number = numberRow[i]
                    for (j, paddedNumber) in number.getPaddedNumber().enumerated() {
                        if paddedNumber.isNumber {
                            groupedNumbers[j, default: []].append(paddedNumber.int!)
                        }
                    }
                }
                let numbers = groupedNumbers.values
                    .map { $0.map(\.string).joined(separator: "").int! }

                return Formula(numbers: numbers, operation: operation)
            }
            .reduce(0) { result, formula in result + formula.calculate() }
            .string
    }

    private func parseInput(_ input: String?) -> (numberRows: [[NumberItem]], operations: [Operations]) {
        let input = input ?? getInput()
        let lines = input.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
        let numberRows = lines.reduce([[NumberItem]]()) { result, line in
            var i = 0
            let splitten = line.components(separatedBy: " ")
            let maybeNumbers = splitten.compactMap { char -> NumberItem? in
                guard let number = Int(String(char)) else { return nil }
                let position = i % splitten.count
                i += 1
                return NumberItem(number: number, line: line, position: position)
            }
            guard !maybeNumbers.isEmpty else { return result }
            return result.appended(maybeNumbers)
        }
        let operations = lines.reversed()
            .first { !$0.trimmingByWhitespacesAndNewLines.isEmpty }!
            .split(whereSeparator: \.isWhitespace)
            .map(Operations.fromStringSubsequence)
        assert(!operations.isEmpty)
        assert(!numberRows.isEmpty)
        assert(operations.count == numberRows.first?.count)
        assert(numberRows.dropFirst().allSatisfy { $0.count == operations.count })

        return (numberRows, operations)
    }

    private struct NumberItem: Hashable {
        let number: Int
        let line: String.SubSequence
        let position: Int

        func getPaddedNumber() -> String {
            var cursor = 0
            let sequence = line.split(separator: "")
                .enumerated()
                .map { (index: $0, number: $1.int) }
            var isSearching = true
            var buffer: [String] = []
            var startIndex: Int?
            for (i, subsequence) in sequence {
                guard cursor <= position else { break }
                guard !(isSearching && subsequence == nil) else { continue }
                guard let subsequence else {
                    isSearching = true
                    cursor += 1
                    continue
                }

                isSearching = false
                if cursor == position {
                    if startIndex == nil {
                        startIndex = i
                    }
                    buffer.append(subsequence.string)
                }
            }

            guard let startIndex else { fatalError() }

            assert(!buffer.isEmpty)
            assert(buffer.joined(separator: "").int == number)

            let rightPaddingSize = line.count - (startIndex + buffer.count)
            let rightPadding = String(Array(repeating: "x", count: rightPaddingSize))
            let leftPadding = String(Array(repeating: "x", count: line.count - (rightPaddingSize + buffer.count)))
            let paddedNumber = leftPadding + buffer.joined(separator: "") + rightPadding

            assert(paddedNumber.count == line.count)

            return paddedNumber
        }
    }

    private struct Formula {
        let numbers: [Int]
        let operation: Operations

        func calculate() -> Int {
            let start =
                switch operation {
                case .addition: 0
                case .multiplication: 1
                }
            return numbers.reduce(start) { result, number in
                switch operation {
                case .addition: result + number
                case .multiplication: result * number
                }
            }
        }
    }

    private enum Operations: Character {
        case addition = "+"
        case multiplication = "*"

        static func fromStringSubsequence(_ subsequence: Substring.SubSequence) -> Self {
            let char = Character(String(subsequence))
            return Operations(rawValue: char)!
        }
    }
}
