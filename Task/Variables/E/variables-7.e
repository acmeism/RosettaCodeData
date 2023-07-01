def makeSum() {
  var a := 0
  var b := 0
  return [&a, &b, fn { a + b }]
}

def [&x, &y, sum] := makeSum()
x := 3
y := 4
sum() # returns 7
