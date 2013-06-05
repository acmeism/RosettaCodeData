%% Implemented by Arjun Sunel
-module(even_odd).
-export([main/0]).

main()->
	test(8).

test(N) ->
	if (N rem 2)==1 ->
		io:format("odd\n");
	true ->
		io:format("even\n")
	end.			
