type
  Foo = object
    a: float
    b: string
    c: seq[int]
let f = Foo(a: 0.9, b: "hi", c: @[1,2,3])
for n, v in f.fieldPairs:
  echo n, ": ", v
