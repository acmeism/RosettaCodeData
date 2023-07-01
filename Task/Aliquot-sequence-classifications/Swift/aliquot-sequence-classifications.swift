extension BinaryInteger {
  @inlinable
  public func factors(sorted: Bool = true) -> [Self] {
    let maxN = Self(Double(self).squareRoot())
    var res = Set<Self>()

    for factor in stride(from: 1, through: maxN, by: 1) where self % factor == 0 {
      res.insert(factor)
      res.insert(self / factor)
    }

    return sorted ? res.sorted() : Array(res)
  }
}

struct SeqClass: CustomStringConvertible {
  var seq: [Int]
  var desc: String

  var description: String {
    return "\(desc):    \(seq)"
  }
}

func classifySequence(k: Int, threshold: Int = 1 << 47) -> SeqClass {
  var last = k
  var seq = [k]

  while true {
    last = last.factors().dropLast().reduce(0, +)
    seq.append(last)

    let n = seq.count

    if last == 0 {
      return SeqClass(seq: seq, desc: "Terminating")
    } else if n == 2 && last == k {
      return SeqClass(seq: seq, desc: "Perfect")
    } else if n == 3 && last == k {
      return SeqClass(seq: seq, desc: "Amicable")
    } else if n >= 4 && last == k {
      return SeqClass(seq: seq, desc: "Sociable[\(n - 1)]")
    } else if last == seq[n - 2] {
      return SeqClass(seq: seq, desc: "Aspiring")
    } else if seq.dropFirst().dropLast(2).contains(last) {
      return SeqClass(seq: seq, desc: "Cyclic[\(n - 1 - seq.firstIndex(of: last)!)]")
    } else if n == 16 || last > threshold {
      return SeqClass(seq: seq, desc: "Non-terminating")
    }
  }

  fatalError()
}

for i in 1...10 {
  print("\(i): \(classifySequence(k: i))")
}

print()

for i in [11, 12, 28, 496, 220, 1184, 12496, 1264460, 790, 909, 562, 1064, 1488] {
  print("\(i): \(classifySequence(k: i))")
}

print()

print("\(15355717786080): \(classifySequence(k: 15355717786080))")
