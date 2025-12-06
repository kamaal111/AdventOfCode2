//
//  Day4.swift
//  AdventOfCode
//
//  Created by Kamaal M Farah on 12/04/25.
//

import AdventOfCode
import Foundation
import KamaalExtensions

struct Day4: AdventOfCodeSolver {
    let day = 4
    let bundle: Bundle = .module

    func solvePart1(_ input: String?) async throws -> String {
        let grid = parseInput(input)
        let newCells = grid.map { element -> Cell in
            if isAccessibleByForklift(element: element, grid: grid) {
                return .forkliftRoute
            }
            return element.value
        }
        let newGrid = Matrix(array: newCells, width: grid.width)

        return newGrid.counter[.forkliftRoute].string
    }

    func solvePart2(_ input: String?) async throws -> String {
        var grid = parseInput(input)
        var totalRollsRemoved = 0
        while true {
            let newCells = grid.map { element -> Cell in
                if isAccessibleByForklift(element: element, grid: grid) {
                    return .forkliftRoute
                }
                return element.value
            }
            let newGrid = Matrix(array: newCells, width: grid.width)
            let rollsRemoved = newGrid.counter[.forkliftRoute]
            if rollsRemoved == 0 {
                break
            }

            totalRollsRemoved += rollsRemoved
            let removedRollsCells = newGrid.map { element -> Cell in
                guard element.value == .forkliftRoute else { return element.value }
                return .empty
            }
            grid = Matrix(array: removedRollsCells, width: grid.width)
        }

        return totalRollsRemoved.string
    }

    func isAccessibleByForklift(element: Matrix<Cell>.Element, grid: Matrix<Cell>) -> Bool {
        guard element.value == .roll else { return false }

        var rollNeighborsCount = 0
        let neighbors = grid.neighbors(of: element)
        for neighbor in neighbors {
            if neighbor.value == .roll {
                if rollNeighborsCount >= 3 {
                    return false
                }
                rollNeighborsCount += 1
            }
        }

        return rollNeighborsCount < 4
    }

    func parseInput(_ input: String?) -> Matrix<Cell> {
        let input = input ?? getInput()
        let lines = input.splitLines
        let cells = lines.map { $0.map { Cell(rawValue: $0)! } }

        return Matrix(chunks: cells)
    }

    enum Cell: Character {
        case roll = "@"
        case forkliftRoute = "x"
        case empty = "."
    }
}
