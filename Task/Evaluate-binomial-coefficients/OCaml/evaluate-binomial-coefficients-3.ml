open Num;;
let rec binomial n k = if n = k then Int 1 else ((binomial (n-1) k) */ Int n) // Int (n-k)
