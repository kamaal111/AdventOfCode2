//
//  MatrixTests.swift
//  AdventOfCode
//
//  Created by Kamaal M Farah on 11/30/25.
//

import Testing

@testable import AdventOfCode

// MARK: - Init Tests

@Test func `Matrix init creates matrix with elements`() {
    let element = Matrix<Character>.Element(value: "A", row: 0, column: 0)
    let matrix = Matrix(elements: [[element]])

    #expect(matrix.height == 1)
    #expect(matrix.width == 1)
    #expect(matrix.get(row: 0, column: 0)?.value == "A")
}

// MARK: - Description Tests

@Test func `description returns string representation of matrix`() {
    let input = """
        AB
        CD
        """
    let matrix = Matrix<Character>.fromString(input)

    #expect(matrix.description == "AB\nCD")
}

@Test func `description works with single row`() {
    let matrix = Matrix<Character>.fromString("ABC")

    #expect(matrix.description == "ABC")
}

@Test func `description works with empty matrix`() {
    let matrix = Matrix<Character>.fromString("")

    #expect(matrix.description == "")
}

@Test func `Matrix can be printed`() {
    let matrix = Matrix<Character>.fromString("XY")

    #expect("\(matrix)" == "XY")
}

// MARK: - Height and Width Tests

@Test func `height returns number of rows`() {
    let input = """
        AB
        CD
        EF
        """
    let matrix = Matrix<Character>.fromString(input)

    #expect(matrix.height == 3)
}

@Test func `height returns zero for empty matrix`() {
    let matrix = Matrix<Character>.fromString("")

    #expect(matrix.height == 0)
}

@Test func `width returns number of columns`() {
    let input = """
        ABCD
        EFGH
        """
    let matrix = Matrix<Character>.fromString(input)

    #expect(matrix.width == 4)
}

@Test func `width returns zero for empty matrix`() {
    let matrix = Matrix<Character>.fromString("")

    #expect(matrix.width == 0)
}

// MARK: - Element Tests

@Test func `Element init creates element with correct properties`() {
    let element = Matrix<Character>.Element(value: "X", row: 2, column: 3)

    #expect(element.value == "X")
    #expect(element.row == 2)
    #expect(element.column == 3)
}

@Test func `Element is Hashable`() {
    let element1 = Matrix<Character>.Element(value: "A", row: 0, column: 0)
    let element2 = Matrix<Character>.Element(value: "A", row: 0, column: 0)
    let element3 = Matrix<Character>.Element(value: "B", row: 0, column: 0)

    #expect(element1 == element2)
    #expect(element1 != element3)

    var set = Set<Matrix<Character>.Element>()
    set.insert(element1)
    set.insert(element2)
    #expect(set.count == 1)
}

// MARK: - fromString Tests

@Test func `fromString creates matrix from single line`() {
    let matrix = Matrix<Character>.fromString("ABC")

    #expect(matrix.height == 1)
    #expect(matrix.width == 3)
    #expect(matrix.get(row: 0, column: 0)?.value == "A")
    #expect(matrix.get(row: 0, column: 0)?.row == 0)
    #expect(matrix.get(row: 0, column: 0)?.column == 0)
    #expect(matrix.get(row: 0, column: 1)?.value == "B")
    #expect(matrix.get(row: 0, column: 1)?.row == 0)
    #expect(matrix.get(row: 0, column: 1)?.column == 1)
    #expect(matrix.get(row: 0, column: 2)?.value == "C")
    #expect(matrix.get(row: 0, column: 2)?.row == 0)
    #expect(matrix.get(row: 0, column: 2)?.column == 2)
}

@Test func `fromString creates matrix from multiple lines`() {
    let input = """
        AB
        CD
        """
    let matrix = Matrix<Character>.fromString(input)

    #expect(matrix.height == 2)
    #expect(matrix.width == 2)
    #expect(matrix.get(row: 0, column: 0)?.value == "A")
    #expect(matrix.get(row: 0, column: 1)?.value == "B")
    #expect(matrix.get(row: 1, column: 0)?.value == "C")
    #expect(matrix.get(row: 1, column: 0)?.row == 1)
    #expect(matrix.get(row: 1, column: 0)?.column == 0)
    #expect(matrix.get(row: 1, column: 1)?.value == "D")
}

@Test func `fromString handles empty string`() {
    let matrix = Matrix<Character>.fromString("")

    #expect(matrix.height == 0)
}

// MARK: - get Tests

