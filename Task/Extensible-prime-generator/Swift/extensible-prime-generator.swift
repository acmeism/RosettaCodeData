import Foundation

func soeDictOdds() -> UnfoldSequence<Int, Int> {
  var bp = 5; var q = 25
  var bps: UnfoldSequence<Int, Int>.Iterator? = nil
  var dict = [9: 6] // Dictionary<Int, Int>(9 => 6)
  return sequence(state: 2, next: { n in
    if n < 9 { if n < 3 { n = 3; return 2 }; defer {n += 2}; return n }
    while n >= q || dict[n] != nil {
      if n >= q {
        let inc = bp + bp
        dict[n + inc] = inc
        if bps == nil {
          bps = soeDictOdds().makeIterator()
          bp = (bps?.next())!; bp = (bps?.next())!; bp = (bps?.next())! // skip 2/3/5...
        }
        bp = (bps?.next())!; q = bp * bp // guaranteed never nil
      } else {
        let inc = dict[n] ?? 0
        dict[n] = nil
        var next = n + inc
        while dict[next] != nil { next += inc }
        dict[next] = inc
      }
      n += 2
    }
    defer { n += 2 }; return n
  })
}

print("The first 20 primes are:  ", terminator: "")
soeDictOdds().lazy.prefix(20).forEach { print($0, "", terminator: "") }
print()

print("The primes between 100 and 150 are:  ", terminator: "")
soeDictOdds().lazy.drop(while: { $0 < Prime(100) }).lazy.prefix(while: { $0 <= 150 })
    .forEach { print($0, "", terminator: "") }
print()

print("The number of primes from 7700 to 8000 is  :", terminator: "")
print(soeDictOdds().lazy.drop(while: { $0 < 7700 }).lazy.prefix(while: { $0 <= 8000 })
        .lazy.reduce(0, { a, _ in a + 1 }))

print("The 10,000th prime is:  ", terminator: "")
print((soeDictOdds().lazy.dropFirst(9999).first { $0 == $0 })!)

print("The sum of primes to 2 million is:  ", terminator: "")

let start = NSDate()
let answr = soeDictOdds().lazy.prefix(while: { $0 <= 2000000 })
              .reduce(0, { a, p in a + Int64(p) })
let elpsd = -start.timeIntervalSinceNow

print(answr)
print(String(format: "This test took %.3f milliseconds.", elpsd * 1000))
