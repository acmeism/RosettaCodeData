proc splitOnDiff(str: string): string =
  result = ""

  if str.len < 1: return result

  var prevChar: char = str[0]

  for idx in 0 ..< str.len:
    if str[idx] != prevChar:
      result &= ", "
      prevChar = str[idx]

    result &= str[idx]

assert splitOnDiff("""X""") == """X"""
assert splitOnDiff("""XX""") == """XX"""
assert splitOnDiff("""XY""") == """X, Y"""
assert splitOnDiff("""gHHH5YY++///\""") == """g, HHH, 5, YY, ++, ///, \"""

echo splitOnDiff("""gHHH5YY++///\""")
