import Foundation

struct PrisonersGame {
  let strategy: Strategy
  let numPrisoners: Int
  let drawers: [Int]

  init(numPrisoners: Int, strategy: Strategy) {
    self.numPrisoners = numPrisoners
    self.strategy = strategy
    self.drawers = (1...numPrisoners).shuffled()
  }

  @discardableResult
  func play() -> Bool {
    for num in 1...numPrisoners {
      guard findNumber(num) else {
        return false
      }
    }

    return true
  }

  private func findNumber(_ num: Int) -> Bool {
    var tries = 0
    var nextDrawer = num - 1

    while tries < 50 {
      tries += 1

      switch strategy {
      case .random where drawers.randomElement()! == num:
        return true
      case .optimum where drawers[nextDrawer] == num:
        return true
      case .optimum:
        nextDrawer = drawers[nextDrawer] - 1
      case _:
        continue
      }
    }

    return false
  }

  enum Strategy {
    case random, optimum
  }
}

let numGames = 100_000
let lock = DispatchSemaphore(value: 1)
var done = 0

print("Running \(numGames) games for each strategy")

DispatchQueue.concurrentPerform(iterations: 2) {i in
  let strat = i == 0 ? PrisonersGame.Strategy.random : .optimum
  var numPardoned = 0

  for _ in 0..<numGames {
    let game = PrisonersGame(numPrisoners: 100, strategy: strat)

    if game.play() {
      numPardoned += 1
    }
  }

  print("Probability of pardon with \(strat) strategy: \(Double(numPardoned) / Double(numGames))")

  lock.wait()
  done += 1
  lock.signal()

  if done == 2 {
    exit(0)
  }
}

dispatchMain()
