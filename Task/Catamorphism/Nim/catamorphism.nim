import sequtils

block:
  let
    numbers = @[5, 9, 11]
    addition = foldl(numbers, a + b)
    substraction = foldl(numbers, a - b)
    multiplication = foldl(numbers, a * b)
    words = @["nim", "rod", "is", "cool"]
    concatenation = foldl(words, a & b)

block:
  let
    numbers = @[5, 9, 11]
    addition = foldr(numbers, a + b)
    substraction = foldr(numbers, a - b)
    multiplication = foldr(numbers, a * b)
    words = @["nim", "rod", "is", "cool"]
    concatenation = foldr(words, a & b)
