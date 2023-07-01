func levDis(w1: String, w2: String) -> Int {

  let (t, s) = (w1.characters, w2.characters)

  let empty = Repeat(count: s.count, repeatedValue: 0)
  var last = [Int](0...s.count)

  for (i, tLett) in t.enumerate() {
    var cur = [i + 1] + empty
    for (j, sLett) in s.enumerate() {
      cur[j + 1] = tLett == sLett ? last[j] : min(last[j], last[j + 1], cur[j]).successor()
    }
    last = cur
  }
  return last.last!
}