@Test func `get returns element at valid position`() {
    let input = """
        AB
        CD
        """
    let matrix = Matrix<Character>.fromString(input)

    let element = matrix.get(row: 1, column: 0)

    #expect(element != nil)
    #expect(element?.value == "C")
    #expect(element?.row == 1)
    #expect(element?.column == 0)
}

@Test func `get returns nil for row out of bounds (positive)`() {
    let matrix = Matrix<Character>.fromString("AB")

    let element = matrix.get(row: 5, column: 0)

    #expect(element == nil)
}

@Test func `get returns nil for row out of bounds (negative)`() {
    let matrix = Matrix<Character>.fromString("AB")

    let element = matrix.get(row: -1, column: 0)

    #expect(element == nil)
}

@Test func `get returns nil for column out of bounds (positive)`() {
    let matrix = Matrix<Character>.fromString("AB")

    let element = matrix.get(row: 0, column: 5)

    #expect(element == nil)
}

@Test func `get returns nil for column out of bounds (negative)`() {
    let matrix = Matrix<Character>.fromString("AB")

    let element = matrix.get(row: 0, column: -1)

    #expect(element == nil)
}

// MARK: - getVertical Tests

@Test func `getVertical returns elements below given position`() {
    let input = """
        A
        B
        C
        """
    let matrix = Matrix<Character>.fromString(input)

    let elements = matrix.getVertical(row: 0, column: 0, maxDistance: 2)

    #expect(elements.count == 2)
    #expect(elements[0].value == "B")
    #expect(elements[1].value == "C")
}

@Test func `getVertical with includingGiven includes starting element`() {
    let input = """
        A
        B
        C
        """
    let matrix = Matrix<Character>.fromString(input)

    let elements = matrix.getVertical(row: 0, column: 0, includingGiven: true, maxDistance: 2)

    #expect(elements.count == 3)
    #expect(elements[0].value == "A")
    #expect(elements[1].value == "B")
    #expect(elements[2].value == "C")
}

@Test func `getVertical returns empty for zero maxDistance`() {
    let matrix = Matrix<Character>.fromString("A\nB")

    let elements = matrix.getVertical(row: 0, column: 0, maxDistance: 0)

    #expect(elements.isEmpty)
}

@Test func `getVertical with element overload`() {
    let input = """
        A
        B
        C
        """
    let matrix = Matrix<Character>.fromString(input)
    let startElement = matrix.get(row: 0, column: 0)!

    let elements = matrix.getVertical(of: startElement, includingGiven: true, maxDistance: 2)

    #expect(elements.count == 3)
    #expect(elements[0].value == "A")
}

@Test func `getVertical handles partial results when hitting boundary`() {
    let input = """
        A
        B
        """
    let matrix = Matrix<Character>.fromString(input)

    let elements = matrix.getVertical(row: 0, column: 0, maxDistance: 5)

    #expect(elements.count == 1)
    #expect(elements[0].value == "B")
}

// MARK: - getHorizontal Tests

@Test func `getHorizontal returns elements to the right of given position`() {
    let matrix = Matrix<Character>.fromString("ABC")

    let elements = matrix.getHorizontal(row: 0, column: 0, maxDistance: 2)

    #expect(elements.count == 2)
    #expect(elements[0].value == "B")
    #expect(elements[1].value == "C")
}

@Test func `getHorizontal with includingGiven includes starting element`() {
    let matrix = Matrix<Character>.fromString("ABC")

    let elements = matrix.getHorizontal(row: 0, column: 0, includingGiven: true, maxDistance: 2)

    #expect(elements.count == 3)
    #expect(elements[0].value == "A")
    #expect(elements[1].value == "B")
    #expect(elements[2].value == "C")
}

@Test func `getHorizontal returns empty for zero maxDistance`() {
    let matrix = Matrix<Character>.fromString("ABC")

    let elements = matrix.getHorizontal(row: 0, column: 0, maxDistance: 0)

    #expect(elements.isEmpty)
}

@Test func `getHorizontal with element overload`() {
    let matrix = Matrix<Character>.fromString("ABC")
    let startElement = matrix.get(row: 0, column: 0)!

    let elements = matrix.getHorizontal(of: startElement, includingGiven: true, maxDistance: 2)

    #expect(elements.count == 3)
    #expect(elements[0].value == "A")
}

@Test func `getHorizontal handles partial results when hitting boundary`() {
    let matrix = Matrix<Character>.fromString("AB")

    let elements = matrix.getHorizontal(row: 0, column: 0, maxDistance: 5)

    #expect(elements.count == 1)
    #expect(elements[0].value == "B")
}

