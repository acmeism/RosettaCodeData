-mode(compile).

main(_) ->
    ets:new(pN, [set, named_table, protected]),
    io:format("~w~n", [p(6666)]).

p(0) -> 1;
p(N) ->
    case ets:lookup(pN, N) of
        [{N, Pn}] -> Pn;
        [] ->
            Terms = [p(N - G) || G <- gpentagonals(N)],
            Pn = sum_partitions(Terms),
            ets:insert(pN, {N, Pn}),
            Pn
    end.

sum_partitions(Terms) -> sum_partitions(Terms, 0, 0).
sum_partitions([], _, Sum) -> Sum;
sum_partitions([N|Ns], Sgn, Sum) ->
    Summand = case Sgn < 2 of
        true  -> N;
        false -> -N
    end,
    sum_partitions(Ns, (Sgn+1) band 3, Sum + Summand).

gpentagonals(Max) -> gpentagonals(1, Max, [0]).
gpentagonals(M, Max, Ps = [N|_]) ->
    GP = N + case M rem 2 of
                0 -> M div 2;
                1 -> M
             end,
    if
        GP > Max -> tl(lists:reverse(Ps));
        true -> gpentagonals(M + 1, Max, [GP|Ps])
    end.
