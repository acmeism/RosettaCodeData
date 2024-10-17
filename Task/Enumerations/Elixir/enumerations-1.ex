fruits = [:apple, :banana, :cherry]
fruits = ~w(apple banana cherry)a                   # Above-mentioned different notation
val = :banana
Enum.member?(fruits, val)                           #=> true
val in fruits                                       #=> true