// MARK: - getTopLeftToBottomRight Tests

@Test func `getTopLeftToBottomRight returns diagonal elements`() {
    let input = """
        ABC
        DEF
        GHI
        """
    let matrix = Matrix<Character>.fromString(input)

    let elements = matrix.getTopLeftToBottomRight(row: 0, column: 0, maxDistance: 2)

    #expect(elements.count == 2)
    #expect(elements[0].value == "E")
    #expect(elements[1].value == "I")
}

@Test func `getTopLeftToBottomRight with includingGiven includes starting element`() {
    let input = """
        ABC
        DEF
        GHI
        """
    let matrix = Matrix<Character>.fromString(input)

    let elements = matrix.getTopLeftToBottomRight(row: 0, column: 0, includingGiven: true, maxDistance: 2)

    #expect(elements.count == 3)
    #expect(elements[0].value == "A")
    #expect(elements[1].value == "E")
    #expect(elements[2].value == "I")
}

@Test func `getTopLeftToBottomRight returns empty for zero maxDistance`() {
    let input = """
        ABC
        DEF
        """
    let matrix = Matrix<Character>.fromString(input)

    let elements = matrix.getTopLeftToBottomRight(row: 1, column: 1, maxDistance: 0)

    #expect(elements.isEmpty)
}

@Test func `getTopLeftToBottomRight with element overload`() {
    let input = """
        ABC
        DEF
        GHI
        """
    let matrix = Matrix<Character>.fromString(input)
    let startElement = matrix.get(row: 0, column: 0)!

    let elements = matrix.getTopLeftToBottomRight(of: startElement, includingGiven: true, maxDistance: 2)

    #expect(elements.count == 3)
    #expect(elements[0].value == "A")
}

@Test func `getTopLeftToBottomRight handles partial results when hitting boundary`() {
    let input = """
        AB
        CD
        """
    let matrix = Matrix<Character>.fromString(input)

    let elements = matrix.getTopLeftToBottomRight(row: 0, column: 0, maxDistance: 5)

    #expect(elements.count == 1)
    #expect(elements[0].value == "D")
}

// MARK: - getTopRightToBottomLeft Tests

@Test func `getTopRightToBottomLeft returns diagonal elements`() {
    let input = """
        ABC
        DEF
        GHI
        """
    let matrix = Matrix<Character>.fromString(input)

    let elements = matrix.getTopRightToBottomLeft(row: 0, column: 2, maxDistance: 2)

    #expect(elements.count == 2)
    #expect(elements[0].value == "E")
    #expect(elements[1].value == "G")
}

@Test func `getTopRightToBottomLeft with includingGiven includes starting element`() {
    let input = """
        ABC
        DEF
        GHI
        """
    let matrix = Matrix<Character>.fromString(input)

    let elements = matrix.getTopRightToBottomLeft(row: 0, column: 2, includingGiven: true, maxDistance: 2)

    #expect(elements.count == 3)
    #expect(elements[0].value == "C")
    #expect(elements[1].value == "E")
    #expect(elements[2].value == "G")
}

@Test func `getTopRightToBottomLeft returns empty for zero maxDistance`() {
    let input = """
        ABC
        DEF
        """
    let matrix = Matrix<Character>.fromString(input)

    let elements = matrix.getTopRightToBottomLeft(row: 1, column: 0, maxDistance: 0)

    #expect(elements.isEmpty)
}

@Test func `getTopRightToBottomLeft with element overload`() {
    let input = """
        ABC
        DEF
        GHI
        """
    let matrix = Matrix<Character>.fromString(input)
    let startElement = matrix.get(row: 0, column: 2)!

    let elements = matrix.getTopRightToBottomLeft(of: startElement, includingGiven: true, maxDistance: 2)

    #expect(elements.count == 3)
    #expect(elements[0].value == "C")
}

@Test func `getTopRightToBottomLeft handles partial results when hitting boundary`() {
    let input = """
        AB
        CD
        """
    let matrix = Matrix<Character>.fromString(input)

    let elements = matrix.getTopRightToBottomLeft(row: 0, column: 1, maxDistance: 5)

    #expect(elements.count == 1)
    #expect(elements[0].value == "C")
}

// MARK: - filter Tests

@Test func `filter returns elements matching predicate`() {
    let input = """
        AB
        CD
        """
    let matrix = Matrix<Character>.fromString(input)

    let filtered = matrix.filter { $0.value == "A" || $0.value == "D" }

    #expect(filtered.count == 2)
    #expect(filtered[0].value == "A")
    #expect(filtered[1].value == "D")
}

