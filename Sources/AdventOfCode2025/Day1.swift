//
//  Day1.swift
//  AdventOfCode2
//
//  Created by Kamaal M Farah on 12/01/20.
//

import AdventOfCode2
import Foundation

struct Day1: AdventOfCodeSolver {
    let day = 1
    let bundle: Bundle = .module

    private let start = 50

    func solvePart1(_ input: String?) async throws -> String {
        let rotations = parseInput(input)
        var dial = Dial(position: start)
        var zeroCounts = 0
        for rotation in rotations {
            dial.rotate(rotation: rotation)
            if dial.position == 0 {
                zeroCounts += 1
            }
        }

        return "\(zeroCounts)"
    }

    func solvePart2(_ input: String?) async throws -> String {
        let rotations = parseInput(input)
        var dial = Dial(position: start)
        var clicks = 0
        for rotation in rotations {
            clicks += dial.rotate(rotation: rotation)
        }

        return "\(clicks)"
    }

    struct Dial {
        private(set) var position: Int

        private let dialRange = 0..<100

        init(position: Int) {
            self.position = position
        }

        @discardableResult
        mutating func rotate(rotation: Rotation) -> Int {
            var clicks = 0
            var newPosition: Int
            let startedAtZero = position == 0
            switch rotation.direction {
            case .left:
                if startedAtZero {
                    clicks = rotation.distance / dialRange.upperBound
                } else if (position - rotation.distance) <= 0 {
                    let deficit = rotation.distance - position
                    clicks = 1 + (deficit / dialRange.upperBound)
                }
                newPosition = position - (rotation.distance % dialRange.upperBound)
                if newPosition < 0 {
                    newPosition += dialRange.upperBound
                }
            case .right:
                if startedAtZero {
                    clicks = rotation.distance / dialRange.upperBound
                } else if (position + rotation.distance) >= dialRange.upperBound {
                    clicks = (position + rotation.distance) / dialRange.upperBound
                }
                newPosition = position + (rotation.distance % dialRange.upperBound)
                if newPosition >= dialRange.upperBound {
                    newPosition %= dialRange.upperBound
                }
            }

            setPosition(newPosition)

            return clicks
        }

        mutating func setPosition(_ position: Int) {
            self.position = position
        }
    }

    private func parseInput(_ input: String?) -> [Rotation] {
        let input = input ?? getInput()

        return input.split(whereSeparator: \.isNewline)
            .map(Rotation.fromInputLine(_:))
    }

    struct Rotation {
        let direction: Direction
        let distance: Int

        init(direction: Direction, distance: Int) {
            self.direction = direction
            self.distance = distance
        }

        static func fromInputLine<S: StringProtocol>(_ line: S) -> Rotation {
            let distanceString = line[line.index(line.startIndex, offsetBy: 1)..<line.endIndex]
            let distance = Int(distanceString)!

            return .init(direction: .fromInput(line[line.startIndex]), distance: distance)
        }

        enum Direction {
            case left
            case right

            static func fromInput(_ input: Character) -> Direction {
                if input == "L" {
                    return .left
                }
                if input == "R" {
                    return .right
                }
                fatalError()
            }
        }
    }
}
