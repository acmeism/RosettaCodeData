-module( sieve ).
-export( [main/1,primes/2] ).

main(N) -> io:format("Primes: ~w~n", [ primes(2,N) ]).

primes(M,N) -> primes(M, N,lists:seq( M, N ),[]).

primes(M,N,_Acc,Tuples) when M > N/2-> out(Tuples);

primes(M,N,Acc,Tuples) when length(Tuples) < 1 ->
        primes(M,N,Acc,[{X, X} || X <- Acc]);

primes(M,N,Acc,Tuples) ->
        {SqrtN, _T} = lists:split( erlang:round(math:sqrt(N)), Acc ),
        F = Tuples,
        Ms = lists:filtermap(fun(X) -> if X > 0 -> {true, X * M}; true -> false end end, SqrtN),
        P = lists:filtermap(fun(T) ->
            case lists:keymember(T,1,F) of true ->
            {true, lists:keyreplace(T,1,F,{T,0})};
             _-> false end end,  Ms),
        AA = mergeT(P,lists:last(P),1 ),
        primes(M+1,N,Acc,AA).

mergeT(L,M,Acc) when Acc == length(L) -> M;
mergeT(L,M,Acc) ->
        A = lists:nth(Acc,L),
        B = M,
        Mer = lists:zipwith(fun(X, Y) -> if X < Y -> X; true -> Y end end, A, B),
        mergeT(L,Mer,Acc+1).

out(Tuples) ->
        Primes = lists:filter( fun({_,Y}) -> Y > 0 end,  Tuples),
        [ X || {X,_} <- Primes ].
