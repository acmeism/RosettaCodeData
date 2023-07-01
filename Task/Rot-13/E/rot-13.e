pragma.enable("accumulator")

var rot13Map := [].asMap()
for a in ['a', 'A'] {
    for i in 0..!26 {
        rot13Map with= (a + i, E.toString(a + (i + 13) % 26))
    }
}

def rot13(s :String) {
  return accum "" for c in s { _ + rot13Map.fetch(c, fn{ c }) }
}
