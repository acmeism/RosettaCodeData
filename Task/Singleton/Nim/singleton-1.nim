type Singleton = object # Singleton* would export
  foo*: int

var single* = Singleton(foo: 0)
