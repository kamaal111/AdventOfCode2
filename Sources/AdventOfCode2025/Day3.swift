//
//  Day3.swift
//  AdventOfCode
//
//  Created by Kamaal M Farah on 12/03/25.
//

import AdventOfCode
import Foundation
import KamaalExtensions

struct Day3: AdventOfCodeSolver {
    let day = 3
    let bundle: Bundle = .module

    func solvePart1(_ input: String?) async throws -> String {
        parseInput(input).map(calculateJoltage(ofSize: 2))
            .sum(by: \.self)
            .string
    }

    func solvePart2(_ input: String?) async throws -> String {
        parseInput(input).map(calculateJoltage(ofSize: 12))
            .sum(by: \.self)
            .string
    }

    func calculateJoltage(ofSize size: Int) -> (_ bank: [Int]) -> Int {
        assert(size > 0)

        return { bank in
            var highestLeftIndex = 0
            for (i, battery) in bank[1..<(bank.count - 1)].enumerated() {
                let index = i + 1
                let highestBattery = bank[highestLeftIndex]
                if battery > highestBattery {
                    highestLeftIndex = index
                }
            }
            var highestLeft = bank[highestLeftIndex + 1]
            for battery in bank[(highestLeftIndex + 2)..<bank.count] {
                if battery > highestLeft {
                    highestLeft = battery
                }
            }

            return Int("\(bank[highestLeftIndex])\(highestLeft)")!
        }
    }

    private func parseInput(_ input: String?) -> [[Int]] {
        let input = input ?? getInput()

        return input.splitLines.map { $0.split(separator: "").map(\.int!) }
    }
}
