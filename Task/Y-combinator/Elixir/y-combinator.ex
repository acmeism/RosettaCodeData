iex(1)> yc = fn f -> (fn x -> x.(x) end).(fn y -> f.(fn arg -> y.(y).(arg) end) end) end
#Function<6.90072148/1 in :erl_eval.expr/5>
iex(2)> fac = fn f -> fn n -> if n < 2 do 1 else n * f.(n-1) end end end
#Function<6.90072148/1 in :erl_eval.expr/5>
iex(3)> for i <- 0..9, do: yc.(fac).(i)
[1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880]
iex(4)> fib = fn f -> fn n -> if n == 0 do 0 else (if n == 1 do 1 else f.(n-1) + f.(n-2) end) end end end
#Function<6.90072148/1 in :erl_eval.expr/5>
iex(5)> for i <- 0..9, do: yc.(fib).(i)
[0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
