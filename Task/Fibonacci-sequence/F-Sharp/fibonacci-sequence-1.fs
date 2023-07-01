let fibonacci n : bigint =
  let rec f a b n =
    match n with
    | 0 -> a
    | 1 -> b
    | n -> (f b (a + b) (n - 1))
  f (bigint 0) (bigint 1) n
> fibonacci 100;;
val it : bigint = 354224848179261915075I
