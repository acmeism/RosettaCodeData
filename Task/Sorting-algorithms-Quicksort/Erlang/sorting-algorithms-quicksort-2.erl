quick_sort(L) -> qs(L, trunc(math:log2(erlang:system_info(schedulers)))).

qs([],_) -> [];
qs([H|T], N) when N > 0  ->
    {Parent, Ref} = {self(), make_ref()},
    spawn(fun()-> Parent ! {l1, Ref, qs([E||E<-T, E<H], N-1)} end),
    spawn(fun()-> Parent ! {l2, Ref, qs([E||E<-T, H =< E], N-1)} end),
    {L1, L2} = receive_results(Ref, undefined, undefined),
    L1 ++ [H] ++ L2;
qs([H|T],_) ->
    qs([E||E<-T, E<H],0) ++ [H] ++ qs([E||E<-T, H =< E],0).

receive_results(Ref, L1, L2) ->
    receive
        {l1, Ref, L1R} when L2 == undefined -> receive_results(Ref, L1R, L2);
        {l2, Ref, L2R} when L1 == undefined -> receive_results(Ref, L1, L2R);
        {l1, Ref, L1R} -> {L1R, L2};
        {l2, Ref, L2R} -> {L1, L2R}
    after 5000 -> receive_results(Ref, L1, L2)
    end.
