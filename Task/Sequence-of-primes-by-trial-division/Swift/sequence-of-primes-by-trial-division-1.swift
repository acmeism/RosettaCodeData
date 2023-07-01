import Foundation

extension SequenceType {
  func takeWhile(include: Generator.Element -> Bool) -> AnyGenerator<Generator.Element> {
    var g = self.generate()
    return anyGenerator { g.next().flatMap{include($0) ? $0 : nil }}
  }
}

var pastPrimes = [2]

var primes = anyGenerator {
  _ -> Int? in
  defer {
    pastPrimes.append(pastPrimes.last!)
    let c = pastPrimes.count - 1
    for p in anyGenerator({++pastPrimes[c]}) {
      let lim = Int(sqrt(Double(p)))
      if (!pastPrimes.takeWhile{$0 <= lim}.contains{p % $0 == 0}) { break }
    }
  }
  return pastPrimes.last
}
