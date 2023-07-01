merge_sort(List) -> m(List, erlang:system_info(schedulers)).

m([L],_) -> [L];
m(L, N) when N > 1  ->
    {L1,L2} = lists:split(length(L) div 2, L),
    {Parent, Ref} = {self(), make_ref()},
    spawn(fun()-> Parent ! {l1, Ref, m(L1, N-2)} end),
    spawn(fun()-> Parent ! {l2, Ref, m(L2, N-2)} end),
    {L1R, L2R} = receive_results(Ref, undefined, undefined),
    lists:merge(L1R, L2R);
m(L, _) -> {L1,L2} = lists:split(length(L) div 2, L), lists:merge(m(L1, 0), m(L2, 0)).

receive_results(Ref, L1, L2) ->
    receive
        {l1, Ref, L1R} when L2 == undefined -> receive_results(Ref, L1R, L2);
        {l2, Ref, L2R} when L1 == undefined -> receive_results(Ref, L1, L2R);
        {l1, Ref, L1R} -> {L1R, L2};
        {l2, Ref, L2R} -> {L1, L2R}
    after 5000 -> receive_results(Ref, L1, L2)
    end.
