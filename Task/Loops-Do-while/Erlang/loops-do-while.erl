do() ->
	io:format("0~n"),
	do(1).
	
do(N) when N rem 6 =:= 0 ->
	io:format("~w~n", [N]);
do(N) ->
	io:format("~w~n", [N]),
	do(N+1).
