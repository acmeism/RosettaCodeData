module Fruits
  APPLE  = 0
  BANANA = 1
  CHERRY = 2
end

# It is possible to use a symbol if the value is unrelated.

FRUITS = [:apple, :banana, :cherry]
val = :banana
FRUITS.include?(val)      #=> true
