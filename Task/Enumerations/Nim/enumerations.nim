# Simple declaration.
type Fruits1 = enum aApple, aBanana, aCherry

# Specifying values (accessible using "ord").
type Fruits2 = enum bApple = 0, bBanana = 2, bCherry = 5

# Enumerations with a scope which prevent name conflict.
type Fruits3 {.pure.} = enum Apple, Banana, Cherry
type Fruits4 {.pure.} = enum Apple = 3, Banana = 8, Cherry = 10
var x = Fruits3.Apple  # Need to qualify as there are several possible "Apple".

# Using vertical presentation and specifying string representation.
type Fruits5 = enum
  cApple = "Apple"
  cBanana = "Banana"
  cCherry = "Cherry"
echo cApple   # Will display "Apple".

# Specifying values and/or string representation.
type Fruits6 = enum
  Apple = (1, "apple")
  Banana = 3            # implicit name is "Banana".
  Cherry = "cherry"     # implicit value is 4.
