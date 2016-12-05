% Put this code in return_multi.erl and run it as "escript return_multi.erl"

-module(return_multi).

main(_) ->
        {C, D, E} = multiply(3, 4),
        io:format("~p ~p ~p~n", [C, D, E]).

multiply(A, B) ->
        {A * B, A + B, A - B}.
