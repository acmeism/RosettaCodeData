factors(N) ->
    [I || I <- lists:seq(1,trunc(math:sqrt(N))), N rem I == 0]++[N].
