type Foo* = object
  a: string
  b: string
  c: int

proc createFoo*(a, b, c): Foo =
  Foo(a: a, b: b, c: c)
