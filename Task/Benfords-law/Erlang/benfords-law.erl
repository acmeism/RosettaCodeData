-module( benfords_law ).
-export( [actual_distribution/1, distribution/1, task/0] ).

actual_distribution( Ns ) -> lists:foldl( fun first_digit_count/2, dict:new(), Ns ).

distribution( N ) -> math:log10( 1 + (1 / N) ).

task() ->
	Total = 1000,
	Fibonaccis = fib( Total ),
	Actual_dict = actual_distribution( Fibonaccis ),
	Keys = lists:sort( dict:fetch_keys( Actual_dict) ),
	io:fwrite( "Digit	Actual	Benfords expected~n" ),
	[io:fwrite("~p	~p	~p~n", [X, dict:fetch(X, Actual_dict) / Total, distribution(X)]) || X <- Keys].



fib( N ) -> fib( N, 0, 1, [] ).
fib( 0, Current, _, Acc ) -> lists:reverse( [Current | Acc] );
fib( N, Current, Next, Acc ) -> fib( N-1, Next, Current+Next, [Current | Acc] ).

first_digit_count( 0, Dict ) -> Dict;
first_digit_count( N, Dict ) ->
	[Key | _] = erlang:integer_to_list( N ),
	dict:update_counter( Key - 48, 1, Dict ).
