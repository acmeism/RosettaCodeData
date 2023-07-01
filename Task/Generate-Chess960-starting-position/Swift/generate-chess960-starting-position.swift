func isValid960Position(_ firstRank: String) -> Bool {
  var rooksPlaced = 0
  var bishopColor = -1

  for (i, piece) in firstRank.enumerated() {
    switch piece {
    case "♚" where rooksPlaced != 1:
      return false
    case "♜":
      rooksPlaced += 1
    case "♝" where bishopColor == -1:
      bishopColor = i & 1
    case "♝" where bishopColor == i & 1:
      return false
    case _:
      continue
    }
  }

  return true
}

struct Chess960Counts {
  var king = 0, queen = 0, rook = 0, bishop = 0, knight = 0

  subscript(_ piece: String) -> Int {
    get {
      switch piece {
      case "♚": return king
      case "♛": return queen
      case "♜": return rook
      case "♝": return bishop
      case "♞": return knight
      case _:   fatalError()
      }
    }

    set {
      switch piece {
      case "♚": king = newValue
      case "♛": queen = newValue
      case "♜": rook = newValue
      case "♝": bishop = newValue
      case "♞": knight = newValue
      case _:   fatalError()
      }
    }
  }
}

func get960Position() -> String {
  var counts = Chess960Counts()
  var bishopColor = -1 // 0 - white 1 - black
  var output = ""

  for i in 1...8 {
    let validPieces = [
      counts["♜"] == 1 && counts["♚"] == 0 ? "♚" : nil, // king
      i == 1 || (counts["♛"] == 0) ? "♛" : nil, // queen
      i == 1 || (counts["♜"] == 0 || counts["♜"] < 2 && counts["♚"] == 1) ? "♜" : nil, // rook
      i == 1 || (counts["♝"] < 2 && bishopColor == -1 || bishopColor != i & 1) ? "♝" : nil, // bishop
      i == 1 || (counts["♞"] < 2) ? "♞" : nil // knight
    ].lazy.compactMap({ $0 })

    guard let chosenPiece = validPieces.randomElement() else {
      // Need to swap last piece with a bishop
      output.insert("♝", at: output.index(before: output.endIndex))

      break
    }

    counts[chosenPiece] += 1
    output += chosenPiece

    if bishopColor == -1 && chosenPiece == "♝" {
      bishopColor = i & 1
    }
  }

  assert(isValid960Position(output), "invalid 960 position \(output)")

  return output
}

var positions = Set<String>()

while positions.count != 960 {
  positions.insert(get960Position())
}

print(positions.count, positions.randomElement()!)
