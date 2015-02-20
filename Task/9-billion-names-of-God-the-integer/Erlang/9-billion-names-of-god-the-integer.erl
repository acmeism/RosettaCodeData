-module(god_the_integer).
-export([example/0, names/1, print_pyramid/1]).

example() ->
	Names = names( 10 ),
	print_pyramid( Names ).

names( N ) ->
	[names_row(X) || X <- lists:seq(1, N)].

print_pyramid( Names ) ->
	Width = erlang:length( lists:last(Names) ),
	[print_pyramid_row(Width, X) || X <- Names].



names_row( M ) ->
	[p(M, X) || X <- lists:seq(1, M)].

p( N, K ) when K > N -> 0;
p( N, N ) -> 1;
p( _N, 0 ) -> 0;
p( N, K ) ->
	p( N - 1, K - 1 ) + p( N - K, K ).

print_pyramid_row( Width, Row ) ->
	   io:fwrite( "~*s", [Width - erlang:length(Row), " "] ),
	   [io:fwrite("~p ", [X]) || X <- Row],
	   io:nl().
