import Darwin

func shuffle<T>(inout array: [T]) {
  for i in 1..<array.count {
    let j = Int(arc4random_uniform(UInt32(i)))
    (array[i], array[j]) = (array[j], array[i])
  }
}

func issorted<T:Comparable>(ary: [T]) -> Bool {
  for i in 0..<(ary.count-1) {
    if ary[i] > ary[i+1] {
      return false
    }
  }
  return true
}

func bogosort<T:Comparable>(inout ary: [T]) {
  while !issorted(ary) {
    shuffle(&ary)
  }
}
