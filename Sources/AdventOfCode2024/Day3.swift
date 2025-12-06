//
//  Day3.swift
//  AdventOfCode
//
//  Created by Kamaal M Farah on 11/28/25.
//

import AdventOfCode
import Foundation
import RegexBuilder

@MainActor
struct Day3: AdventOfCodeSolver {
    let day = 3
    let bundle: Bundle = .module

    private let multiplicationRegex = Regex {
        "mul("
        Capture {
            OneOrMore(.digit)
        }
        ","
        Capture {
            OneOrMore(.digit)
        }
        ")"
    }
    private let doOrDontRegex = Regex {
        Capture {
            ChoiceOf {
                "do"
                "don't"
            }
        }
        "()"
    }

    func solvePart1(_ input: String?) async throws -> String {
        let multiplications = parseInput(input)
        let result = addUpMultiplications(multiplications)

        return "\(result)"
    }

    func solvePart2(_ input: String?) async throws -> String {
        let input = input ?? getInput()
        let multiplications = parseInput(input)
        let dontRanges = getDontRanges(input)
        let filteredMultiplications = multiplications.filter { multiplication in
            let isWithinDont = dontRanges.contains { dontRange in
                multiplication.start >= dontRange.start && multiplication.start < dontRange.end
            }

            return !isWithinDont
        }
        let result = addUpMultiplications(filteredMultiplications)

        return "\(result)"
    }

    private func addUpMultiplications(_ multiplications: [(pair: Pair<Int>, start: String.Index)]) -> Int {
        multiplications.reduce(0) { result, multiplication in
            result + (multiplication.pair.left * multiplication.pair.right)
        }
    }

    private func parseInput(_ input: String?) -> [(pair: Pair<Int>, start: String.Index)] {
        let input = input ?? getInput()

        return input.matches(of: multiplicationRegex)
            .map { match in
                let output = match.output
                let range = match.range

                return (Pair(left: Int(output.1)!, right: Int(output.2)!), range.lowerBound)
            }
    }

    private func getDontRanges(_ input: String) -> [(start: String.Index, end: String.Index)] {
        let dosAndDonts = input.matches(of: doOrDontRegex)
            .map { (end: $0.range.upperBound, doing: $0.output.1 == "do") }
        var dontRanges: [(start: String.Index, end: String.Index)] = []
        var doing = true
        var start: String.Index?
        for doAndDont in dosAndDonts {
            if doing && doAndDont.doing {
                continue
            }

            doing = doAndDont.doing
            if !doAndDont.doing {
                if start == nil {
                    start = doAndDont.end
                }
                continue
            }

            if doAndDont.doing {
                if let startIndex = start {
                    dontRanges.append((start: startIndex, end: doAndDont.end))
                    start = nil
                }
            }
        }

        assert(start == nil)

        return dontRanges
    }
}
