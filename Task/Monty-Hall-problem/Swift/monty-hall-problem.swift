import Foundation

func montyHall(doors: Int = 3, guess: Int, switch: Bool) -> Bool {
  guard doors > 2, guess > 0, guess <= doors else { fatalError() }

  let winningDoor = Int.random(in: 1...doors)

  return winningDoor == guess ? !`switch` : `switch`
}

var switchResults = [Bool]()

for _ in 0..<1_000 {
  let guess = Int.random(in: 1...3)
  let wasRight = montyHall(guess: guess, switch: true)

  switchResults.append(wasRight)
}

let switchWins = switchResults.filter({ $0 }).count

print("Switching would've won \((Double(switchWins) / Double(switchResults.count)) * 100)% of games")
print("Not switching would've won \(((Double(switchResults.count - switchWins)) / Double(switchResults.count)) * 100)% of games")
