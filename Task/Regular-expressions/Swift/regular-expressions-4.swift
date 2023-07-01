  for x in regex.matchesInString(str, options: nil, range: NSRange(location: 0, length: count(str.utf16))) {
    let match = x as! NSTextCheckingResult
    // match.range gives the range of the whole match
    // match.rangeAtIndex(i) gives the range of the i'th capture group (starting from 1)
  }
