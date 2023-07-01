let bases: [Character] = ["A", "C", "G", "T"]

enum Action: CaseIterable {
  case swap, delete, insert
}

@discardableResult
func mutate(dna: inout String) -> Action {
  guard let i = dna.indices.shuffled().first(where: { $0 != dna.endIndex }) else {
    fatalError()
  }

  let action = Action.allCases.randomElement()!

  switch action {
  case .swap:
    dna.replaceSubrange(i..<i, with: [bases.randomElement()!])
  case .delete:
    dna.remove(at: i)
  case .insert:
    dna.insert(bases.randomElement()!, at: i)
  }

  return action
}

var d = ""

for _ in 0..<200 {
  d.append(bases.randomElement()!)
}

func printSeq(_ dna: String) {
  for startI in stride(from: 0, to: dna.count, by: 50) {
    print("\(startI): \(dna.dropFirst(startI).prefix(50))")
  }

  print()
  print("Size: \(dna.count)")
  print()

  let counts = dna.reduce(into: [:], { $0[$1, default: 0] += 1 })

  for (char, count) in counts.sorted(by: { $0.key < $1.key }) {
    print("\(char): \(count)")
  }
}

printSeq(d)

print()

for _ in 0..<20 {
  mutate(dna: &d)
}

printSeq(d)
