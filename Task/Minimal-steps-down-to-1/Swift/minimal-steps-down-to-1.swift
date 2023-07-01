func minToOne(divs: [Int], subs: [Int], upTo n: Int) -> ([Int], [[String]]) {
  var table = Array(repeating: n + 2, count: n + 1)
  var how = Array(repeating: [""], count: n + 2)

  table[1] = 0
  how[1] = ["="]

  for t in 1..<n {
    let thisPlus1 = table[t] + 1

    for div in divs {
      let dt = div * t

      if dt <= n && thisPlus1 < table[dt] {
        table[dt] = thisPlus1
        how[dt] = how[t] + ["/\(div)=>  \(t)"]
      }
    }

    for sub in subs {
      let st = sub + t

      if st <= n && thisPlus1 < table[st] {
        table[st] = thisPlus1
        how[st] = how[t] + ["-\(sub)=> \(t)"]
      }
    }
  }

  return (table, how.map({ $0.reversed().dropLast() }))
}

for (divs, subs) in [([2, 3], [1]), ([2, 3], [2])] {
  print("\nMINIMUM STEPS TO 1:")
  print("  Possible divisors:  \(divs)")
  print("  Possible decrements: \(subs)")

  let (table, hows) = minToOne(divs: divs, subs: subs, upTo: 10)

  for n in 1...10 {
    print("    mintab(  \(n)) in {  \(table[n])} by: ", hows[n].joined(separator: ", "))
  }

  for upTo in [2_000, 50_000] {
    print("\n    Those numbers up to \(upTo) that take the maximum, \"minimal steps down to 1\":")
    let (table, _) = minToOne(divs: divs, subs: subs, upTo: upTo)
    let max = table.dropFirst().max()!
    let maxNs = table.enumerated().filter({ $0.element == max })

    print(
      "      Taking", max, "steps are the \(maxNs.count) numbers:",
      maxNs.map({ String($0.offset) }).joined(separator: ", ")
    )
  }
}
