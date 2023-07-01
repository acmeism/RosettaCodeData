 %% Implemented by Arjun Sunel
-module(even_odd2).
-export([main/0]).

main()->
	test(10).

test(N) ->
	if (N band 1)==1 ->
		io:format("odd\n");
	true ->
		io:format("even\n")
	end.