@Test func `filter returns empty when no elements match`() {
    let matrix = Matrix<Character>.fromString("AB")

    let filtered = matrix.filter { $0.value == "Z" }

    #expect(filtered.isEmpty)
}

@Test func `filter returns all elements when all match`() {
    let matrix = Matrix<Character>.fromString("AAA")

    let filtered = matrix.filter { $0.value == "A" }

    #expect(filtered.count == 3)
}

@Test func `filter can throw`() throws {
    let matrix = Matrix<Character>.fromString("AB")

    enum TestError: Error {
        case testError
    }

    #expect(throws: TestError.self) {
        _ = try matrix.filter { _ in throw TestError.testError }
    }
}

// MARK: - forEach Tests

@Test func `forEach iterates over all elements`() {
    let input = """
        AB
        CD
        """
    let matrix = Matrix<Character>.fromString(input)

    var values: [Character] = []
    matrix.forEach { values.append($0.value) }

    #expect(values == ["A", "B", "C", "D"])
}

@Test func `forEach iterates in row-major order`() {
    let input = """
        12
        34
        """
    let matrix = Matrix<Character>.fromString(input)

    var positions: [String] = []
    matrix.forEach { positions.append("\($0.row),\($0.column)") }

    #expect(positions == ["0,0", "0,1", "1,0", "1,1"])
}

@Test func `forEach handles empty matrix`() {
    let matrix = Matrix<Character>.fromString("")

    var count = 0
    matrix.forEach { _ in count += 1 }

    #expect(count == 0)
}

@Test func `forEach can throw`() throws {
    let matrix = Matrix<Character>.fromString("AB")

    enum TestError: Error {
        case testError
    }

    #expect(throws: TestError.self) {
        try matrix.forEach { _ in throw TestError.testError }
    }
}

// MARK: - Integration Tests

@Test func `Matrix works with different Hashable types`() {
    let intElement = Matrix<Int>.Element(value: 42, row: 0, column: 0)
    let intMatrix = Matrix(elements: [[intElement]])

    #expect(intMatrix.get(row: 0, column: 0)?.value == 42)
}

@Test func `Matrix can be used for grid traversal`() {
    let input = """
        123
        456
        789
        """
    let matrix = Matrix<Character>.fromString(input)

    // Get center element
    let center = matrix.get(row: 1, column: 1)
    #expect(center?.value == "5")

    // Get horizontal neighbors
    let horizontal = matrix.getHorizontal(row: 1, column: 0, includingGiven: true, maxDistance: 2)
    #expect(horizontal.map(\.value) == ["4", "5", "6"])

    // Get vertical neighbors
    let vertical = matrix.getVertical(row: 0, column: 1, includingGiven: true, maxDistance: 2)
    #expect(vertical.map(\.value) == ["2", "5", "8"])
}

// MARK: - Subscript Tests

@Test func `subscript returns element at valid position`() {
    let input = """
        AB
        CD
        """
    let matrix = Matrix<Character>.fromString(input)

    #expect(matrix[0, 0]?.value == "A")
    #expect(matrix[0, 1]?.value == "B")
    #expect(matrix[1, 0]?.value == "C")
    #expect(matrix[1, 1]?.value == "D")
}

@Test func `subscript returns nil for out of bounds`() {
    let matrix = Matrix<Character>.fromString("AB")

    #expect(matrix[-1, 0] == nil)
    #expect(matrix[0, -1] == nil)
    #expect(matrix[5, 0] == nil)
    #expect(matrix[0, 5] == nil)
}

// MARK: - Sequence Conformance Tests

@Test func `Matrix conforms to Sequence and can be iterated`() {
    let input = """
        AB
        CD
        """
    let matrix = Matrix<Character>.fromString(input)

    let values = matrix.map(\.value)

    #expect(values == ["A", "B", "C", "D"])
}

@Test func `Matrix can use for-in loop`() {
    let matrix = Matrix<Character>.fromString("XY")

    var collected: [Character] = []
    for element in matrix {
        collected.append(element.value)
    }

    #expect(collected == ["X", "Y"])
}

@Test func `Matrix can use contains`() {
    let matrix = Matrix<Character>.fromString("ABC")

    let hasB = matrix.contains { $0.value == "B" }
    let hasZ = matrix.contains { $0.value == "Z" }

    #expect(hasB == true)
    #expect(hasZ == false)
}

@Test func `Matrix can use reduce`() {
    let input = """
        12
        34
        """
    let matrix = Matrix<Character>.fromString(input)

    let sum = matrix.reduce(0) { $0 + Int(String($1.value))! }

    #expect(sum == 10)
}

