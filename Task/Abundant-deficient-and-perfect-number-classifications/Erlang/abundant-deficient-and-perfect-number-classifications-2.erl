-module(proper_divisors).
-export([classify_range/2]).

classify_range(Start, Stop) ->
    lists:foldl(fun (X, A) ->
                  Class = classify(X),
                  A#{Class => maps:get(Class, A, 0)+1} end,
                #{},
                lists:seq(Start, Stop)).

classify(N) ->
    SumPD = lists:sum(proper_divisors(N)),
    if
        SumPD  <  N -> deficient;
        SumPD =:= N -> perfect;
        SumPD  >  N -> abundant
    end.

proper_divisors(1) -> [];
proper_divisors(N) when N > 1, is_integer(N) ->
    proper_divisors(2, math:sqrt(N), N, [1]).

proper_divisors(I, L, _, A) when I > L -> lists:sort(A);
proper_divisors(I, L, N, A) when N rem I =/= 0 ->
    proper_divisors(I+1, L, N, A);
proper_divisors(I, L, N, A) when I * I =:= N ->
    proper_divisors(I+1, L, N, [I|A]);
proper_divisors(I, L, N, A) ->
    proper_divisors(I+1, L, N, [N div I, I|A]).
