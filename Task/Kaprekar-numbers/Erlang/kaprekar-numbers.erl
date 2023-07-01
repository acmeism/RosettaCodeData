-mode(compile).
-import(lists, [seq/2]).

kaprekar(1) -> true;
kaprekar(N) when N < 1 -> false;
kaprekar(N) ->
    Sq = N*N,
    if
        (N rem 9) =/= (Sq rem 9) -> false;
        true -> kaprekar(N, Sq, 10)
    end.

kaprekar(_, Sq,  M) when (Sq div M) =:= 0 -> false;
kaprekar(N, Sq, M) ->
    L = Sq div M,
    R = Sq rem M,
    if
        R =/= 0 andalso (L + R) =:= N -> true;
        true -> kaprekar(N, Sq, M * 10)
    end.

main(_) ->
    Numbers = [N || N <- seq(1, 9999), kaprekar(N)],
    io:format("The Kaprekar numbers < 10,000 are ~p~n", [Numbers]),

    CountTo1e6 = length(Numbers) + length([N || N <- seq(10001, 999999), kaprekar(N)]),
    io:format("There are ~p Kaprekar numbers < 1,000,000", [CountTo1e6]).
