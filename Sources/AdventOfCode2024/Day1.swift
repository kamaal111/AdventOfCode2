//
//  Day1.swift
//  AdventOfCode2
//
//  Created by Kamaal M Farah on 11/26/25.
//

import Foundation
import AdventOfCode2

struct Day1: AdventOfCodeSolver {
    let day = 1
    let bundle: Bundle = .module

    func solvePart1(_ input: String?) async throws -> String {
        let input = try parseInput(input)
        let rights = input.right.sorted()
        let distances = input.left.sorted()
            .enumerated()
            .reduce(0) { result, enumeratedNumber in
                let (index, number) = enumeratedNumber
                let rightNumber = rights[index]
                return result + abs(number - rightNumber)
            }

        return String(distances)
    }

    func solvePart2(_ input: String?) async throws -> String {
        let input = try parseInput(input)
        let rightCounts = Counter(input.right)
        let similarity = input.left.reduce(0) { result, number in
            result + (number * rightCounts[number])
        }

        return String(similarity)
    }

    private func parseInput(_ input: String?) throws -> Pair<[Int]> {
        let input = if let input { input } else { try getInput() }
        var lefts: [Int] = []
        var rights: [Int] = []
        for line in input.split(whereSeparator: \.isNewline) {
            let numbers = line.split(whereSeparator: \.isWhitespace).map { Int($0)! }
            assert(numbers.count == 2)

            lefts.append(numbers[0])
            rights.append(numbers[1])
        }

        return Pair(left: lefts, right: rights)
    }
}
