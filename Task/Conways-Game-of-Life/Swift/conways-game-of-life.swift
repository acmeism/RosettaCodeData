struct Cell: Hashable {
  var x: Int
  var y: Int
}

struct Colony {
  private var height: Int
  private var width: Int
  private var cells: Set<Cell>

  init(cells: Set<Cell>, height: Int, width: Int) {
    self.cells = cells
    self.height = height
    self.width = width
  }

  private func neighborCounts() -> [Cell: Int] {
    var counts = [Cell: Int]()

    for cell in cells.flatMap(Colony.neighbors(for:)) {
      counts[cell, default: 0] += 1
    }

    return counts
  }

  private static func neighbors(for cell: Cell) -> [Cell] {
    return [
      Cell(x: cell.x - 1, y: cell.y - 1),
      Cell(x: cell.x,     y: cell.y - 1),
      Cell(x: cell.x + 1, y: cell.y - 1),
      Cell(x: cell.x - 1, y: cell.y),
      Cell(x: cell.x + 1, y: cell.y),
      Cell(x: cell.x - 1, y: cell.y + 1),
      Cell(x: cell.x,     y: cell.y + 1),
      Cell(x: cell.x + 1, y: cell.y + 1),
    ]
  }

  func printColony() {
    for y in 0..<height {
      for x in 0..<width {
        let char = cells.contains(Cell(x: x, y: y)) ? "0" : "."

        print("\(char) ", terminator: "")
      }

      print()
    }
  }

  mutating func run(iterations: Int) {
    print("(0)")
    printColony()
    print()

    for i in 1...iterations {
      print("(\(i))")
      runGeneration()
      printColony()
      print()
    }
  }

  private mutating func runGeneration() {
    cells = Set(neighborCounts().compactMap({keyValue in
      switch (keyValue.value, cells.contains(keyValue.key)) {
      case (2, true), (3, _):
        return keyValue.key
      case _:
        return nil
      }
    }))
  }
}

let blinker = [Cell(x: 1, y: 0), Cell(x: 1, y: 1), Cell(x: 1, y: 2)] as Set

var col = Colony(cells: blinker, height: 3, width: 3)

print("Blinker: ")
col.run(iterations: 3)

let glider = [
  Cell(x: 1, y: 0),
  Cell(x: 2, y: 1),
  Cell(x: 0, y: 2),
  Cell(x: 1, y: 2),
  Cell(x: 2, y: 2)
] as Set

col = Colony(cells: glider, height: 8, width: 8)

print("Glider: ")
col.run(iterations: 20)
