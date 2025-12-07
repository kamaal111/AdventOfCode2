//
//  Matrix.swift
//  AdventOfCode
//
//  Created by Kamaal M Farah on 11/29/25.
//

import KamaalExtensions

package struct Matrix<T: Hashable>: Sequence, CustomStringConvertible {
    private let elements: [[Element]]

    package var description: String {
        elements.map { row in row.map { "\($0.value)" }.joined() }.joined(separator: "\n")
    }

    package init(elements: [[Element]]) {
        assert(elements.dropFirst().allSatisfy { $0.count == elements.first?.count ?? 0 })
        self.elements = elements
    }

    package init(chunks: [[T]]) {
        let elements = chunks.enumerated()
            .map { x, items in
                items.enumerated()
                    .map { y, value in Element(value: value, row: x, column: y) }
            }
        self.init(elements: elements)
    }

    package init(array: [T], width: Int) {
        let elements = array.chunked(width, includeRemainder: true)
        self.init(chunks: elements)
    }

    package var height: Int {
        elements.count
    }

    package var width: Int {
        elements.first?.count ?? 0
    }

    package var counter: Counter<T> {
        Counter(map(\.value))
    }

    package subscript(row: Int, column: Int) -> Element? {
        return get(row: row, column: column)
    }

    package func get(row: Int, column: Int) -> Element? {
        guard row >= 0 else { return nil }
        guard row < height else { return nil }
        guard column >= 0 else { return nil }
        guard column < width else { return nil }

        return elements[row][column]
    }

    package func set(row: Int, column: Int, value: T) -> Self {
        var newElements = elements
        newElements[row][column] = Element(value: value, row: row, column: column)

        return Matrix(elements: newElements)
    }

    package func set(element: Element, value: T) -> Self {
        set(row: element.row, column: element.column, value: value)
    }

    @discardableResult
    package func draw(_ mapping: (_ element: Element) -> String = { $0.value }) -> Self {
        let drawing = elements.map { row in row.map { mapping($0) }.joined() }.joined(separator: "\n")
        print(drawing)
        return self
    }

    package func getVertical(row: Int, column: Int, includingGiven: Bool = false, maxDistance: Int = 1) -> [Element] {
        traverse(
            row: row,
            column: column,
            rowDelta: 1,
            columnDelta: 0,
            includingGiven: includingGiven,
            maxDistance: maxDistance
        )
    }

    package func getVertical(of element: Element, includingGiven: Bool = false, maxDistance: Int = 1) -> [Element] {
        getVertical(row: element.row, column: element.column, includingGiven: includingGiven, maxDistance: maxDistance)
    }

    package func getHorizontal(row: Int, column: Int, includingGiven: Bool = false, maxDistance: Int = 1) -> [Element] {
        traverse(
            row: row,
            column: column,
            rowDelta: 0,
            columnDelta: 1,
            includingGiven: includingGiven,
            maxDistance: maxDistance
        )
    }

    package func getHorizontal(of element: Element, includingGiven: Bool = false, maxDistance: Int = 1) -> [Element] {
        getHorizontal(
            row: element.row,
            column: element.column,
            includingGiven: includingGiven,
            maxDistance: maxDistance
        )
    }

    package func getTopLeftToBottomRight(
        row: Int,
        column: Int,
        includingGiven: Bool = false,
        maxDistance: Int = 1
    ) -> [Element] {
        traverse(
            row: row,
            column: column,
            rowDelta: 1,
            columnDelta: 1,
            includingGiven: includingGiven,
            maxDistance: maxDistance
        )
    }

    package func getTopLeftToBottomRight(
        of element: Element,
        includingGiven: Bool = false,
        maxDistance: Int = 1
    ) -> [Element] {
        getTopLeftToBottomRight(
            row: element.row,
            column: element.column,
            includingGiven: includingGiven,
            maxDistance: maxDistance
        )
    }

    package func getTopRightToBottomLeft(
        row: Int,
        column: Int,
        includingGiven: Bool = false,
        maxDistance: Int = 1
    ) -> [Element] {
        traverse(
            row: row,
            column: column,
            rowDelta: 1,
            columnDelta: -1,
            includingGiven: includingGiven,
            maxDistance: maxDistance
        )
    }

    package func getTopRightToBottomLeft(
        of element: Element,
        includingGiven: Bool = false,
        maxDistance: Int = 1
    ) -> [Element] {
        getTopRightToBottomLeft(
            row: element.row,
            column: element.column,
            includingGiven: includingGiven,
            maxDistance: maxDistance
        )
    }

    package func neighbors(row: Int, column: Int) -> [Element] {
        let deltas = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]

        return deltas.compactMap { rowDelta, columnDelta in
            get(row: row + rowDelta, column: column + columnDelta)
        }
    }

    package func neighbors(of element: Element) -> [Element] {
        neighbors(row: element.row, column: element.column)
    }

    package func flatArray() -> [Element] {
        elements.flatMap { $0 }
    }

    package func makeIterator() -> IndexingIterator<[Element]> {
        flatArray().makeIterator()
    }

    package struct Element: Hashable {
        package let value: T
        package let row: Int
        package let column: Int

        package init(value: T, row: Int, column: Int) {
            self.value = value
            self.row = row
            self.column = column
        }
    }

    package static func fromArray(_ array: [T], width: Int) -> Matrix<T> {
        Matrix(array: array, width: width)
    }

    package static func fromString(_ string: String) -> Matrix<T> where T == Character {
        let elements = string.split(whereSeparator: \.isNewline)
            .enumerated()
            .map { x, line in
                line.enumerated()
                    .map { y, value in Element(value: value, row: x, column: y) }
            }

        return Matrix(elements: elements)
    }

    private func traverse(
        row: Int,
        column: Int,
        rowDelta: Int,
        columnDelta: Int,
        includingGiven: Bool,
        maxDistance: Int
    ) -> [Element] {
        guard maxDistance > 0 else { return [] }

        let elements = (0...maxDistance).compactMap { i -> Element? in
            guard i != 0 || includingGiven else { return nil }
            return get(row: row + i * rowDelta, column: column + i * columnDelta)
        }
        assert(elements.count <= (maxDistance + (includingGiven ? 1 : 0)))

        return elements
    }
}
