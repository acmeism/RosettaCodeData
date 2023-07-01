func addCombo(prevCombo: [Int], var pivotList: [Int]) -> [([Int], [Int])] {

  return (0..<pivotList.count)
    .map {
      _ -> ([Int], [Int]) in
      (prevCombo + [pivotList.removeAtIndex(0)], pivotList)
    }
}
func combosOfLength(n: Int, m: Int) -> [[Int]] {

  return [Int](1...m)
    .reduce([([Int](), [Int](0..<n))]) {
      (accum, _) in
      accum.flatMap(addCombo)
    }.map {
      $0.0
    }
}

println(combosOfLength(5, 3))
