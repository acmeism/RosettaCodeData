func levDis(w1: String, w2: String) -> Int {

  let (t, s) = (w1.characters, w2.characters)

  let empty = Repeat(count: s.count, repeatedValue: 0)
  var mat = [[Int](0...s.count)] + (1...t.count).map{[$0] + empty}

  for (i, tLett) in t.enumerate() {
    for (j, sLett) in s.enumerate() {
      mat[i + 1][j + 1] = tLett == sLett ?
        mat[i][j] : min(mat[i][j], mat[i][j + 1], mat[i + 1][j]).successor()
    }
  }
  return mat.last!.last!
}
