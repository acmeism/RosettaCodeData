import Data.List (permutations)

permutationSort l = head [p | p <- permutations l, sorted p]

sorted (e1 : e2 : r) = e1 <= e2 && sorted (e2 : r)
sorted _             = True
