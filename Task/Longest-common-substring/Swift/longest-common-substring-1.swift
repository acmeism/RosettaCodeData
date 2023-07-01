func lComSubStr<
  S0: Sliceable, S1: Sliceable, T: Equatable where
  S0.Generator.Element == T, S1.Generator.Element == T,
  S0.Index.Distance == Int, S1.Index.Distance == Int
  >(w1: S0, _ w2: S1) -> S0.SubSlice {

    var (len, end) = (0, 0)

    let empty = Array(Repeat(count: w2.count + 1, repeatedValue: 0))
    var mat: [[Int]] = Array(Repeat(count: w1.count + 1, repeatedValue: empty))

    for (i, sLett) in w1.enumerate() {
      for (j, tLett) in w2.enumerate() where tLett == sLett {
        let curLen = mat[i][j] + 1
        mat[i + 1][j + 1] = curLen
        if curLen > len {
          len = curLen
          end = i
        }
      }
    }
    return w1[advance(w1.startIndex, (end + 1) - len)...advance(w1.startIndex, end)]
}

func lComSubStr(w1: String, _ w2: String) -> String {
  return String(lComSubStr(w1.characters, w2.characters))
}
