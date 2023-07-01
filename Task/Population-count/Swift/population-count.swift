func populationCount(n: Int) -> Int {
  guard n >= 0 else { fatalError() }

  return String(n, radix: 2).filter({ $0 == "1" }).count
}

let pows = (0...)
    .lazy
    .map({ Int(pow(3, Double($0))) })
    .map(populationCount)
    .prefix(30)

let evils = (0...)
    .lazy
    .filter({ populationCount(n: $0) & 1 == 0 })
    .prefix(30)

let odious = (0...)
    .lazy
    .filter({ populationCount(n: $0) & 1 == 1 })
    .prefix(30)

print("Powers:", Array(pows))
print("Evils:", Array(evils))
print("Odious:", Array(odious))
