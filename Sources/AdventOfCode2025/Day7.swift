//
//  Day7.swift
//  AdventOfCode
//
//  Created by Kamaal M Farah on 12/07/25.
//

import AdventOfCode
import Foundation
import KamaalExtensions

struct Day7: AdventOfCodeSolver {
    let day = 7
    let bundle: Bundle = .module

    func solvePart1(_ input: String?) async throws -> String {
        let teleporter = parseInput(input)

        return countSplits(in: teleporter).string
    }

    func solvePart2(_ input: String?) async throws -> String {
        let teleporter = parseInput(input)
        let timelines = getTimelines(in: teleporter)

        return timelines.values
            .asArray()
            .sum(by: \.self)
            .string
    }

    private func getTimelines(in teleporter: Matrix<Cell>) -> [Matrix<Cell>.Element: Int] {
        let start = teleporter.find(by: \.value, is: .start)!
        var pathCount = [start: 1]
        traverse(in: teleporter) { next, beam in
            guard let count = pathCount[beam] else { fatalError("Weird") }

            pathCount[beam] = nil

            switch next.value {
            case .empty:
                pathCount[next, default: 0] += count
            case .splitter:
                if let left = teleporter.get(row: next.row, column: next.column - 1) {
                    pathCount[left, default: 0] += count
                }
                if let right = teleporter.get(row: next.row, column: next.column + 1) {
                    pathCount[right, default: 0] += count
                }
            case .beam: break
            case .start: fatalError("Weird")
            }
        }

        return pathCount
    }

    private func traverse(
        in teleporter: Matrix<Cell>, onNext: (_ next: Matrix<Day7.Cell>.Element, _ beam: Matrix<Cell>.Element) -> Void
    ) {
        var currentBeams = Set([teleporter.find(by: \.value, is: .start)!])
        while true {
            var newSetOfBeams = Set<Matrix<Cell>.Element>()
            for beam in currentBeams {
                guard let next = teleporter.get(row: beam.row + 1, column: beam.column) else { break }

                onNext(next, beam)
                switch next.value {
                case .empty:
                    newSetOfBeams.insert(next)
                case .splitter:
                    if let left = teleporter.get(row: next.row, column: next.column - 1) {
                        newSetOfBeams.insert(left)
                    }
                    if let right = teleporter.get(row: next.row, column: next.column + 1) {
                        newSetOfBeams.insert(right)
                    }
                case .beam: break
                case .start: fatalError("Weird")
                }
            }

            guard !newSetOfBeams.isEmpty else { break }

            currentBeams = newSetOfBeams
        }
    }

    private func countSplits(in teleporter: Matrix<Cell>) -> Int {
        var splitted = 0
        traverse(in: teleporter) { next, _ in
            switch next.value {
            case .splitter: splitted += 1
            case .beam, .empty: break
            case .start: fatalError("Weird")
            }
        }

        return splitted
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
