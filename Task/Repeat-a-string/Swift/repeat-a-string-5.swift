extension String {
  func repeatBiterative(count: Int) -> String {
        var reduceCount = count
        var result = ""
        var doubled = self
        while reduceCount != 0 {
            if reduceCount & 1 == 1 {
                result.appendContentsOf(doubled)
            }
            reduceCount >>= 1
            if reduceCount != 0 {
                doubled.appendContentsOf(doubled)
            }
        }
        return result
    }
}

"He".repeatBiterative(5)
