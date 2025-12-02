//
//  Pair.swift
//  AdventOfCode2
//
//  Created by Kamaal M Farah on 11/27/25.
//

package struct Pair<T> {
    package let left: T
    package let right: T

    package init(left: T, right: T) {
        self.left = left
        self.right = right
    }

    package var array: [T] {
        [left, right]
    }
}

extension Pair where T: Comparable {
    package var range: Range<T> {
        left..<right
    }

    package var closedRange: ClosedRange<T> {
        left...right
    }
}
