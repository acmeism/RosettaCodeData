public struct CPoint {
  public var x: Int
  public var y: Int

  public init(x: Int, y: Int) {
    (self.x, self.y) = (x, y)
  }

  public func move(by: (dx: Int, dy: Int)) -> CPoint {
    return CPoint(x: self.x + by.dx, y: self.y + by.dy)
  }
}

extension CPoint: Comparable {
  public static func <(lhs: CPoint, rhs: CPoint) -> Bool {
    if lhs.x == rhs.x {
      return lhs.y < rhs.y
    } else {
      return lhs.x < rhs.x
    }
  }
}

public class KnightsTour {
  public var size: Int { board.count }

  private var board: [[Int]]

  public init(size: Int) {
    board = Array(repeating: Array(repeating: 0, count: size), count: size)
  }

  public func countMoves(forPoint point: CPoint) -> Int {
    return KnightsTour.knightMoves.lazy
      .map(point.move)
      .reduce(0, {count, movedTo in
        return squareAvailable(movedTo) ? count + 1 : count
    })
  }

  public func printBoard() {
    for row in board {
      for x in row {
        print("\(x) ", terminator: "")
      }

      print()
    }

    print()
  }

  private func reset() {
    for i in 0..<size {
      for j in 0..<size {
        board[i][j] = 0
      }
    }
  }

  public func squareAvailable(_ p: CPoint) -> Bool {
    return 0 <= p.x
      && p.x < size
      && 0 <= p.y
      && p.y < size
      && board[p.x][p.y] == 0
  }

  public func tour(startingAt point: CPoint = CPoint(x: 0, y: 0)) -> Bool {
    var step = 2
    var p = point

    reset()

    board[p.x][p.y] = 1

    while step <= size * size {
      let candidates = KnightsTour.knightMoves.lazy
        .map(p.move)
        .map({moved in (moved, self.countMoves(forPoint: moved), self.squareAvailable(moved)) })
        .filter({ $0.2 })

      guard let bestMove = candidates.sorted(by: bestChoice).first else {
        return false
      }

      p = bestMove.0
      board[p.x][p.y] = step

      step += 1
    }

    return true
  }
}

private func bestChoice(_ choice1: (CPoint, Int, Bool), _ choice2: (CPoint, Int, Bool)) -> Bool {
  if choice1.1 == choice2.1 {
    return choice1.0 < choice2.0
  }

  return choice1.1 < choice2.1
}

extension KnightsTour {
  fileprivate static let knightMoves = [
    (2, 1),
    (1, 2),
    (-1, 2),
    (-2, 1),
    (-2, -1),
    (-1, -2),
    (1, -2),
    (2, -1),
  ]
}

let b = KnightsTour(size: 8)

print()

let completed = b.tour(startingAt: CPoint(x: 3, y: 1))

if completed {
  print("Completed tour")
} else {
  print("Did not complete tour")
}

b.printBoard()
