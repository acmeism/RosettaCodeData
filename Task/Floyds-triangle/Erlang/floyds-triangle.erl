% Implemented by Arjun Sunel
-module(floyd).
-export([main/0]).

main() ->
		floyd_triangle(5),
		io:format("\n"),
		floyd_triangle(14).

floyd_triangle(N) ->
		D=length(lists:flatten(io_lib:format("~p", [N*(N+1)div 2]))),
		lists: foreach(fun(X) -> floyd((1+X*(X+1)div 2)-X, X*(X+1)div 2,D) end,lists:seq(1,N)).
				
floyd(L, E ,D) ->
		if
			L =< E  ->
				F=length(lists:flatten(io_lib:format("~p", [L]))),
				space(F,D,L),
				floyd(L+1, E,D);
			true ->
				io:format("\n")
		end.

space(F,D, L) ->
	if
		 F < D ->
			io:format(" "),
			space(F+1,D,L);
		true ->
			io:format(" ~p",[L])
	end.		
