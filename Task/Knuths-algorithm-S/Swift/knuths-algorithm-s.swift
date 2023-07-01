import Darwin

func s_of_n_creator<T>(n: Int) -> T -> [T]  {
  var sample = [T]()
  var i = 0
  return {(item: T) in
    i++
    if (i <= n) {
      sample.append(item)
    } else if (Int(arc4random_uniform(UInt32(i))) < n) {
      sample[Int(arc4random_uniform(UInt32(n)))] = item
    }
    return sample
  }
}

var bin = [Int](count:10, repeatedValue:0)
for trial in 0..<100000 {
  let s_of_n: Int -> [Int] = s_of_n_creator(3)
  var sample: [Int] = []
  for i in 0..<10 {
    sample = s_of_n(i)
  }
  for s in sample {
    bin[s]++
  }
}
println(bin)
