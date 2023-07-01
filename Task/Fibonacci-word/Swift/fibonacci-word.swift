import Foundation

struct Fib: Sequence, IteratorProtocol {
  private var cur: String
  private var nex: String

  init(cur: String, nex: String) {
    self.cur = cur
    self.nex = nex
  }

  mutating func next() -> String? {
    let ret = cur

    cur = nex
    nex = "\(ret)\(nex)"

    return ret
  }
}

func getEntropy(_ s: [Int]) -> Double {
  var entropy = 0.0
  var hist = Array(repeating: 0.0, count: 256)

  for i in 0..<s.count {
    hist[s[i]] += 1
  }

  for i in 0..<256 where hist[i] > 0 {
    let rat = hist[i] / Double(s.count)
    entropy -= rat * log2(rat)
  }

  return entropy
}

for (i, str) in Fib(cur: "1", nex: "0").prefix(37).enumerated() {
  let ent = getEntropy(str.map({ Int($0.asciiValue!) }))

  print("i: \(i) len: \(str.count) entropy: \(ent)")
}
