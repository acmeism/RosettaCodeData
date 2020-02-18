import Foundation

extension BinaryInteger {
  @inlinable
  public var isSelfDescribing: Bool {
    let stringChars = String(self).map({ String($0) })
    let counts = stringChars.reduce(into: [Int: Int](), {res, char in res[Int(char), default: 0] += 1})

    for (i, n) in stringChars.enumerated() where counts[i, default: 0] != Int(n) {
      return false
    }

    return true
  }
}

print("Self-describing numbers less than 100,000,000:")

DispatchQueue.concurrentPerform(iterations: 100_000_000) {i in
  defer {
    if i == 100_000_000 - 1 {
      exit(0)
    }
  }

  guard i.isSelfDescribing else {
    return
  }

  print(i)
}

dispatchMain()
