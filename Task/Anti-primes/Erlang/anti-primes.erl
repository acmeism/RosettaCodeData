divcount(N) -> divcount(N, 1, 0).

divcount(N, D, Count) when D*D > N -> Count;
divcount(N, D, Count) ->
    Divs = case N rem D of
        0 ->
            case N - D*D of
                0 -> 1;
                _ -> 2
            end;
        _ -> 0
    end,
    divcount(N, D + 1, Count + Divs).


antiprimes(N) -> antiprimes(N, 1, 0, []).

antiprimes(0, _, _, L) -> lists:reverse(L);
antiprimes(N, M, Max, L) ->
    Count = divcount(M),
    case Count > Max of
        true  -> antiprimes(N-1, M+1, Count, [M|L]);
        false -> antiprimes(N, M+1, Max, L)
    end.


main(_) ->
    io:format("The first 20 anti-primes are ~w~n", [antiprimes(20)]).
