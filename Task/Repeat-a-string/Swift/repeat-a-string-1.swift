extension String {
  // Slower version
  func repeatString(n: Int) -> String {
    return Array(count: n, repeatedValue: self).joinWithSeparator("")
  }

  // Faster version
  // benchmarked with a 1000 characters and 100 repeats the fast version is approx 500 000 times faster :-)
  func repeatString2(n:Int) -> String {
    var result = self
    for _ in 1 ..< n {
      result.appendContentsOf(self)   // Note that String.appendContentsOf is up to 10 times faster than "result += self"
    }
    return result
  }
}

print( "ha".repeatString(5) )
print( "he".repeatString2(5) )
