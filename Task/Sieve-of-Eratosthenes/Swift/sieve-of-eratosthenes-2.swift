func soePackedOdds(_ n: Int) ->
    LazyMapSequence<UnfoldSequence<Int, (Int?, Bool)>, Int> {

  let lmti = (n - 3) / 2
  let size = lmti / 8 + 1
  var sieve = Array<UInt8>(repeating: 0, count: size)
  let sqrtlmti = (Int(sqrt(Double(n))) - 3) / 2

  for i in 0...sqrtlmti {
    if sieve[i >> 3] & (1 << (i & 7)) == 0 {
      let p = i + i + 3
      for c in stride(from: (i*(i+3)<<1)+3, through: lmti, by: p) {
        sieve[c >> 3] |= 1 << (c & 7)
      }
    }
  }

  return sequence(first: -1, next: { (i:Int) -> Int? in
      var ni = i + 1
      while ni <= lmti && sieve[ni >> 3] & (1 << (ni & 7)) != 0 { ni += 1}
      return ni > lmti ? nil : ni
    }).lazy.map { $0 < 0 ? 2 : $0 + $0 + 3 }
}
