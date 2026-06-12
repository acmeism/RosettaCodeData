enum Colour : CustomStringConvertible {
  case grey
  case yellow
  case green

  var description : String {
    switch self {
    case .grey: return "grey"
    case .yellow: return "yellow"
    case .green: return "green"
    }
  }
}

func wordle(answer: String, guess: String) -> [Colour]? {
    guard answer.count == guess.count else {
        return nil
    }
    var a = Array(answer)
    let g = Array(guess)
    let n = a.count
    var result = Array(repeating: Colour.grey, count: n)
    for i in 0..<n {
        if g[i] == a[i] {
            a[i] = "\0"
            result[i] = Colour.green
        }
    }
    for i in 0..<n {
        if let j = a.firstIndex(of: g[i]) {
            a[j] = "\0"
            result[i] = Colour.yellow
        }
    }
    return result
}

let pairs = [("ALLOW", "LOLLY"), ("BULLY", "LOLLY"),
              ("ROBIN", "ALERT"), ("ROBIN", "SONIC"),
              ("ROBIN", "ROBIN")]

for pair in pairs {
    if let result = wordle(answer: pair.0, guess: pair.1) {
        print("\(pair.0) v \(pair.1) => \(result)")
    }
}
