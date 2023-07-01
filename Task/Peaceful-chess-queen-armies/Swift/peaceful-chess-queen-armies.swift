enum Piece {
  case empty, black, white
}

typealias Position = (Int, Int)

func place(_ m: Int, _ n: Int, pBlackQueens: inout [Position], pWhiteQueens: inout [Position]) -> Bool {
  guard m != 0 else {
    return true
  }

  var placingBlack = true

  for i in 0..<n {
    inner: for j in 0..<n {
      let pos = (i, j)

      for queen in pBlackQueens where queen == pos || !placingBlack && isAttacking(queen, pos) {
        continue inner
      }

      for queen in pWhiteQueens where queen == pos || placingBlack && isAttacking(queen, pos) {
        continue inner
      }

      if placingBlack {
        pBlackQueens.append(pos)
        placingBlack = false
      } else {
        placingBlack = true

        pWhiteQueens.append(pos)

        if place(m - 1, n, pBlackQueens: &pBlackQueens, pWhiteQueens: &pWhiteQueens) {
          return true
        } else {
          pBlackQueens.removeLast()
          pWhiteQueens.removeLast()
        }
      }
    }
  }

  if !placingBlack {
    pBlackQueens.removeLast()
  }

  return false
}

func isAttacking(_ queen: Position, _ pos: Position) -> Bool {
  queen.0 == pos.0 || queen.1 == pos.1 || abs(queen.0 - pos.0) == abs(queen.1 - pos.1)
}

func printBoard(n: Int, pBlackQueens: [Position], pWhiteQueens: [Position]) {
  var board = Array(repeating: Piece.empty, count: n * n)

  for queen in pBlackQueens {
    board[queen.0 * n + queen.1] = .black
  }

  for queen in pWhiteQueens {
    board[queen.0 * n + queen.1] = .white
  }

  for (i, p) in board.enumerated() {
    if i != 0 && i % n == 0 {
      print()
    }

    switch p {
    case .black:
      print("B ", terminator: "")
    case .white:
      print("W ", terminator: "")
    case .empty:
      let j = i / n
      let k = i - j * n

      if j % 2 == k % 2 {
        print("• ", terminator: "")
      } else {
        print("◦ ", terminator: "")
      }
    }
  }

  print("\n")
}

let nms = [
  (2, 1), (3, 1), (3, 2), (4, 1), (4, 2), (4, 3),
  (5, 1), (5, 2), (5, 3), (5, 4), (5, 5),
  (6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 6),
  (7, 1), (7, 2), (7, 3), (7, 4), (7, 5), (7, 6), (7, 7)
]

for (n, m) in nms {
  print("\(m) black and white queens on \(n) x \(n) board")

  var blackQueens = [Position]()
  var whiteQueens = [Position]()

  if place(m, n, pBlackQueens: &blackQueens, pWhiteQueens: &whiteQueens) {
    printBoard(n: n, pBlackQueens: blackQueens, pWhiteQueens: whiteQueens)
  } else {
    print("No solution")
  }
}
