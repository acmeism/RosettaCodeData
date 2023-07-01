func perfectShuffle<T>(_ arr: [T]) -> [T]? {
  guard arr.count & 1 == 0 else {
    return nil
  }

  let half = arr.count / 2
  var res = [T]()

  for i in 0..<half {
    res.append(arr[i])
    res.append(arr[i + half])
  }

  return res
}

let decks = [
  Array(1...8),
  Array(1...24),
  Array(1...52),
  Array(1...100),
  Array(1...1020),
  Array(1...1024),
  Array(1...10000)
]

for deck in decks {
  var shuffled = deck
  var shuffles = 0

  repeat {
    shuffled = perfectShuffle(shuffled)!
    shuffles += 1
  } while shuffled != deck

  print("Deck of \(shuffled.count) took \(shuffles) shuffles to get back to original order")
}
