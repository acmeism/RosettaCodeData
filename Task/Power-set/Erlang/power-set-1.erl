powerset(Lst) ->
    N = length(Lst),
    Max = trunc(math:pow(2,N)),
    [[lists:nth(Pos+1,Lst) || Pos <- lists:seq(0,N-1), I band (1 bsl Pos) =/= 0]
      || I <- lists:seq(0,Max-1)].
