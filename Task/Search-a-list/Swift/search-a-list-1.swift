let haystack = ["Zig","Zag","Wally","Ronald","Bush","Krusty","Charlie","Bush","Bozo"]
for needle in ["Washington","Bush"] {
  if let index = haystack.indexOf(needle) {
    print("\(index) \(needle)")
  } else {
    print("\(needle) is not in haystack")
  }
}
