enum Choice: CaseIterable {
  case rock
  case paper
  case scissors
  case lizard
  case spock
}

extension Choice {
  var weaknesses: Set<Choice> {
    switch self {
      case .rock:
        return [.paper, .spock]
      case .paper:
        return [.scissors, .lizard]
      case .scissors:
        return [.rock, .spock]
      case .lizard:
        return [.rock, .scissors]
      case .spock:
        return [.paper, .lizard]
    }
  }
}

struct Game {
  private(set) var history: [(Choice, Choice)] = []
  private(set) var p1Score: Int = 0
  private(set) var p2Score: Int = 0

  mutating func play(_ p1Choice: Choice, against p2Choice: Choice) {
    history.append((p1Choice, p2Choice))
    if p2Choice.weaknesses.contains(p1Choice) {
      p1Score += 1
    } else if p1Choice.weaknesses.contains(p2Choice) {
      p2Score += 1
    }
  }
}

func aiChoice(for game: Game) -> Choice {
  if let weightedWeekness = game.history.flatMap({ $0.0.weaknesses }).randomElement() {
    return weightedWeekness
  } else {
    // If history is empty, return random Choice
    return Choice.allCases.randomElement()!
  }
}

var game = Game()
print("Type your choice to play a round, or 'q' to quit")
loop: while true {
  let choice: Choice
  switch readLine().map({ $0.lowercased() }) {
    case "r", "rock":
      choice = .rock
    case "p", "paper":
      choice = .paper
    case "scissors":
      choice = .scissors
    case "l", "lizard":
      choice = .lizard
    case "spock":
      choice = .spock
    case "q", "quit", "exit":
      break loop
    case "s":
      print("Do you mean Spock, or scissors?")
      continue
    default:
      print("Unknown choice. Type 'q' to quit")
      continue
  }
  let p2Choice = aiChoice(for: game)
  print("You played \(choice) against \(p2Choice)")
  game.play(choice, against: p2Choice)
  print("Current score: \(game.p1Score) : \(game.p2Score)")
}
