proc foo(): string =
  echo "Foo()"
  "mystring"

let n = 100
var ws = newSeq[string](n)
for i in 0 .. <n: ws[i] = foo()
