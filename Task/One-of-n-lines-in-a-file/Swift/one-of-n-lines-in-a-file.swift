func one_of_n(n: Int) -> Int {
  var result = 1
  for i in 2...n {
    if arc4random_uniform(UInt32(i)) < 1 {
      result = i
    }
  }
  return result
}

var counts = [0,0,0,0,0,0,0,0,0,0]
for _ in 1..1_000_000 {
  counts[one_of_n(10)-1]++
}

println(counts)
