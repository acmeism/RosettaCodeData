@show 5 ^ 3 ^ 2 # default: power operator is read right-to-left
@show (5 ^ 3) ^ 2
@show 5 ^ (3 ^ 2)
@show reduce(^, [5, 3, 2])
@show foldl(^, [5, 3, 2]) # guarantees left associativity
@show foldr(^, [5, 3, 2]) # guarantees right associativity
