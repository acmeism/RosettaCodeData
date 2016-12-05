type Fruits = enum Apple, Banana, Cherry

type Fruits = enum Apple = 0, Banana = 1, Cherry = 2 # with values

type Fruits {.pure.} = enum Apple, Banana, Cherry # scoped enum
var i: int = Apple # error for scoped enum

type Fruits = enum Apple = "Apple", Banana = "Banana", Cherry = "Cherry" # with string literals
