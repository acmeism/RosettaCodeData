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
