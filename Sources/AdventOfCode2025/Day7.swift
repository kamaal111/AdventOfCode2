//
//  Day7.swift
//  AdventOfCode
//
//  Created by Kamaal M Farah on 12/07/25.
//

import Foundation
import AdventOfCode
import KamaalExtensions

struct Day7: AdventOfCodeSolver {
    let day = 7
    let bundle: Bundle = .module

    func solvePart1(_ input: String?) async throws -> String {
        var teleporter = parseInput(input)
        var currentBeams = Set([teleporter.find(by: \.value, is: .start)!])
        var splitted = 0
        while true {
            var newSetOfBeams = Set<Matrix<Cell>.Element>()
            for beam in currentBeams {
                guard let next = teleporter.get(row: beam.row + 1, column: beam.column) else { break }

                switch next.value {
                case .empty:
                    teleporter = teleporter.set(element: next, value: .beam)
                    newSetOfBeams.insert(next)
                case .splitter:
                    if let left = teleporter.get(row: next.row, column: next.column - 1) {
                        newSetOfBeams.insert(left)
                    }
                    if let right = teleporter.get(row: next.row, column: next.column + 1) {
                        newSetOfBeams.insert(right)
                    }
                    splitted += 1
                case .beam: break
                case .start: fatalError("Weird")
                }
            }

            guard !newSetOfBeams.isEmpty else { break }

            currentBeams = newSetOfBeams
        }

        return splitted.string
    }

    func solvePart2(_ input: String?) async throws -> String {
        "0"
    }

    private func parseInput(_ input: String?) -> Matrix<Cell> {
        let input = input ?? getInput()
        let chunks = input.splitLines
            .map { $0.split(separator: "").map(Cell.fromString) }

        return Matrix(chunks: chunks)
    }

    private enum Cell: Character {
        case start = "S"
        case splitter = "^"
        case beam = "|"
        case empty = "."

        static func fromString<S: StringProtocol>(_ string: S) -> Cell {
            Cell(rawValue: Character(String(string)))!
        }
    }
}
