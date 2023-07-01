def rle(string) {
  var seen := null
  var count := 0
  var result := []
  def put() {
    if (seen != null) {
      result with= [count, seen]
    }
  }
  for ch in string {
    if (ch != seen) {
      put()
      seen := ch
      count := 0
    }
    count += 1
  }
  put()
  return result
}

def unrle(coded) {
  var result := ""
  for [count, ch] in coded {
    result += E.toString(ch) * count
  }
  return result
}