// MARK: - Set Tests

@Test func `set returns new matrix with updated value`() {
    let input = """
        ABC
        DEF
        GHI
        """
    let matrix = Matrix<Character>.fromString(input)

    let newMatrix = matrix.set(row: 1, column: 1, value: "X")

    #expect(newMatrix.get(row: 1, column: 1)?.value == "X")
    #expect(matrix.get(row: 1, column: 1)?.value == "E")  // Original unchanged
}

@Test func `set updates first element`() {
    let matrix = Matrix<Character>.fromString("ABC")

    let newMatrix = matrix.set(row: 0, column: 0, value: "Z")

    #expect(newMatrix.get(row: 0, column: 0)?.value == "Z")
    #expect(newMatrix.description == "ZBC")
}

@Test func `set updates last element`() {
    let input = """
        AB
        CD
        """
    let matrix = Matrix<Character>.fromString(input)

    let newMatrix = matrix.set(row: 1, column: 1, value: "Z")

    #expect(newMatrix.get(row: 1, column: 1)?.value == "Z")
    #expect(newMatrix.description == "AB\nCZ")
}

@Test func `set updates corner elements correctly`() {
    let input = """
        ABC
        DEF
        GHI
        """
    let matrix = Matrix<Character>.fromString(input)

    let topLeft = matrix.set(row: 0, column: 0, value: "1")
    let topRight = matrix.set(row: 0, column: 2, value: "2")
    let bottomLeft = matrix.set(row: 2, column: 0, value: "3")
    let bottomRight = matrix.set(row: 2, column: 2, value: "4")

    #expect(topLeft.get(row: 0, column: 0)?.value == "1")
    #expect(topRight.get(row: 0, column: 2)?.value == "2")
    #expect(bottomLeft.get(row: 2, column: 0)?.value == "3")
    #expect(bottomRight.get(row: 2, column: 2)?.value == "4")
}

@Test func `set can be chained`() {
    let matrix = Matrix<Character>.fromString("ABC")

    let newMatrix =
        matrix
        .set(row: 0, column: 0, value: "X")
        .set(row: 0, column: 1, value: "Y")
        .set(row: 0, column: 2, value: "Z")

    #expect(newMatrix.description == "XYZ")
}

@Test func `set preserves element row and column`() {
    let matrix = Matrix<Character>.fromString("AB")

    let newMatrix = matrix.set(row: 0, column: 1, value: "Z")
    let element = newMatrix.get(row: 0, column: 1)

    #expect(element?.value == "Z")
    #expect(element?.row == 0)
    #expect(element?.column == 1)
}

@Test func `set with integer matrix`() {
    let matrix = Matrix(chunks: [[1, 2], [3, 4]])

    let newMatrix = matrix.set(row: 0, column: 1, value: 99)

    #expect(newMatrix.get(row: 0, column: 1)?.value == 99)
    #expect(newMatrix.description == "199\n34")
}

@Test func `set with element convenience method`() {
    let input = """
        ABC
        DEF
        GHI
        """
    let matrix = Matrix<Character>.fromString(input)
    let element = matrix.get(row: 1, column: 1)!

    let newMatrix = matrix.set(element: element, value: "X")

    #expect(newMatrix.get(row: 1, column: 1)?.value == "X")
    #expect(matrix.get(row: 1, column: 1)?.value == "E")  // Original unchanged
}

@Test func `set with element preserves row and column`() {
    let matrix = Matrix<Character>.fromString("AB")
    let element = matrix.get(row: 0, column: 1)!

    let newMatrix = matrix.set(element: element, value: "Z")
    let updatedElement = newMatrix.get(row: 0, column: 1)!

    #expect(updatedElement.value == "Z")
    #expect(updatedElement.row == 0)
    #expect(updatedElement.column == 1)
}

@Test func `set with element can be chained`() {
    let input = """
        ABC
        DEF
        GHI
        """
    let matrix = Matrix<Character>.fromString(input)

    let newMatrix =
        matrix
        .set(element: matrix.get(row: 0, column: 0)!, value: "1")
        .set(element: matrix.get(row: 1, column: 1)!, value: "2")
        .set(element: matrix.get(row: 2, column: 2)!, value: "3")

    #expect(newMatrix.get(row: 0, column: 0)?.value == "1")
    #expect(newMatrix.get(row: 1, column: 1)?.value == "2")
    #expect(newMatrix.get(row: 2, column: 2)?.value == "3")
}
